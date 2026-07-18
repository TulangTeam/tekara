//
//  GameplayView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import SwiftUI
import RealityKit
import TekaraAssets
import ThumbStickView

// ==========================================
// REALITYKIT ECS: GROUNDING SYSTEM
// ==========================================
public struct GroundingComponent: Component {
    var capsuleOffset: Float = 0.0
    public init() {}
}

public class GroundingSystem: RealityKit.System {
    private static let query = EntityQuery(where: .has(GroundingComponent.self))

    required public init(scene: RealityKit.Scene) { }

    public func update(context: SceneUpdateContext) {
        context.scene.performQuery(Self.query).forEach { character in
            guard let groundingComp = character.components[GroundingComponent.self] as? GroundingComponent,
                  let scene = character.scene else { return }

            let worldPos = character.position(relativeTo: nil)
            let rayOrigin = SIMD3<Float>(worldPos.x, worldPos.y + 2.0, worldPos.z)
            let rayDirection = SIMD3<Float>(0, -1, 0)

            let hits = scene.raycast(origin: rayOrigin, direction: rayDirection, length: 5.0)

            if let sandHit = hits.first(where: { $0.entity.name == "sand_layer2" }) {
                let localHitPos = character.parent?.convert(position: sandHit.position, from: nil) ?? sandHit.position
                character.position.y = localHitPos.y + groundingComp.capsuleOffset
            }
        }
    }
}

// ==========================================
// GAMEPLAY VIEW (3D Scene)
// ==========================================
struct GameplayView: View {
    var episodeId: Int

    private let isometricAngleX: Float = -35.264
    private let isometricAngleY: Float = 45.0
    private let cameraZoom: Float = 4.5

    @State private var joystickValue: CGPoint = .zero
    private let moveSpeed: Float = 0.0008

    init(episodeId: Int) {
        self.episodeId = episodeId
        GroundingComponent.registerComponent()
        GroundingSystem.registerSystem()
    }

    var body: some View {
        ZStack {
            // LAYER 1: 3D Scene Rendering
            RealityView { content in
                if let sceneEntity = try? await Entity(named: "_WORLD1_CHAP1", in: tekaraAssetsBundle) {
                    content.add(sceneEntity)

                    if let island = sceneEntity.findEntity(named: "Island"),
                       let character = island.findEntity(named: "kai_charaa") {
                        character.components.set(GroundingComponent())
                    }
                }

                // Setup Kamera Fixed Isometric
                let cameraEntity = Entity()
                var cameraComponent = PerspectiveCameraComponent()
                cameraComponent.fieldOfViewInDegrees = 15
                cameraEntity.components.set(cameraComponent)
                cameraEntity.name = "custom_camera"

                let cameraAnchor = AnchorEntity()
                cameraAnchor.name = "camera_anchor"
                cameraAnchor.addChild(cameraEntity)
                content.add(cameraAnchor)

                let radiansX = isometricAngleX * (.pi / 180.0)
                let radiansY = isometricAngleY * (.pi / 180.0)
                let rotationX = simd_quatf(angle: radiansX, axis: SIMD3<Float>(1, 0, 0))
                let rotationY = simd_quatf(angle: radiansY, axis: SIMD3<Float>(0, 1, 0))
                cameraAnchor.transform.rotation = rotationY * rotationX
                cameraEntity.transform.translation = SIMD3<Float>(0, 0, cameraZoom)

            } update: { content in
                guard let island = content.entities.first?.findEntity(named: "Island"),
                      let kai = island.findEntity(named: "kai_charaa"),
                      let cameraAnchor = content.entities.first(where: { $0.name == "camera_anchor" }),
                      let scene = kai.scene else { return }

                // Kamera ikuti Kai secara presisi
                let kaiWorldPos = kai.position(relativeTo: nil)
                cameraAnchor.transform.translation = kaiWorldPos

                // Logika Gerak Kontrol Analog dengan Collision Check
                if joystickValue != .zero {
                    let inputX = Float(joystickValue.x)
                    let inputZ = Float(joystickValue.y)

                    let radiansY = isometricAngleY * (.pi / 180.0)
                    let forwardX = sin(radiansY)
                    let forwardZ = cos(radiansY)
                    let rightX = cos(radiansY)
                    let rightZ = -sin(radiansY)

                    let moveDirectionX = (rightX * inputX) + (forwardX * inputZ)
                    let moveDirectionZ = (rightZ * inputX) + (forwardZ * inputZ)

                    // 1. Hitung posisi target langkah Kai ke depan
                    let targetLocalX = kai.position.x + (moveDirectionX * moveSpeed)
                    let targetLocalZ = kai.position.z + (moveDirectionZ * moveSpeed)

                    let targetLocalPos = SIMD3<Float>(targetLocalX, kai.position.y, targetLocalZ)
                    let targetWorldPos = kai.parent?.convert(position: targetLocalPos, to: nil) ?? targetLocalPos

                    // 2. RAYCAST A: Cek ke Bawah (Apakah masih menapak di atas pasir?)
                    let groundRayOrigin = SIMD3<Float>(targetWorldPos.x, targetWorldPos.y + 2.0, targetWorldPos.z)
                    let groundHits = scene.raycast(origin: groundRayOrigin, direction: SIMD3<Float>(0, -1, 0), length: 5.0)
                    let isOnSand = groundHits.contains(where: { $0.entity.name == "sand_layer2" })

                    // 3. RAYCAST B: Cek ke Depan (Apakah menabrak rintangan horizontal?)
                    let currentWorldPos = kai.position(relativeTo: nil)
                    // Tembak setinggi 0.5 meter (area badan/kaki Kai)
                    let wallRayOrigin = SIMD3<Float>(currentWorldPos.x, currentWorldPos.y + 0.5, currentWorldPos.z)

                    let targetDirection = targetWorldPos - currentWorldPos
                    let distance = simd_length(targetDirection)

                    var hitsObstacle = false

                    if distance > 0.001 {
                        let wallRayDirection = simd_normalize(targetDirection)
                        let wallRayLength = distance + 0.15

                        let wallHits = scene.raycast(origin: wallRayOrigin, direction: wallRayDirection, length: wallRayLength)

                        // Validasi apakah menabrak objek ber-CollisionComponent (selain pasir & diri sendiri)
                        hitsObstacle = wallHits.contains { hit in
                            let isNotKai = hit.entity != kai
                            let isNotSand = hit.entity.name != "sand_layer2"
                            let hasCollision = hit.entity.components.has(CollisionComponent.self)
                            return isNotKai && isNotSand && hasCollision
                        }
                    }

                    // 4. EKSEKUSI PERGERAKAN JIKA LOLOS VALIDASI
                    if isOnSand && !hitsObstacle {
                        kai.position.x = targetLocalX
                        kai.position.z = targetLocalZ
                    }

                    // Rotasi hadap dikunci hanya pada sumbu vertikal Y (anti-tiduran)
                    let angle = atan2(moveDirectionX, moveDirectionZ)
                    kai.transform.rotation = simd_quatf(angle: angle, axis: SIMD3<Float>(0, 1, 0))
                }
            }
            .ignoresSafeArea()

            // LAYER 2: UI Overlay
            VStack {
                Spacer()
                HStack {
                    ThumbStickView(updatingValue: $joystickValue, radius: 60)
                        .frame(width: 120, height: 120)
                        .padding(.leading, 40)
                        .padding(.bottom, 40)

                    Spacer()
                }
            }
        }
    }
}

#Preview {
    GameplayView(episodeId: 1)
}
