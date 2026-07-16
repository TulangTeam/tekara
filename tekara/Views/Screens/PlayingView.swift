//
//  PlayingView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct PlayingView: View {
    @ObservedObject var viewModel: GameViewModel
    let chapterId: String

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(hex: "1A5276")
                    .ignoresSafeArea()

                VStack {
                    HStack {
                        BackButton { viewModel.navigateTo(.chapterSelect) }
                        Spacer()
                        Text(chapterId.uppercased())
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2)
                        Spacer()
                        Image(systemName: "pause.circle.fill")
                            .font(.system(size: 36))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, geometry.safeAreaInsets.top + 16)

                    Spacer()

                    VStack(spacing: 16) {
                        Image(systemName: "cube.transparent")
                            .font(.system(size: 80))
                            .foregroundColor(.white.opacity(0.5))
                        Text("RealityKit 3D View")
                            .font(.title2)
                            .foregroundColor(.white.opacity(0.7))
                        Text("Coming Soon")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.5))
                    }

                    Spacer()

                    HStack {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle().fill(Color.yellow).frame(width: 20, height: 20)
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
                }
            }
        }
    }
}
