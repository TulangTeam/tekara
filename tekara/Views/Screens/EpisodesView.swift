//
//  EpisodesView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodesView: View {
    @ObservedObject var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    @State private var titleScale: CGFloat = 0
    @State private var listScale: CGFloat = 0
    @State private var bubbleOffset: CGFloat = 200

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)

                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.chapter)
                        }, audioManager: audioManager)
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    Spacer()
                }

                VStack(spacing: 72){
                    Image("episodetitle")
                        .scaleEffect(titleScale)
                    EpisodeListView(
                        onEpisodeSelected: { episodeId in
                            viewModel.navigateToStory(episodeId: episodeId)
                        }
                    )
                    .scaleEffect(listScale)
                    Image("episodebubble")
                        .padding(.bottom, 20)
                        .offset(y: bubbleOffset)
                }

                VStack {
                    Spacer()
                    HStack {
                        LeftToolbar(
                            onHelp: {},
                            onGear: {},
                            audioManager: audioManager
                        )
                        .padding(.leading, 32)
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
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.3)) {
                listScale = 1
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0).delay(0.2)) {
                bubbleOffset = 0
            }
        }
    }
}

#Preview {
    EpisodesView(viewModel: GameViewModel())
}
