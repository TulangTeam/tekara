//
//  EpisodesView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodesView: View {
    @Bindable var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    @State private var bannerScale: CGFloat = 0
    @State private var bubbleOffset: CGFloat = 200

    var body: some View {
        ZStack {
            Image("bgocean")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
//                .blur(radius: 4)

            VStack(spacing: 0) {
                HStack {
                    BackButton(action: {
                        viewModel.navigateTo(.chapter)
                    }, audioManager: audioManager)
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 50)

                SectionTitleBanner(
                    title: "SEASHORE & CORAL REEF",
                    subtitle: "EPISODE 1-6",
                    leadingDecoration: "coral_red",
                    trailingDecoration: "coral_purple"
                )
                .offset(y: -40)
                .scaleEffect(bannerScale)
                .frame(width: 400)

                EpisodeListView(
                    onEpisodeSelected: { episodeId in
                        viewModel.navigateToStory(episodeId: episodeId)
                    },
                    audioManager: audioManager
                )
                .scaleEffect(1.1)

                Spacer()

                Image("episodebubble")
                    .padding(.bottom, 20)
                    .offset(y: bubbleOffset)
                    .scaleEffect(1.2)

                Spacer()
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .onAppear {
            audioManager.playBackgroundMusic(named: "beachtrack.mp3")
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                bannerScale = 1
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
