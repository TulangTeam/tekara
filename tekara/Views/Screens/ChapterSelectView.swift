//
//  ChapterSelectView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterSelectView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                LinearGradient(
                    colors: [Color(hex: "87CEEB").opacity(0.6), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )

                CloudsBackground()

                VStack(spacing: 0) {
                    HStack {
                        BackButton { viewModel.navigateTo(.welcome) }
                        Spacer()
                        Text("OCEAN EXPEDITIONS")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4, x: 0, y: 2)
                        Spacer()
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, geometry.safeAreaInsets.top + 8)

                    ZStack {
                        ChapterPath(geometry: geometry)

                        HStack(spacing: 0) {
                            ChapterIsland(
                                name: "Seashore &\nCoral Reef",
                                imageName: "seashore",
                                isLocked: false,
                                size: geometry.size
                            ) {
                                viewModel.navigateTo(.playing(chapterId: "seashore"))
                            }
                            .frame(width: geometry.size.width * 0.22)

                            Spacer().frame(width: geometry.size.width * 0.12)

                            VStack(spacing: 0) {
                                ChapterIsland(
                                    name: "Seagrass",
                                    imageName: "seagrass",
                                    isLocked: !viewModel.isChapterUnlocked("seagrass"),
                                    size: geometry.size
                                ) {
                                    if viewModel.isChapterUnlocked("seagrass") {
                                        viewModel.navigateTo(.playing(chapterId: "seagrass"))
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.18)

                            Spacer().frame(width: geometry.size.width * 0.08)

                            VStack(spacing: 0) {
                                Spacer()
                                ChapterIsland(
                                    name: "Mangrove",
                                    imageName: "mangrove",
                                    isLocked: !viewModel.isChapterUnlocked("mangrove"),
                                    size: geometry.size
                                ) {
                                    if viewModel.isChapterUnlocked("mangrove") {
                                        viewModel.navigateTo(.playing(chapterId: "mangrove"))
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.18)

                            Spacer().frame(width: geometry.size.width * 0.08)

                            VStack(spacing: 0) {
                                ChapterIsland(
                                    name: "Deep\nOcean",
                                    imageName: "deepocean",
                                    isLocked: !viewModel.isChapterUnlocked("deepocean"),
                                    size: geometry.size
                                ) {
                                    if viewModel.isChapterUnlocked("deepocean") {
                                        viewModel.navigateTo(.playing(chapterId: "deepocean"))
                                    }
                                }
                            }
                            .frame(width: geometry.size.width * 0.18)
                        }
                        .padding(.horizontal, geometry.size.width * 0.05)

                        AstronautCharacter()
                            .frame(width: geometry.size.width * 0.15)
                            .position(x: geometry.size.width * 0.12, y: geometry.size.height * 0.75)
                    }
                    .padding(.vertical, geometry.size.height * 0.05)
                }

                VStack {
                    Spacer()
                    BottomToolbar(
                        onSettings: { viewModel.navigateTo(.settings) },
                        onSoundToggle: { viewModel.toggleSound() },
                        isSoundEnabled: viewModel.gameState.isSoundEnabled,
                        onHome: { viewModel.navigateTo(.welcome) }
                    )
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
            .ignoresSafeArea()
        }
    }
}
