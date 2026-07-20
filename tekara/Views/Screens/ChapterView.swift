//
//  ChapterView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterView: View {
    @Bindable var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    @State private var titleScale: CGFloat = 0
    @State private var bubbleOffset: CGFloat = 200

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)
                MapSelect(onMapSelected: {
                    viewModel.navigateTo(.episodes)
                }, audioManager: audioManager)
                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.welcome)
                        }, audioManager: audioManager)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    Spacer()
                }
                VStack {
                    Image("chaptertitle")
                        .scaleEffect(titleScale)
                    Spacer()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("chapterbubble")
                            .padding(.bottom, 20)
                            .offset(y: bubbleOffset)
                        Spacer()
                    }
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                    }
                }

            }
        }
        .ignoresSafeArea()
        .onAppear {
            audioManager.playBackgroundMusic(named: "beachtrack.mp3")
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                titleScale = 1
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0).delay(0.2)) {
                bubbleOffset = 0
            }
        }
    }
}

#Preview {
    ChapterView(viewModel: GameViewModel())
}
