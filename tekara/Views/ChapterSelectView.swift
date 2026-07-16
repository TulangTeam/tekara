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
                // Background ocean
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()

                // Sky overlay
                LinearGradient(
                    colors: [
                        Color(hex: "87CEEB").opacity(0.6),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                // Clouds
                CloudsBackground()

                VStack(spacing: 0) {
                    // Top bar with back button
                    HStack {
                        BackButton {
                            viewModel.navigateTo(.welcome)
                        }

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

                    // Map content
                    ZStack {
                        // Dashed path connecting islands
                        ChapterPath(geometry: geometry)

                        // Islands in map layout
                        HStack(spacing: 0) {
                            // Seashore - left
                            ChapterIsland(
                                name: "Seashore &\nCoral Reef",
                                imageName: "seashore",
                                isLocked: false,
                                size: geometry.size
                            ) {
                                viewModel.navigateTo(.playing(chapterId: "seashore"))
                            }
                            .frame(width: geometry.size.width * 0.22)

                            Spacer()
                                .frame(width: geometry.size.width * 0.12)

                            // Seagrass - top right
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

                            Spacer()
                                .frame(width: geometry.size.width * 0.08)

                            // Mangrove - bottom right
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

                            Spacer()
                                .frame(width: geometry.size.width * 0.08)

                            // Deep Ocean - far right top
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

                        // Astronaut character - bottom left
                        AstronautCharacter()
                            .frame(width: geometry.size.width * 0.15)
                            .position(
                                x: geometry.size.width * 0.12,
                                y: geometry.size.height * 0.75
                            )
                    }
                    .padding(.vertical, geometry.size.height * 0.05)
                }

                // Bottom toolbar
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

// MARK: - Chapter Island Card

struct ChapterIsland: View {
    let name: String
    let imageName: String
    let isLocked: Bool
    let size: CGSize
    let action: () -> Void

    var islandHeight: CGFloat {
        size.height * 0.42
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                // Island image
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: islandHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isLocked ? Color.black.opacity(0.5) : Color.black.opacity(0.2))
                    )

                // Lock overlay
                if isLocked {
                    VStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(
                        Circle()
                            .fill(Color.black.opacity(0.4))
                    )
                }

                // Name badge
                VStack {
                    Spacer()
                    Text(name)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.black.opacity(0.5))
                        )
                }
                .padding(8)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLocked)
    }
}

// MARK: - Chapter Path (Dashed Lines)

struct ChapterPath: View {
    let geometry: GeometryProxy

    var body: some View {
        Path { path in
            // Start from Seashore
            let seashoreX = geometry.size.width * 0.22
            let seashoreY = geometry.size.height * 0.5

            // To Seagrass
            let seagrassX = geometry.size.width * 0.52
            let seagrassY = geometry.size.height * 0.3

            path.move(to: CGPoint(x: seashoreX, y: seashoreY))
            path.addLine(to: CGPoint(x: seagrassX, y: seagrassY))

            // To Mangrove
            let mangroveX = geometry.size.width * 0.7
            let mangroveY = geometry.size.height * 0.65

            path.move(to: CGPoint(x: seagrassX, y: seagrassY))
            path.addLine(to: CGPoint(x: mangroveX, y: mangroveY))

            // To Deep Ocean
            let deepX = geometry.size.width * 0.88
            let deepY = geometry.size.height * 0.35

            path.move(to: CGPoint(x: seagrassX, y: seagrassY))
            path.addLine(to: CGPoint(x: deepX, y: deepY))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, dash: [10, 8]))
        .foregroundColor(Color(hex: "FFD700").opacity(0.8))
    }
}

// MARK: - Clouds Background

struct CloudsBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 200, height: 80)
                    .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.08)

                CloudShape()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 150, height: 60)
                    .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.12)

                CloudShape()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 180, height: 70)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.06)

                CloudShape()
                    .fill(Color.white.opacity(0.65))
                    .frame(width: 120, height: 50)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.15)
            }
        }
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.addEllipse(in: CGRect(x: 0, y: height * 0.4, width: width * 0.4, height: height * 0.6))
        path.addEllipse(in: CGRect(x: width * 0.2, y: height * 0.2, width: width * 0.5, height: height * 0.7))
        path.addEllipse(in: CGRect(x: width * 0.5, y: height * 0.35, width: width * 0.45, height: height * 0.55))
        path.addEllipse(in: CGRect(x: width * 0.7, y: height * 0.45, width: width * 0.3, height: height * 0.5))

        return path
    }
}

// MARK: - Astronaut Character

struct AstronautCharacter: View {
    var body: some View {
        ZStack {
            // Body (simplified astronaut)
            VStack(spacing: 0) {
                // Helmet
                Circle()
                    .fill(Color(hex: "1E3A5F"))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 3)
                    )
                    .overlay(
                        // Visor
                        Circle()
                            .fill(Color(hex: "87CEEB").opacity(0.8))
                            .frame(width: 36, height: 36)
                    )

                // Body
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "2E5A8F"))
                    .frame(width: 40, height: 50)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.white, lineWidth: 2)
                    )

                // Arms
                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 12, height: 30)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 12, height: 30)
                }
                .frame(width: 50)

                // Legs
                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 14, height: 25)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 14, height: 25)
                }
            }

            // Star in hand
            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "FFD700"))
                .shadow(color: .yellow.opacity(0.8), radius: 8)
                .offset(x: 30, y: -20)
        }
    }
}

// MARK: - Back Button

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 44, height: 44)

                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    ChapterSelectView(viewModel: GameViewModel())
}
