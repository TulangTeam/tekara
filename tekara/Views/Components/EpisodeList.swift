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

    private let progressManager = EpisodeProgressManager.shared

    @State private var cardScales: [CGFloat] = Array(repeating: 0, count: 6)

    private let episodes: [(number: String, title: String, id: Int)] = [
        ("1", "CLEAN UP THE\nSEASHORE", 1),
        ("2", "SAVE THE\nTURTLES", 2),
        ("3", "LOST LITTLE\nFISH", 3),
        ("4", "SAVE THE\nCORAL", 4),
        ("5", "WELCOME\nHOME", 5),
        ("6", "BE THE\nOCEAN HERO!", 6),
    ]

    var body: some View {
        HStack(spacing: 20) {
            ForEach(Array(episodes.enumerated()), id: \.offset) {
                index,
                episode in
                EpisodeCard(
                    episodeNumber: episode.number,
                    title: episode.title,
                    status: progressManager.episodeStatus(for: episode.id),
                    episodeId: episode.id,
                    onTap: { onEpisodeSelected?(episode.id) },
                    audioManager: audioManager
                )
                .scaleEffect(cardScales[index])
            }
        }
        .padding(.horizontal, 40)
        .onAppear {
            for index in episodes.indices {
                withAnimation(
                    .spring(response: 0.7, dampingFraction: 0.6)
                        .delay(0.2 + Double(index) * 0.1)
                ) {
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
