//
//  GameplayView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import RealityKit
import SwiftUI
import TekaraAssets
import ThumbStickView

struct GameplayView: View {
    var episodeId: Int
    @ObservedObject var viewModel: GameViewModel
    
    private let isometricAngleX: Float = -35.264
    private let isometricAngleY: Float = 45.0
    private let cameraZoom: Float = 6.5  // Camera
    
    @State private var joystickValue: CGPoint = .zero
    
    @State private var interactionManager = TrashInteractionManager()
    @State private var showExitConfirmation = false
    
    init(episodeId: Int, viewModel: GameViewModel) {
        self.episodeId = episodeId
        self.viewModel = viewModel
        MovementInputComponent.registerComponent()
        CharacterGroundingComponent.registerComponent()
        CharacterMovementConfiguration.registerSystem()
        CharacterMovementConfiguration.interactionManager = interactionManager
    }
    
    var body: some View {
        ZStack {
            // LAYER 1: 3D Scene Rendering
            RealityView { content in
                if let sceneEntity = try? await Entity(
                    named: "_WORLD1_CHAP1",
                    in: tekaraAssetsBundle
                ) {
                    content.add(sceneEntity)
                    
                    if let island = sceneEntity.findEntity(named: "Island"),
                       let character = island.findEntity(named: "kai_chara")
                    {
                        character.components.set(CharacterGroundingComponent())
                        character.components.set(MovementInputComponent())
                    }
                }
                
                // Setup Kamera Fixed Isometric
                let cameraEntity = Entity()
                var cameraComponent = PerspectiveCameraComponent()
                cameraComponent.fieldOfViewInDegrees = 15
                cameraEntity.components.set(cameraComponent)
                cameraEntity.name = "custom_camera"
                
                let cameraAnchor = Entity()
                cameraAnchor.name = "camera_anchor"
                cameraAnchor.addChild(cameraEntity)
                content.add(cameraAnchor)
                
                let radiansX = isometricAngleX * (.pi / 180.0)
                let radiansY = isometricAngleY * (.pi / 180.0)
                let rotationX = simd_quatf(
                    angle: radiansX,
                    axis: SIMD3<Float>(1, 0, 0)
                )
                let rotationY = simd_quatf(
                    angle: radiansY,
                    axis: SIMD3<Float>(0, 1, 0)
                )
                cameraAnchor.transform.rotation = rotationY * rotationX
                cameraEntity.transform.translation = SIMD3<Float>(
                    0,
                    0,
                    cameraZoom
                )
                
            } update: { content in
                guard
                    let island = content.entities.first?.findEntity(
                        named: "Island"
                    ),
                    let kai = island.findEntity(named: "kai_chara")
                else { return }
                
                var inputComp =
                kai.components[MovementInputComponent.self]
                ?? MovementInputComponent()
                inputComp.joystickValue = SIMD2<Float>(
                    Float(joystickValue.x),
                    Float(joystickValue.y)
                )
                kai.components.set(inputComp)
            }
            .ignoresSafeArea()
            
            // LAYER 2: UI Overlay (Mission, Tools, Joystick & Action Buttons)
            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        
                        Button(action: {
                            showExitConfirmation = true
                        }) {
                            Image(systemName: "door.left.hand.open")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(width: 54, height: 54)
                                .background(Color(hex: "DC2626"))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.white, lineWidth: 4)
                                )
                                .shadow(
                                    color: .black.opacity(0.25),
                                    radius: 6,
                                    x: 0,
                                    y: 4
                                )
                        }
                        .buttonStyle(ScaleButtonStyle())
                        
                        MissionCard(manager: interactionManager)
                    }
                    .padding(.leading, 20)
                    .padding(.top, 16)
                    
                    Spacer()
                }
                
                Spacer()
                
                // BOTTOM ROW: Joystick
                HStack(alignment: .bottom) {
                    ThumbStickView(updatingValue: $joystickValue, radius: 60)
                        .frame(width: 120, height: 120)
                        .padding(.leading, 40)
                        .padding(.bottom, 40)
                    
                    Spacer()
                    
                    // RIGIT SIDE: DYNAMIC CONTEXTUAL BUTTONS
                    VStack(spacing: 12) {
                        if let trashEntity = interactionManager
                            .nearbyTrashEntity,
                           !interactionManager.isHoldingTrash,
                           interactionManager.selectedTool == .gloves
                        {
                            Button(action: {
                                trashEntity.removeFromParent()
                                interactionManager.isHoldingTrash = true
                                interactionManager.nearbyTrashEntity = nil
                            }) {
                                Image(systemName: "hand.raised.fill")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 70, height: 70)
                                    .glassEffect(.clear, in: .circle)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .transition(.scale.combined(with: .opacity))
                            
                        } else if interactionManager.isNearDepositZone
                                    && interactionManager.isHoldingTrash
                        {
                            Button(action: {
                                withAnimation(
                                    .spring(response: 0.4, dampingFraction: 0.7)
                                ) {
                                    interactionManager.isHoldingTrash = false
                                    interactionManager.collectedTrashCount += 1
                                }
                                print(
                                    "Trash Successfully Deposited! (\(interactionManager.collectedTrashCount)/\(interactionManager.totalTrashCount))"
                                )
                                
                                DispatchQueue.main.asyncAfter(
                                    deadline: .now() + 0.5
                                ) {
                                    if interactionManager.isMissionComplete
                                        && interactionManager.missionPhase
                                        == .none
                                    {
                                        withAnimation(
                                            .spring(
                                                response: 0.5,
                                                dampingFraction: 0.8
                                            )
                                        ) {
                                            interactionManager.missionPhase =
                                                .oceanFact
                                        }
                                    }
                                }
                            }) {
                                Image(systemName: "arrow.down.to.line.compact")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundStyle(.white)
                                    .frame(width: 70, height: 70)
                                    .glassEffect(.clear, in: .circle)
                            }
                            .buttonStyle(ScaleButtonStyle())
                            .transition(.scale.combined(with: .opacity))
                            
                        } else if interactionManager.nearbyTrashEntity != nil,
                                  !interactionManager.isHoldingTrash
                        {
                            HStack(spacing: 5) {
                                Image(
                                    systemName: "exclamationmark.triangle.fill"
                                )
                                .font(.system(size: 10))
                                Text(
                                    interactionManager.selectedTool == nil
                                    ? "Select the Tool first!"
                                    : "Use gloves to collect the trash!"
                                )
                                .font(
                                    .system(
                                        size: 10,
                                        weight: .semibold,
                                        design: .rounded
                                    )
                                )
                            }
                            .foregroundStyle(Color(hex: "F59E0B"))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .glassEffect(.clear, in: .capsule)
                            .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.75),
                        value: interactionManager.nearbyTrashEntity != nil
                    )
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.75),
                        value: interactionManager.isNearDepositZone
                    )
                    .animation(
                        .spring(response: 0.4, dampingFraction: 0.75),
                        value: interactionManager.selectedTool
                    )
                    .padding(.trailing, 60)
                    .padding(.bottom, 50)
                }
            }
            
            // LAYER 3: Tools Menu Card
            if interactionManager.isNearHut
                && interactionManager.missionPhase == .none
            {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToolsMenuCard(manager: interactionManager)
                            .padding(.trailing, 20)
                            .padding(.bottom, 160)
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }
            
            // LAYER 4: Mission Complete Popups
            if interactionManager.missionPhase == .oceanFact {
                OceanFactPopup(onNext: {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.8))
                    {
                        interactionManager.missionPhase = .congratulations
                    }
                })
                .transition(.opacity)
            }
            
            if interactionManager.missionPhase == .congratulations {
                CongratulationsPopup(
                    episodeId: episodeId,
                    onBackToEpisodes: {
                        viewModel.navigateTo(.episodes)
                    },
                    onNextEpisode: {
                        // Placeholder: only episode 1 exists for now
                    }
                )
                .transition(.opacity)
            }
            
            // LAYER 5: Exit Confirmation Popup
            if showExitConfirmation {
                ExitConfirmationPopup(
                    onStay: {
                        withAnimation(
                            .spring(response: 0.4, dampingFraction: 0.8)
                        ) {
                            showExitConfirmation = false
                        }
                    },
                    onLeave: {
                        viewModel.navigateTo(.episodes)
                    }
                )
                .transition(.opacity)
            }
        }
        .animation(
            .spring(response: 0.5, dampingFraction: 0.8),
            value: showExitConfirmation
        )
        .animation(
            .spring(response: 0.5, dampingFraction: 0.8),
            value: interactionManager.isNearHut
        )
        .animation(
            .spring(response: 0.5, dampingFraction: 0.8),
            value: interactionManager.missionPhase
        )
    }
}

#Preview {
    GameplayView(episodeId: 1, viewModel: GameViewModel())
}
