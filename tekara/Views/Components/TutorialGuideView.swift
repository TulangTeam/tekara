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

    @State private var cardScale: CGFloat = 0
    @State private var arrowOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0

    private func getDirection(targetPos: SIMD3<Float>?) -> DirectionGuide {
        guard let target = targetPos, let kaiPos = manager.kaiWorldPosition else {
            return .forward
        }
        let dx = target.x - kaiPos.x
        let dz = target.z - kaiPos.z
        let worldAngle = atan2(dx, -dz)

        // Camera sits at local +Z offset, rotated by cameraYaw around Y.
        // The player's screen-forward direction = -(worldAngle + cameraYaw).
        // Positive result → target is to the right on screen.
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
            Color.black.opacity(overlayOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Spacer()

                toriDialogueCard
                    .scaleEffect(cardScale)
                    .padding(.bottom, 8)
                    .allowsHitTesting(true)

                stepIndicator
                    .padding(.bottom, 16)
                    .allowsHitTesting(false)
            }

            directionalHint
                .allowsHitTesting(false)
        }
        .onAppear {
            withAnimation(
                .spring(response: 0.6, dampingFraction: 0.65).delay(0.5)
            ) {
                cardScale = 1
            }
            startArrowAnimation()
        }
        .onChange(of: manager.tutorialStep) { _, _ in
            cardScale = 0
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                cardScale = 1
            }
        }
    }

    private var overlayOpacity: Double {
        switch manager.tutorialStep {
        case .joystick, .cameraSwipe:
            return 0.35
        case .goToHut, .selectTool, .pickTrash, .depositBin, .cleanupRemaining:
            return 0.15
        case .done:
            return 0
        }
    }

    private var toriDialogueCard: some View {
        ZStack(alignment: .top) {
            // Main White Dialogue Face
            HStack(alignment: .center, spacing: 14) {
                // Tori Avatar
                ZStack {
                    Circle()
                        .fill(Color(red: 0.36, green: 0.75, blue: 0.67).opacity(0.2))
                        .frame(width: 58, height: 58)

                    if UIImage(named: "avatar_tori") != nil {
                        Image("avatar_tori")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 58, height: 58)
                            .clipShape(Circle())
                    } else {
                        Image(systemName: "turtle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color(red: 0.36, green: 0.75, blue: 0.67))
                    }
                }
                .overlay(
                    Circle().stroke(Color(red: 0.36, green: 0.75, blue: 0.67), lineWidth: 3.5)
                )

                // Speech Content
                VStack(alignment: .leading, spacing: 2) {
                    Text(manager.tutorialStep.title)
                        .font(.custom("Baloo 2", size: 14))
                        .fontWeight(.bold)
                        .foregroundColor(PopupStyle.themeBlue)

                    Text(manager.tutorialStep.toriDialogue)
                        .font(.custom("Baloo 2", size: 15))
                        .fontWeight(.bold)
                        .foregroundColor(PopupStyle.textColor)
                        .lineLimit(3)
                        .minimumScaleFactor(0.85)
                }

                Spacer(minLength: 0)

                if manager.tutorialStep == .cleanupRemaining {
                    Button(action: {
                        withAnimation {
                            manager.tutorialStep = .done
                            manager.hasCompletedTutorial = true
                        }
                    }) {
                        Text("Got it! 👍")
                            .font(.custom("Baloo 2", size: 13))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Capsule().fill(Color(red: 0.12, green: 0.69, blue: 0.18)))
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.top, 22)
            .padding(.bottom, 14)
            .background(
                RoundedRectangle(cornerRadius: 22)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 5)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .strokeBorder(Color(red: 0.95, green: 0.87, blue: 0.68), lineWidth: 3.5)
            )

            // Tori Speaker Tag Pill
            HStack(spacing: 5) {
                Text("🐢")
                    .font(.system(size: 13))
                Text("Tori")
                    .font(.custom("Baloo 2", size: 14))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 4)
            .background(
                Capsule()
                    .fill(Color(red: 0.36, green: 0.75, blue: 0.67))
            )
            .overlay(
                Capsule()
                    .strokeBorder(Color.white, lineWidth: 2)
            )
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 2)
            .offset(y: -13)
        }
        .frame(maxWidth: 420)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private var directionalHint: some View {
        switch manager.tutorialStep {
        case .joystick:
            ZStack {
                // Pulsing highlight circle around joystick
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

                // Big animated arrow directly above joystick
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
                    Text("🏠")
                        .font(.system(size: 24))

                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Hut: \(dir.labelText)")
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
            ZStack {
                // Pulsing highlight box around Tools menu card (width: 195, height: 220)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color(hex: "F59E0B"), lineWidth: 4)
                            .frame(width: 195, height: 220)
                            .scaleEffect(pulseScale)
                            .opacity(2.0 - Double(pulseScale))
                            .padding(.trailing, 20)
                            .padding(.bottom, 160)
                    }
                }

                // Big animated arrow pointing RIGHT directly at the Gloves row (Y: 280)
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        HStack(spacing: 6) {
                            Text("TAP GLOVES")
                                .font(.custom("Baloo 2", size: 12))
                                .fontWeight(.bold)
                                .foregroundStyle(Color(hex: "F59E0B"))
                                .padding(.horizontal, 10)
                                .padding(.vertical, 3)
                                .background(Capsule().fill(.white))
                                .shadow(color: .black.opacity(0.2), radius: 3)

                            Image(systemName: "arrow.right.circle.fill")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundStyle(Color(hex: "F59E0B"))
                                .background(Circle().fill(.white).padding(2))
                                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                                .offset(x: -arrowOffset)
                        }
                        .padding(.trailing, 222)
                        .padding(.bottom, 280)
                    }
                }
            }

        case .pickTrash, .cleanupRemaining:
            let dir = trashDirection
            VStack {
                HStack(spacing: 10) {
                    Text("🧹")
                        .font(.system(size: 24))

                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Trash: \(dir.labelText)")
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
                    Text("🗑️")
                        .font(.system(size: 24))

                    Image(systemName: dir.iconName)
                        .font(.system(size: 26, weight: .bold))
                        .foregroundStyle(.white)

                    Text("Bin: \(dir.labelText)")
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

    private var stepIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<7, id: \.self) { index in
                Circle()
                    .fill(
                        index <= manager.tutorialStep.rawValue
                            ? PopupStyle.themeBlue
                            : Color.white.opacity(0.4)
                    )
                    .frame(
                        width: index == manager.tutorialStep.rawValue ? 10 : 7,
                        height: index == manager.tutorialStep.rawValue ? 10 : 7
                    )
                    .animation(
                        .spring(response: 0.3),
                        value: manager.tutorialStep
                    )
            }
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
