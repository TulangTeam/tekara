//
//  TutorialGuideView.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import SwiftUI

struct TutorialGuideView: View {
    @Bindable var manager: TrashInteractionManager

    @State private var cardScale: CGFloat = 0
    @State private var arrowOffset: CGFloat = 0
    @State private var pulseScale: CGFloat = 1.0

    var body: some View {
        ZStack {
            Color.black.opacity(overlayOpacity)
                .ignoresSafeArea()
                .allowsHitTesting(false)

            VStack {
                Spacer()

                instructionCard
                    .scaleEffect(cardScale)
                    .padding(.bottom, 8)

                stepIndicator
                    .padding(.bottom, 16)
            }

            directionalHint
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
        case .goToHut, .selectTool, .pickTrash, .depositBin:
            return 0.15
        case .done:
            return 0
        }
    }

    private var instructionCard: some View {
        VStack(spacing: 10) {
            HStack(spacing: 10) {
                Image(systemName: manager.tutorialStep.iconName)
                    .font(.system(size: 22, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle().fill(PopupStyle.themeBlue)
                    )
                    .overlay(
                        Circle().stroke(Color.white, lineWidth: 2)
                    )
                    .scaleEffect(pulseScale)

                VStack(alignment: .leading, spacing: 2) {
                    Text(manager.tutorialStep.title)
                        .font(.custom("Baloo 2", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(PopupStyle.textColor)

                    Text(manager.tutorialStep.description)
                        .font(.custom("Baloo 2", size: 13))
                        .foregroundColor(PopupStyle.textColor.opacity(0.7))
                }
            }

            contextualHint
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 14)
        .frame(maxWidth: 380)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(PopupStyle.cardBackground)
                .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18)
                .strokeBorder(PopupStyle.themeBlue.opacity(0.4), lineWidth: 2)
        )
    }

    @ViewBuilder
    private var contextualHint: some View {
        switch manager.tutorialStep {
        case .joystick:
            HStack(spacing: 6) {
                Image(systemName: "arrow.left")
                Image(systemName: "circle.fill")
                    .font(.system(size: 6))
                Text("Drag the joystick to move")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }
            .foregroundColor(PopupStyle.themeBlue)

        case .cameraSwipe:
            HStack(spacing: 6) {
                Image(systemName: "hand.draw")
                Text("Swipe anywhere on screen")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }
            .foregroundColor(PopupStyle.themeBlue)

        case .goToHut:
            HStack(spacing: 6) {
                Image(systemName: "arrow.up.circle.fill")
                    .foregroundColor(PopupStyle.themeGreen)
                Text("Follow the arrow to the Hut")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }

        case .selectTool:
            HStack(spacing: 6) {
                Image(systemName: "hand.tap.fill")
                    .foregroundColor(Color(hex: "F59E0B"))
                Text("Tap Hand Gloves in the Tools menu")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }

        case .pickTrash:
            HStack(spacing: 6) {
                Image(systemName: "hand.raised.fill")
                    .foregroundColor(PopupStyle.themeBlue)
                Text("Walk near trash, then tap pickup")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }

        case .depositBin:
            HStack(spacing: 6) {
                Image(systemName: "arrow.down.to.line.compact")
                    .foregroundColor(PopupStyle.themeGreen)
                Text("Walk to the Bin and dispose it")
                    .font(.custom("Baloo 2", size: 12))
                    .foregroundColor(PopupStyle.textColor.opacity(0.6))
            }

        case .done:
            EmptyView()
        }
    }

    @ViewBuilder
    private var directionalHint: some View {
        switch manager.tutorialStep {
        case .joystick:
            VStack {
                Spacer()
                HStack {
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.down")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(PopupStyle.themeBlue)
                            .offset(y: arrowOffset)
                    }
                    .padding(.leading, 95)
                    .padding(.bottom, 180)
                    Spacer()
                }
            }

        case .cameraSwipe:
            VStack {
                Image(systemName: "hand.draw")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.white.opacity(0.6))
                    .offset(x: arrowOffset * 3)

                Text("Swipe")
                    .font(.custom("Baloo 2", size: 16))
                    .fontWeight(.bold)
                    .foregroundStyle(.white.opacity(0.7))
            }

        case .goToHut:
            VStack {
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Text("🏠")
                            .font(.system(size: 32))

                        Image(systemName: "arrow.up")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(PopupStyle.themeGreen)
                            .offset(y: -arrowOffset)

                        Text("Hut")
                            .font(.custom("Baloo 2", size: 14))
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 4)
                            .background(
                                Capsule().fill(PopupStyle.themeGreen)
                            )
                    }
                    Spacer()
                }
                .padding(.top, 40)
                Spacer()
            }

        case .selectTool:
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(spacing: 4) {
                        Image(systemName: "arrow.right")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundStyle(Color(hex: "F59E0B"))
                            .offset(x: arrowOffset)

                        Text("Tools")
                            .font(.custom("Baloo 2", size: 12))
                            .fontWeight(.bold)
                            .foregroundStyle(Color(hex: "F59E0B"))
                    }
                    .padding(.trailing, 200)
                    .padding(.bottom, 200)
                }
            }

        default:
            EmptyView()
        }
    }

    private var stepIndicator: some View {
        HStack(spacing: 6) {
            ForEach(0..<6, id: \.self) { index in
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
