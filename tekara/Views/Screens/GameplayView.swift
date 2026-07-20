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

private enum Layout {
    static let exitButtonSize: CGFloat = 54
    static let exitButtonColor = Color(hex: "DC2626")
    static let exitButtonStrokeWidth: CGFloat = 4
    static let exitButtonShadowRadius: CGFloat = 6
    static let joystickRadius: CGFloat = 60
    static let joystickFrame: CGFloat = 120
    static let joystickPadding: CGFloat = 40
    static let actionButtonSize: CGFloat = 70
    static let actionButtonFontSize: CGFloat = 28
    static let toolsMenuWidth: CGFloat = 170
    static let toolsMenuRightPadding: CGFloat = 20
    static let toolsMenuBottomPadding: CGFloat = 160
    static let contentPadding: CGFloat = 20
    static let contentTopPadding: CGFloat = 16
    static let rightSidePadding: CGFloat = 60
    static let rightSideBottomPadding: CGFloat = 50
    static let overlayPadding: CGFloat = 24
}

private enum Animation {
    static let standard = SwiftUI.Animation.spring(response: 0.5, dampingFraction: 0.8)
    static let contextual = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.75)
    static let deposit = SwiftUI.Animation.spring(response: 0.4, dampingFraction: 0.7)
}

struct GameplayView: View {
    var episodeId: Int
    @Bindable var viewModel: GameViewModel

    private let isometricAngleX: Float = -35.264
    private let isometricAngleY: Float = 45.0
    private let cameraZoom: Float = 6.5

    @State private var joystickValue: CGPoint = .zero
    @State private var interactionManager = TrashInteractionManager()
    @State private var showExitConfirmation = false
    @State private var hasTriggeredMissionComplete = false

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

            VStack {
                HStack(alignment: .top) {
                    VStack(alignment: .leading, spacing: 12) {
                        exitButton
                        MissionCard(manager: interactionManager)
                    }
                    .padding(.leading, Layout.contentPadding)
                    .padding(.top, Layout.contentTopPadding)

                    Spacer()
                }

                Spacer()

                HStack(alignment: .bottom) {
                    ThumbStickView(updatingValue: $joystickValue, radius: Layout.joystickRadius)
                        .frame(width: Layout.joystickFrame, height: Layout.joystickFrame)
                        .padding(.leading, Layout.joystickPadding)
                        .padding(.bottom, Layout.joystickPadding)

                    Spacer()

                    contextualActionButtons
                        .padding(.trailing, Layout.rightSidePadding)
                        .padding(.bottom, Layout.rightSideBottomPadding)
                }
            }

            if interactionManager.isNearHut
                && interactionManager.missionPhase == .none
            {
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ToolsMenuCard(manager: interactionManager)
                            .padding(.trailing, Layout.toolsMenuRightPadding)
                            .padding(.bottom, Layout.toolsMenuBottomPadding)
                    }
                }
                .transition(.move(edge: .trailing).combined(with: .opacity))
            }

            if interactionManager.missionPhase == .oceanFact {
                OceanFactPopup(
                    onBack: nil,
                    onNext: {
                        withAnimation(Animation.standard) {
                            interactionManager.missionPhase = .factVideo
                        }
                    }
                )
                .transition(.opacity)
            }

            if interactionManager.missionPhase == .factVideo {
                DidYouKnowPopup(
                    video: FactVideoData.getVideo(for: episodeId),
                    onBack: {
                        AudioManager.shared.resumeBackgroundMusic()
                        withAnimation(Animation.standard) {
                            interactionManager.missionPhase = .oceanFact
                        }
                    },
                    onNext: {
                        AudioManager.shared.resumeBackgroundMusic()
                        withAnimation(Animation.standard) {
                            interactionManager.missionPhase = .congratulations
                        }
                    }
                )
                .transition(.opacity)
                .onAppear {
                    AudioManager.shared.pauseBackgroundMusic()
                }
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

            if showExitConfirmation {
                ExitConfirmationPopup(
                    onStay: {
                        withAnimation(Animation.contextual) {
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
        .animation(Animation.standard, value: showExitConfirmation)
        .animation(Animation.standard, value: interactionManager.isNearHut)
        .animation(Animation.standard, value: interactionManager.missionPhase)
    }

    private var exitButton: some View {
        Button(action: {
            showExitConfirmation = true
        }) {
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: Layout.exitButtonSize, height: Layout.exitButtonSize)
                .background(Layout.exitButtonColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: Layout.exitButtonStrokeWidth)
                )
                .shadow(
                    color: .black.opacity(0.25),
                    radius: Layout.exitButtonShadowRadius,
                    x: 0,
                    y: 4
                )
        }
        .buttonStyle(ScaleButtonStyle())
    }

    @ViewBuilder
    private var contextualActionButtons: some View {
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
                        .font(.system(size: Layout.actionButtonFontSize, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: Layout.actionButtonSize, height: Layout.actionButtonSize)
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if interactionManager.isNearDepositZone
                        && interactionManager.isHoldingTrash
            {
                Button(action: depositTrash) {
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(.system(size: Layout.actionButtonFontSize, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: Layout.actionButtonSize, height: Layout.actionButtonSize)
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if interactionManager.nearbyTrashEntity != nil,
                      !interactionManager.isHoldingTrash
            {
                HStack(spacing: 5) {
                    Image(systemName: "exclamationmark.triangle.fill")
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
        .animation(Animation.contextual, value: interactionManager.nearbyTrashEntity != nil)
        .animation(Animation.contextual, value: interactionManager.isNearDepositZone)
        .animation(Animation.contextual, value: interactionManager.selectedTool)
    }

    private func depositTrash() {
        withAnimation(Animation.deposit) {
            interactionManager.isHoldingTrash = false
            interactionManager.collectedTrashCount += 1
        }
        #if DEBUG
        print("Trash Deposited: \(interactionManager.collectedTrashCount)/\(interactionManager.totalTrashCount)")
        #endif

        if interactionManager.isMissionComplete
            && interactionManager.missionPhase == .none
            && !hasTriggeredMissionComplete
        {
            hasTriggeredMissionComplete = true
            withAnimation(Animation.standard) {
                interactionManager.missionPhase = .oceanFact
            }
        }
    }
}

#Preview {
    GameplayView(episodeId: 1, viewModel: GameViewModel())
}
