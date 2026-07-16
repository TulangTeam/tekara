//
//  WelcomeView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background ocean
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                // Ocean shine effects
                OceanShineEffect()

                VStack(spacing: 0) {
                    Spacer()

                    // Logo and Label
                    VStack(spacing: -30) {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.22)

                        Image("label")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.08)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)

                    Spacer()
                        .frame(height: geometry.size.height * 0.08)

                    // Play button with coral decorations
                    HStack(spacing: 0) {
                        // Left coral decoration
                        Image("chapterbubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15)

                        Spacer()

                        // Play button
                        PlayButton {
                            viewModel.navigateTo(.chapterSelect)
                        }

                        Spacer()

                        // Right seaweed decoration
                        Image("chapterbubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)

                    Spacer()
                        .frame(height: geometry.size.height * 0.12)

                    // Bottom toolbar
                    BottomToolbar(
                        onSettings: { viewModel.navigateTo(.settings) },
                        onSoundToggle: { viewModel.toggleSound() },
                        isSoundEnabled: viewModel.gameState.isSoundEnabled,
                        onHome: { viewModel.navigateTo(.welcome) }
                    )
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Ocean Shine Effect

struct OceanShineEffect: View {
    @State private var animateShine = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Multiple shine spots
                ForEach(0..<6, id: \.self) { index in
                    ShineSpot(
                        xOffset: CGFloat(index) * geometry.size.width / 5,
                        animate: animateShine
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateShine = true
            }
        }
    }
}

struct ShineSpot: View {
    let xOffset: CGFloat
    let animate: Bool

    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [Color.white.opacity(0.3), Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 80
                )
            )
            .frame(width: 120, height: 60)
            .offset(
                x: xOffset,
                y: animate ? 0 : 20
            )
            .opacity(animate ? 0.6 : 0.2)
    }
}

#Preview {
    WelcomeView(viewModel: GameViewModel())
}
