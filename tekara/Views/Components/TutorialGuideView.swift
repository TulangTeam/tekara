//
//  TutorialGuideView.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import SwiftUI

private enum DirectionGuide {
    case forward
    case left
    case right
    case backward

    var iconName: String {
        switch self {
        case .forward: return "arrow.up.circle.fill"
        case .left: return "arrow.left.circle.fill"
        case .right: return "arrow.right.circle.fill"
        case .backward: return "arrow.down.circle.fill"
        }
    }

    var labelText: String {
        switch self {
        case .forward: return "Ahead"
        case .left: return "Turn Left"
        case .right: return "Turn Right"
        case .backward: return "Turn Around"
        }
    }
}

struct TutorialGuideView: View {
    @Bindable var manager: TrashInteractionManager
    var cameraYaw: Float = 0.0

    // Adjust card background opacity here (0.0 = completely transparent, 1.0 = solid)
    var cardOpacity: Double = 0.5

    @State private var arrowOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0

    private let toriTagColor = Color(red: 0.36, green: 0.75, blue: 0.67)

    private func getDirection(targetPos: SIMD3<Float>?) -> DirectionGuide {
        guard let target = targetPos, let kaiPos = manager.kaiWorldPosition else {
            return .forward
        }
        let dx = target.x - kaiPos.x
        let dz = target.z - kaiPos.z
        let worldAngle = atan2(dx, -dz)

        var relativeAngle = -(worldAngle + cameraYaw)

        while relativeAngle > .pi { relativeAngle -= 2 * .pi }
        while relativeAngle < -.pi { relativeAngle += 2 * .pi }

        if abs(relativeAngle) < 0.65 {
            return .forward
        } else if relativeAngle >= 0.65 && relativeAngle < 2.35 {
            return .right
        } else if relativeAngle <= -0.65 && relativeAngle > -2.35 {
            return .left
        } else {
            return .backward
        }
    }

    private var hutDirection: DirectionGuide {
        let hutPos = manager.hutWorldPosition ?? SIMD3<Float>(8.0, 0.0, -4.0)
        return getDirection(targetPos: hutPos)
    }

    private var trashDirection: DirectionGuide {
        return getDirection(targetPos: manager.closestTrashWorldPosition)
    }

    private var binDirection: DirectionGuide {
        let binPos = manager.binWorldPosition ?? SIMD3<Float>(-5.0, 0.0, 3.0)
        return getDirection(targetPos: binPos)
    }

    var body: some View {
        ZStack {
            // Centered floating dialogue banner
            VStack {
                Spacer()

                ToriDialogueCard(
                    title: manager.tutorialStep.title,
                    dialogueText: manager.tutorialStep.toriDialogue,
                    toriTagColor: toriTagColor,
                    cardOpacity: cardOpacity,
                    isCleanupStep: manager.tutorialStep == .cleanupRemaining,
                    onGotItTapped: {
                        withAnimation {
                            manager.tutorialStep = .done
                            manager.hasCompletedTutorial = true
                        }
                    }
                )
                .padding(.bottom, 20)
                .allowsHitTesting(true)
            }

            // Directional HUD hints
            directionalHint
                .allowsHitTesting(false)
        }
        .onAppear {
            startArrowAnimation()
        }
    }

    // MARK: - Directional Overlay Hints
    @ViewBuilder
    private var directionalHint: some View {
        switch manager.tutorialStep {
        case .joystick:
            ZStack {
                VStack {
                    Spacer()
                    HStack {
                        Circle()
                            .stroke(PopupStyle.themeBlue, lineWidth: 4)
                            .frame(width: 180, height: 180)
                            .scaleEffect(pulseScale)
                            .opacity(2.0 - Double(pulseScale))
                            .padding(.leading, 40)
                            .padding(.bottom, 40)
                        Spacer()
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        VStack(spacing: 2) {
                            Image(systemName: "arrow.down.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(PopupStyle.themeBlue)
                                .background(Circle().fill(.white).padding(2))
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .offset(y: arrowOffset)

                            Text("JOYSTICK")
                                .font(.custom("Baloo 2", size: 12))
                                .fontWeight(.bold)
                                .foregroundStyle(PopupStyle.themeBlue)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(.white))
                                .shadow(color: .black.opacity(0.2), radius: 3)
                        }
                        .padding(.leading, 105)
                        .padding(.bottom, 225)
                        Spacer()
                    }
                }
            }

        case .cameraSwipe:
            VStack {
                Image(systemName: "hand.draw")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.white.opacity(0.6))
                    .offset(x: arrowOffset * 3)

                Text("Swipe Screen")
                    .font(.custom("Baloo 2", size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.7))
            }

        case .goToHut:
            let dir = hutDirection
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Go to Hut")
                        .font(.custom("Baloo 2", size: 15))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(PopupStyle.themeGreen)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 2.5)
                )
                .padding(.top, 50)

                Spacer()
            }

        case .selectTool:
            // Removed orange box highlight and tap prompt
            EmptyView()

        case .pickTrash, .cleanupRemaining:
            let dir = trashDirection
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Find Trash")
                        .font(.custom("Baloo 2", size: 15))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(PopupStyle.themeBlue)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 2.5)
                )
                .padding(.top, 50)

                Spacer()
            }

        case .depositBin:
            let dir = binDirection
            VStack {
                HStack(spacing: 10) {
                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Go to Bin")
                        .font(.custom("Baloo 2", size: 15))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    Capsule()
                        .fill(PopupStyle.themeGreen)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                )
                .overlay(
                    Capsule()
                        .strokeBorder(Color.white, lineWidth: 2.5)
                )
                .padding(.top, 50)

                Spacer()
            }

        default:
            EmptyView()
        }
    }

    private func startArrowAnimation() {
        withAnimation(
            .easeInOut(duration: 0.8)
                .repeatForever(autoreverses: true)
        ) {
            arrowOffset = 8
        }

        withAnimation(
            .easeInOut(duration: 1.0)
                .repeatForever(autoreverses: true)
        ) {
            pulseScale = 1.1
        }
    }
}

// MARK: - Isolated Dialogue Card View
private struct ToriDialogueCard: View {
    let title: String
    let dialogueText: String
    let toriTagColor: Color
    let cardOpacity: Double
    let isCleanupStep: Bool
    let onGotItTapped: () -> Void

    @State private var displayedText: String = ""
    @State private var isTyping: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // 1. Speaker Identifier (TORI)
            Text("TORI")
                .font(.custom("Baloo 2", size: 18).bold())
                .foregroundColor(toriTagColor)

            // Glowing line under speaker name
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [toriTagColor.opacity(0.9), Color.white.opacity(0.2), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .padding(.bottom, 4)

            // 2. Step Title & Dialogue Text
            HStack(alignment: .bottom, spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title.uppercased())
                        .font(.custom("Baloo 2", size: 12).bold())
                        .foregroundColor(Color.white.opacity(0.6))

                    // Height reservation template + Animated Typewriter Text
                    ZStack(alignment: .topLeading) {
                        Text(dialogueText)
                            .font(.custom("Baloo 2", size: 16).bold())
                            .lineSpacing(4)
                            .opacity(0)

                        Text(displayedText)
                            .font(.custom("Baloo 2", size: 16).bold())
                            .foregroundColor(.white)
                            .lineSpacing(4)
                            .multilineTextAlignment(.leading)
                    }
                }

                Spacer(minLength: 0)

                if isCleanupStep {
                    Button(action: onGotItTapped) {
                        Text("Got it!")
                            .font(.custom("Baloo 2", size: 14).bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color(red: 0.12, green: 0.69, blue: 0.18)))
                    }
                }
            }
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(maxWidth: 460)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.12, blue: 0.20).opacity(cardOpacity),
                            Color(red: 0.03, green: 0.08, blue: 0.15).opacity(cardOpacity + 0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if isTyping {
                isTyping = false
                displayedText = dialogueText
            }
        }
        .task(id: dialogueText) {
            displayedText = ""
            isTyping = true

            for char in dialogueText {
                guard isTyping, !Task.isCancelled else { break }
                displayedText.append(char)
                try? await Task.sleep(nanoseconds: 18_000_000)
            }

            displayedText = dialogueText
            isTyping = false
        }
    }
}
