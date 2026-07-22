//
//  OceanBloomEffect.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import Combine
import Foundation
import Metal
import MetalPerformanceShaders
import RealityKit
import SwiftUI

@available(visionOS, unavailable)
@available(macOS 15.0, iOS 18.0, tvOS 18.0, *)
final class OceanBloomEffect: PostProcessEffect, @unchecked Sendable {

    var bloomTexture: MTLTexture?
    var illuminationTexture: MTLTexture?

    /// Bloom threshold (isolates bright sun & ocean highlights)
    let bloomThreshold: Float = 0.55

    /// Gaussian blur sigma (creates soft tropical atmosphere)
    let bloomBlur: Float = 28.0

    init() {}

    func postProcess(context: borrowing PostProcessEffectContext<any MTLCommandBuffer>) {
        let commandBuffer = context.commandBuffer

        if bloomTexture == nil ||
            bloomTexture?.width != context.sourceColorTexture.width ||
            bloomTexture?.height != context.sourceColorTexture.height {
            bloomTexture = makeEmptyTextureLike(context.sourceColorTexture, device: context.device)
            illuminationTexture = makeEmptyTextureLike(context.sourceColorTexture, device: context.device)
        }
        guard let illuminationTexture, var bloomTexture = bloomTexture else { return }

        // 1. Isolate bright tropical highlights
        let brightness = MPSImageThresholdToZero(
            device: context.device,
            thresholdValue: bloomThreshold,
            linearGrayColorTransform: [1.1, 1.0, 0.8]
        )

        brightness.encode(
            commandBuffer: commandBuffer,
            sourceTexture: context.sourceColorTexture,
            destinationTexture: illuminationTexture
        )

        // 2. Multiply with source texture to preserve vibrant colors
        let multiply = MPSImageMultiply(device: context.device)
        multiply.primaryScale = 1.0
        multiply.secondaryScale = 1.0
        multiply.bias = 0.0
        multiply.encode(
            commandBuffer: commandBuffer,
            primaryTexture: illuminationTexture,
            secondaryTexture: context.sourceColorTexture,
            destinationTexture: bloomTexture
        )

        // 3. Apply Gaussian blur for soft tropical glow
        let gaussianBlur = MPSImageGaussianBlur(device: context.device, sigma: bloomBlur)
        gaussianBlur.encode(commandBuffer: commandBuffer, inPlaceTexture: &bloomTexture)

        // 4. Add bloom back onto final target frame
        let add = MPSImageAdd(device: context.device)
        add.primaryScale = 0.8
        add.secondaryScale = 0.5
        add.encode(
            commandBuffer: commandBuffer,
            primaryTexture: context.sourceColorTexture,
            secondaryTexture: bloomTexture,
            destinationTexture: context.targetColorTexture
        )
    }

    func makeEmptyTextureLike(_ source: MTLTexture, device: MTLDevice) -> MTLTexture? {
        let desc = MTLTextureDescriptor()
        desc.textureType = source.textureType
        desc.pixelFormat = source.pixelFormat
        desc.width = source.width
        desc.height = source.height
        desc.mipmapLevelCount = 1
        desc.usage = [.shaderRead, .shaderWrite]
        desc.storageMode = .shared
        guard let texture = device.makeTexture(descriptor: desc)
        else { return nil }

        let width = desc.width
        let height = desc.height
        let bytesPerPixel: Int = {
            switch source.pixelFormat {
            case .bgra8Unorm_srgb: return 4
            case .bgra10_xr_srgb: return 5
            case .rgba16Float: return 8
            default:
                return 4
            }
        }()
        let bytesPerRow = width * bytesPerPixel
        let emptyData = [UInt8](repeating: 0, count: bytesPerRow * height)

        let region = MTLRegionMake2D(0, 0, width, height)
        texture.replace(region: region, mipmapLevel: 0, withBytes: emptyData, bytesPerRow: bytesPerRow)
        return texture
    }

    static func deviceSupportsEffect() -> Bool {
        let device = MTLCreateSystemDefaultDevice()
        return device?.supportsFamily(.apple8) ?? false
    }
}
