//
//  WelcomeView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct WelcomeView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var logoScale: CGFloat = 0.1
    @State private var logoOpacity: Double = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)

                VStack(spacing: -15) {
                    Spacer()

                    VStack() {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: geometry.size.height * 0.34)
                    }
                    .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    .scaleEffect(logoScale)
                    .opacity(logoOpacity)

                    Spacer()
                        .frame(height: geometry.size.height * 0.08)
                    PlayButton(action: {
                        viewModel.navigateTo(.chapter)
                    })
                    Spacer()
                }
                .frame(width: geometry.size.width * 0.6)

                VStack {
                    Spacer()
                    HStack {
                        LeftToolbar(
                            onMusicToggle: {},
                            onSoundToggle: { viewModel.toggleSound() },
                            isSoundEnabled: viewModel.gameState.isSoundEnabled,
                            onHelp: {},
                            onGear: {}
                        )
                        .padding(.leading, 32)
                        .padding(.bottom, geometry.safeAreaInsets.bottom )

                        Spacer()
                    }
                }
            }
            .ignoresSafeArea()
            .onAppear {
                // Reset to initial state
                logoScale = 0.1
                logoOpacity = 0

                // Pop-up animation
                withAnimation(.spring(response: 0.7, dampingFraction: 0.6, blendDuration: 0)) {
                    logoScale = 1.0
                    logoOpacity = 1.0
                }
            }
        }
    }
}

#Preview {
    WelcomeView(viewModel: GameViewModel())
}
