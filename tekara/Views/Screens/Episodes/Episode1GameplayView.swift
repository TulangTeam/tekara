//
//  Episode1GameplayView.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.

import RealityKit
import SwiftUI
import TekaraAssets
import ThumbStickView

private enum Layout {
    static let exitButtonSize: CGFloat = 54
    static let exitButtonColor = Color(hex: "DC2626")
    static let exitButtonStrokeWidth: CGFloat = 4
    static let exitButtonShadowRadius: CGFloat = 6
    static let joystickRadius: CGFloat = 90
    static let joystickFrame: CGFloat = 180
    static let joystickPadding: CGFloat = 40
    static let actionButtonSize: CGFloat = 140
    static let actionButtonFontSize: CGFloat = 70
    static let toolsMenuWidth: CGFloat = 170
    static let toolsMenuRightPadding: CGFloat = 20
    static let toolsMenuBottomPadding: CGFloat = 160
    static let contentPadding: CGFloat = 20
    static let contentTopPadding: CGFloat = 16
    static let rightSidePadding: CGFloat = 50
    static let rightSideBottomPadding: CGFloat = 40
    static let overlayPadding: CGFloat = 24
}

private enum Animation {
    static let standard = SwiftUI.Animation.spring(
        response: 0.5,
        dampingFraction: 0.8
    )
    static let contextual = SwiftUI.Animation.spring(
        response: 0.4,
        dampingFraction: 0.75
    )
    static let deposit = SwiftUI.Animation.spring(
        response: 0.4,
        dampingFraction: 0.7
    )
}

struct Episode1GameplayView: View {
    var episodeId: Int
    @Bindable var viewModel: GameViewModel

    private let sceneAssetName = "EP1_CHAP1"
    private let sceneRootName = "Scene"
    private let characterName = "main_chara"

    @State private var joystickValue: CGPoint = .zero
    @State private var interactionManager = TrashInteractionManager()
    @State private var showExitConfirmation = false
    @State private var hasTriggeredMissionComplete = false

    // Camera rotation state
    @State private var cameraYaw: Float = 0.0
    @State private var lastDragTranslationWidth: CGFloat = 0.0
    @State private var joystickUsedForTutorial = false
    @State private var cameraSwipedForTutorial = false

    // Camera offset configuration
    private let idealCameraOffset = SIMD3<Float>(0, 5.5, 8.5)
    private let minCameraDistance: Float = 2.5

    init(episodeId: Int, viewModel: GameViewModel) {
        self.episodeId = episodeId
        self.viewModel = viewModel

        MovementInputComponent.registerComponent()
        CharacterGroundingComponent.registerComponent()
        CharacterMovementConfiguration.registerSystem()
        CameraFollowSystem.registerSystem()
        ProximityDetectionSystem.registerSystem()

        ProximityDetectionSystem.interactionManager = interactionManager
    }

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(hex: "0284C7"),
                    Color(hex: "38BDF8"),
                    Color(hex: "BAE6FD")
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            // LAYER 1: 3D Scene + Camera
            sceneLayer

            // LAYER 2: HUD Layer (exit button, mission card, joystick, action buttons)
            hudLayer

            // LAYER 3: Tools Menu
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

            // LAYER 4: Tutorial Overlay
            if !interactionManager.hasCompletedTutorial
                && interactionManager.tutorialStep != .done
                && interactionManager.missionPhase == .none
            {
                TutorialGuideView(manager: interactionManager)
                    .allowsHitTesting(false)
                    .transition(.opacity)
            }

            // LAYER 5: Mission Complete Popups (Ocean Fact → Fact Video → Congratulations)
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
                        EpisodeProgressManager.shared.markCompleted(
                            episodeId: episodeId
                        )
                        viewModel.navigateTo(.episodes)
                    },
                    onNextEpisode: {
                        EpisodeProgressManager.shared.markCompleted(
                            episodeId: episodeId
                        )
                        let nextId = episodeId + 1
                        if nextId <= 6 {
                            viewModel.navigateTo(.story(episodeId: nextId))
                        } else {
                            viewModel.navigateTo(.episodes)
                        }
                    }
                )
                .transition(.opacity)
            }

            // LAYER 6: Exit Confirmation Popup
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
        .animation(Animation.standard, value: interactionManager.tutorialStep)
        // Tutorial auto-advance logic
        .onChange(of: joystickValue) { _, newValue in
            if !joystickUsedForTutorial
                && (abs(newValue.x) > 0.1 || abs(newValue.y) > 0.1)
            {
                joystickUsedForTutorial = true
            }
        }
        .onChange(of: joystickUsedForTutorial) { _, used in
            if used && interactionManager.tutorialStep == .joystick {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(Animation.standard) {
                        interactionManager.tutorialStep = .cameraSwipe
                    }
                }
            }
        }
        .onChange(of: cameraSwipedForTutorial) { _, swiped in
            if swiped && interactionManager.tutorialStep == .cameraSwipe {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(Animation.standard) {
                        interactionManager.tutorialStep = .goToHut
                    }
                }
            }
        }
        .onChange(of: interactionManager.isNearHut) { _, nearHut in
            if nearHut && interactionManager.tutorialStep == .goToHut {
                withAnimation(Animation.standard) {
                    interactionManager.tutorialStep = .selectTool
                }
            }
        }
        .onChange(of: interactionManager.selectedTool) { _, tool in
            if tool != nil && interactionManager.tutorialStep == .selectTool {
                withAnimation(Animation.standard) {
                    interactionManager.tutorialStep = .pickTrash
                }
            }
        }
        .onChange(of: interactionManager.isHoldingTrash) { _, holding in
            if holding && interactionManager.tutorialStep == .pickTrash {
                withAnimation(Animation.standard) {
                    interactionManager.tutorialStep = .depositBin
                }
            }
        }
        .onChange(of: interactionManager.collectedTrashCount) { _, count in
            if count > 0 && interactionManager.tutorialStep == .depositBin {
                withAnimation(Animation.standard) {
                    interactionManager.tutorialStep = .done
                    interactionManager.hasCompletedTutorial = true
                }
            }
        }
    }

    private var sceneLayer: some View {
        RealityView { content in
            if let sceneEntity = try? await Entity(
                named: sceneAssetName,
                in: tekaraAssetsBundle
            ) {
                content.add(sceneEntity)

                if let island = sceneEntity.findEntity(named: sceneRootName),
                    let character = island.findEntity(named: characterName)
                {
                    character.components.set(CharacterGroundingComponent())
                    character.components.set(MovementInputComponent())
                }
            }

            // 1. Balanced Sunlight + Crisp Realtime Soft Shadows
            let sunEntity = DirectionalLight()
            sunEntity.light.color = .init(red: 1.0, green: 0.95, blue: 0.88, alpha: 1.0)
            sunEntity.light.intensity = 2800
            sunEntity.shadow?.maximumDistance = 22.0
            sunEntity.look(
                at: SIMD3<Float>(0, 0, 0),
                from: SIMD3<Float>(10, 16, 10),
                relativeTo: nil
            )
            content.add(sunEntity)

            // 2. Soft Ambient Sky Fill Light
            let skyEntity = DirectionalLight()
            skyEntity.light.color = .init(red: 0.4, green: 0.75, blue: 0.95, alpha: 1.0)
            skyEntity.light.intensity = 900
            skyEntity.look(
                at: SIMD3<Float>(0, 0, 0),
                from: SIMD3<Float>(-10, 8, -8),
                relativeTo: nil
            )
            content.add(skyEntity)

            let cameraEntity = Entity()
            var cameraComponent = PerspectiveCameraComponent()
            cameraComponent.fieldOfViewInDegrees = 52
            cameraEntity.components.set(cameraComponent)
            cameraEntity.name = "tpv_camera"
            cameraEntity.transform.translation = idealCameraOffset

            let tiltAngle = -32.0 * (.pi / 180.0)
            cameraEntity.transform.rotation = simd_quatf(
                angle: Float(tiltAngle),
                axis: SIMD3<Float>(1, 0, 0)
            )

            let cameraAnchor = Entity()
            cameraAnchor.name = "camera_anchor"
            cameraAnchor.addChild(cameraEntity)
            content.add(cameraAnchor)

        } update: { content in
            guard
                let island = content.entities.first?.findEntity(
                    named: sceneRootName
                ),
                let kai = island.findEntity(named: characterName),
                let cameraAnchor = content.entities.first(where: {
                    $0.name == "camera_anchor"
                }),
                let cameraEntity = cameraAnchor.findEntity(named: "tpv_camera"),
                let scene = kai.scene
            else { return }

            let kaiWorldPos = kai.position(relativeTo: nil)
            let currentAnchorPos = cameraAnchor.position(relativeTo: nil)
            let smoothFactor: Float = 0.15
            let smoothedPos = simd_mix(
                currentAnchorPos,
                kaiWorldPos,
                SIMD3<Float>(repeating: smoothFactor)
            )
            cameraAnchor.setPosition(smoothedPos, relativeTo: nil)

            cameraAnchor.transform.rotation = simd_quatf(
                angle: cameraYaw,
                axis: SIMD3<Float>(0, 1, 0)
            )

            let anchorWorldPos = cameraAnchor.position(relativeTo: nil)
            let targetCamWorldPos = cameraAnchor.convert(
                position: idealCameraOffset,
                to: nil
            )
            let rayDirection = targetCamWorldPos - anchorWorldPos
            let rayLength = simd_length(rayDirection)
            var targetZOffset = idealCameraOffset.z

            if rayLength > 0.001 {
                let hits = scene.raycast(
                    origin: anchorWorldPos,
                    direction: simd_normalize(rayDirection),
                    length: rayLength
                )
                if let firstObstacle = hits.first(where: { hit in
                    let isNotKai = hit.entity != kai
                    let isNotSand = hit.entity.name != "sand_ground_2"
                    let hasCollision = hit.entity.components.has(
                        CollisionComponent.self
                    )
                    return isNotKai && isNotSand && hasCollision
                }) {
                    let safeDistance = max(
                        minCameraDistance,
                        firstObstacle.distance - 0.5
                    )
                    targetZOffset = safeDistance
                }
            }

            let currentZ = cameraEntity.transform.translation.z
            cameraEntity.transform.translation.z = simd_mix(
                currentZ,
                targetZOffset,
                0.2
            )

            var inputComp =
                kai.components[MovementInputComponent.self]
                ?? MovementInputComponent()
            inputComp.joystickValue = SIMD2<Float>(
                Float(joystickValue.x),
                Float(joystickValue.y)
            )
            kai.components.set(inputComp)
        }
        .gesture(
            DragGesture()
                .onChanged { value in
                    // OPTION 1: Disable camera rotation gesture during Step 1 (Joystick tutorial)
                    guard interactionManager.tutorialStep != .joystick else {
                        return
                    }

                    let deltaX = Float(
                        value.translation.width - lastDragTranslationWidth
                    )
                    lastDragTranslationWidth = value.translation.width

                    let sensitivity: Float = 0.005
                    cameraYaw -= deltaX * sensitivity

                    // Only trigger Step 2 completion if tutorial is currently on Step 2 (.cameraSwipe)
                    if interactionManager.tutorialStep == .cameraSwipe
                        && !cameraSwipedForTutorial
                        && abs(value.translation.width) > 30
                    {
                        cameraSwipedForTutorial = true
                    }
                }
                .onEnded { _ in
                    lastDragTranslationWidth = 0.0
                }
        )
        .ignoresSafeArea()
    }

    private var hudLayer: some View {
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
                ThumbStickView(
                    updatingValue: $joystickValue,
                    radius: Layout.joystickRadius
                )
                .frame(
                    width: Layout.joystickFrame,
                    height: Layout.joystickFrame
                )
                .padding(.leading, Layout.joystickPadding)
                .padding(.bottom, Layout.joystickPadding)

                Spacer()

                contextualActionButtons
                    .padding(.trailing, Layout.rightSidePadding)
                    .padding(.bottom, Layout.rightSideBottomPadding)
            }
        }
        .allowsHitTesting(true)
    }

    private var exitButton: some View {
        Button(action: {
            showExitConfirmation = true
        }) {
            Image(systemName: "door.left.hand.open")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(
                    width: Layout.exitButtonSize,
                    height: Layout.exitButtonSize
                )
                .background(Layout.exitButtonColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(
                            Color.white,
                            lineWidth: Layout.exitButtonStrokeWidth
                        )
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
            if let shellEntity = interactionManager.nearbyShellEntity {
                Button(action: {
                    shellEntity.removeFromParent()
                    interactionManager.pickedShellCount += 1
                    interactionManager.nearbyShellEntity = nil
                }) {
                    Image(systemName: "sparkles")
                        .font(
                            .system(
                                size: Layout.actionButtonFontSize,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: Layout.actionButtonSize,
                            height: Layout.actionButtonSize
                        )
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if let seaStarEntity = interactionManager.nearbySeaStarEntity {
                Button(action: {
                    seaStarEntity.removeFromParent()
                    interactionManager.pickedSeaStarCount += 1
                    interactionManager.nearbySeaStarEntity = nil
                }) {
                    Image(systemName: "star.fill")
                        .font(
                            .system(
                                size: Layout.actionButtonFontSize,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(Color(hex: "F59E0B"))
                        .frame(
                            width: Layout.actionButtonSize,
                            height: Layout.actionButtonSize
                        )
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if let trashEntity = interactionManager.nearbyTrashEntity,
                !interactionManager.isHoldingTrash,
                interactionManager.selectedTool == .gloves
            {
                Button(action: {
                    trashEntity.removeFromParent()
                    interactionManager.isHoldingTrash = true
                    interactionManager.nearbyTrashEntity = nil
                }) {
                    Image(systemName: "hand.raised.fill")
                        .font(
                            .system(
                                size: Layout.actionButtonFontSize,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: Layout.actionButtonSize,
                            height: Layout.actionButtonSize
                        )
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if interactionManager.isNearDepositZone
                && interactionManager.isHoldingTrash
            {
                Button(action: depositTrash) {
                    Image(systemName: "arrow.down.to.line.compact")
                        .font(
                            .system(
                                size: Layout.actionButtonFontSize,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: Layout.actionButtonSize,
                            height: Layout.actionButtonSize
                        )
                        .glassEffect(.clear, in: .circle)
                }
                .buttonStyle(ScaleButtonStyle())
                .transition(.scale.combined(with: .opacity))

            } else if interactionManager.nearbyTrashEntity != nil,
                !interactionManager.isHoldingTrash
            {
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color(hex: "F59E0B"))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(
                            interactionManager.selectedTool == nil
                                ? "Tool Required!"
                                : "Wrong Tool Equipped!"
                        )
                        .font(.custom("Baloo 2", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "DC2626"))

                        Text(
                            interactionManager.selectedTool == nil
                                ? "Select Hand Gloves to pick up trash."
                                : "Switch to Hand Gloves to pick up trash."
                        )
                        .font(.custom("Baloo 2", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(PopupStyle.textColor)
                    }

                    ZStack {
                        Circle()
                            .fill(Color(hex: "F59E0B"))
                            .frame(width: 32, height: 32)

                        Image(systemName: "hand.raised.fill")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundColor(.white)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(PopupStyle.cardBackground)
                        .shadow(color: .black.opacity(0.18), radius: 8, x: 0, y: 4)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color(hex: "F59E0B"), lineWidth: 1.5)
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(
            Animation.contextual,
            value: interactionManager.nearbyTrashEntity != nil
        )
        .animation(
            Animation.contextual,
            value: interactionManager.nearbyShellEntity != nil
        )
        .animation(
            Animation.contextual,
            value: interactionManager.nearbySeaStarEntity != nil
        )
        .animation(
            Animation.contextual,
            value: interactionManager.isNearDepositZone
        )
        .animation(Animation.contextual, value: interactionManager.selectedTool)
    }

    private func depositTrash() {
        withAnimation(Animation.deposit) {
            interactionManager.isHoldingTrash = false
            interactionManager.collectedTrashCount += 1
        }
        #if DEBUG
            print(
                "Trash Deposited: \(interactionManager.collectedTrashCount)/\(interactionManager.totalTrashCount)"
            )
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
    Episode1GameplayView(episodeId: 1, viewModel: GameViewModel())
}
