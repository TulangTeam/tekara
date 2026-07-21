//
//  EpisodeList.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodeListView: View {
    var onEpisodeSelected: ((Int) -> Void)?
    var audioManager: AudioManager? = nil

    @State private var cardScales: [CGFloat] = Array(repeating: 0, count: 6)

    private let episodes: [(number: String, title: String, status: EpisodeStatus)] = [
        ("1", "CLEAN UP THE\nSEASHORE", .begin),
        ("2", "SAVE THE\nTURTLES", .locked),
        ("3", "LOST LITTLE\nFISH", .locked),
        ("4", "SAVE THE\nCORAL", .locked),
        ("5", "WELCOME\nHOME", .locked),
        ("6", "BE THE\nOCEAN HERO!", .locked),
    ]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(episodes.enumerated()), id: \.offset) { index, episode in
                EpisodeCard(
                    episodeNumber: episode.number,
                    title: episode.title,
                    status: episode.status,
                    episodeId: index + 1,
                    onTap: { onEpisodeSelected?(index + 1) },
                    audioManager: audioManager
                )
                .scaleEffect(cardScales[index])
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            for index in episodes.indices {
                withAnimation(StaggeredAnimation.spring(delay: index)) {
                    cardScales[index] = 1
                }
            }
        }
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.5).ignoresSafeArea()

        EpisodeListView()
    }
}
