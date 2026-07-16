//
//  ContentView.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 15/07/26.
//

import SwiftUI
import RealityKit
import TekaraAssets

struct ContentView: View {
    // 1. State Kamera & Orbit
    @State private var cameraOrbitX: Float = -35.0
    @State private var cameraOrbitY: Float = 45.0
    
    // 2. State Zoom (Sudah didekatkan jaraknya)
    @State private var cameraZoom: Float = 12.0
    @State private var baseZoom: Float = 12.0
    
    // 3. State Pan (Free Camera Bergerak)
    @State private var cameraPan: SIMD3<Float> = .zero
    
    // 4. State Baru: Untuk tracking delta gesture agar tidak melompat liar
    @State private var lastDragTranslation: CGSize = .zero
    @State private var lastPanTranslation: CGSize = .zero
    
    var body: some View {
        RealityView { content in
            if let sceneEntity = try? await Entity(named: "_WORLD1_CHAP1", in: tekaraAssetsBundle) {
                content.add(sceneEntity)
            }
            
            let cameraEntity = Entity()
            var cameraComponent = PerspectiveCameraComponent()
            cameraComponent.fieldOfViewInDegrees = 35
            cameraEntity.components.set(cameraComponent)
            cameraEntity.name = "custom_camera"
            
            let cameraAnchor = AnchorEntity()
            cameraAnchor.name = "camera_anchor"
            cameraAnchor.addChild(cameraEntity)
            content.add(cameraAnchor)
            
            updateCamera(cameraAnchor: cameraAnchor, cameraEntity: cameraEntity)
            
        } update: { content in
            if let cameraAnchor = content.entities.first(where: { $0.name == "camera_anchor" }),
               let cameraEntity = cameraAnchor.findEntity(named: "custom_camera") {
                updateCamera(cameraAnchor: cameraAnchor, cameraEntity: cameraEntity)
            }
        }
        // GESTURE 1: Satu Jari Drag -> Orbit / Putar Kamera (Menggunakan Delta)
        .gesture(
            DragGesture(minimumDistance: 5)
                .onChanged { value in
                    // Hitung perubahan (delta) dari frame sebelumnya
                    let deltaX = Float(value.translation.width - lastDragTranslation.width)
                    let deltaY = Float(value.translation.height - lastDragTranslation.height)
                    
                    let sensitivity: Float = 0.2
                    cameraOrbitY -= deltaX * sensitivity
                    cameraOrbitX += deltaY * sensitivity
                    cameraOrbitX = max(-75, min(-15, cameraOrbitX))
                    
                    // Simpan posisi sekarang untuk frame berikutnya
                    lastDragTranslation = value.translation
                }
                .onEnded { _ in
                    // Reset tracking delta saat jari diangkat
                    lastDragTranslation = .zero
                }
        )
        // GESTURE 2: Dua Jari -> Zoom & Pan Map secara presisi
        .gesture(
            SimultaneousGesture(
                DragGesture(minimumDistance: 5),
                MagnificationGesture()
            )
            .onChanged { value in
                // Bagian Pan 2 Jari menggunakan Delta
                if let drag = value.first {
                    let deltaX = Float(drag.translation.width - lastPanTranslation.width)
                    let deltaY = Float(drag.translation.height - lastPanTranslation.height)
                    
                    // Sensitivitas pan disesuaikan dengan tingkat zoom (makin jauh, pan makin cepat)
                    let panSensitivity: Float = 0.001 * cameraZoom
                    
                    let radiansY = cameraOrbitY * (.pi / 180.0)
                    let moveX = deltaX * cos(radiansY) - deltaY * sin(radiansY)
                    let moveZ = deltaX * sin(radiansY) + deltaY * cos(radiansY)
                    
                    // Akumulasikan posisi pan secara gradual
                    cameraPan += SIMD3<Float>(-moveX * panSensitivity, 0, -moveZ * panSensitivity)
                    
                    lastPanTranslation = drag.translation
                }
                
                // Bagian Zoom
                if let magnify = value.second {
                    let scale = Float(magnify.magnitude)
                    let newZoom = baseZoom * (1.0 / scale)
                    cameraZoom = max(5.0, min(30.0, newZoom))
                }
            }
            .onEnded { value in
                // Reset tracker pan & kunci base zoom
                lastPanTranslation = .zero
                baseZoom = cameraZoom
            }
        )
        .ignoresSafeArea()
    }
    
    private func updateCamera(cameraAnchor: Entity, cameraEntity: Entity) {
        let radiansX = cameraOrbitX * (.pi / 180.0)
        let radiansY = cameraOrbitY * (.pi / 180.0)
        
        let rotationX = simd_quatf(angle: radiansX, axis: SIMD3<Float>(1, 0, 0))
        let rotationY = simd_quatf(angle: radiansY, axis: SIMD3<Float>(0, 1, 0))
        
        cameraAnchor.transform.translation = cameraPan
        cameraAnchor.transform.rotation = rotationY * rotationX
        cameraEntity.transform.translation = SIMD3<Float>(0, 0, cameraZoom)
    }
}

#Preview {
    ContentView()
}
