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
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                OceanShineEffect()

                VStack(spacing: 0) {
                    Spacer()

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

                    Spacer().frame(height: geometry.size.height * 0.08)

                    HStack(spacing: 0) {
                        Image("chapterbubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15)

                        Spacer()

                        PlayButton {
                            viewModel.navigateTo(.chapterSelect)
                        }

                        Spacer()

                        Image("chapterbubble")
                            .resizable()
                            .scaledToFit()
                            .frame(width: geometry.size.width * 0.15)
                            .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
                    }
                    .padding(.horizontal, geometry.size.width * 0.08)

                    Spacer().frame(height: geometry.size.height * 0.12)

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
