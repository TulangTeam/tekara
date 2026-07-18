//
//  EpisodeList.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodeListView: View {
    var onEpisodeSelected: ((Int) -> Void)?

    var body: some View {
        HStack(spacing: 20) {

            EpisodeCard(
                episodeNumber: "1",
                title: "CLEAN UP THE\nSEASHORE",
                status: .begin,
                episodeId: 1,
                onTap: { onEpisodeSelected?(1) }
            )

            EpisodeCard(
                episodeNumber: "2",
                title: "SAVE THE\nTURTLES",
                status: .locked,
                episodeId: 2,
                onTap: {}
            )

            EpisodeCard(
                episodeNumber: "3",
                title: "LOST LITTLE\nFISH",
                status: .locked,
                episodeId: 3,
                onTap: {}
            )

            EpisodeCard(
                episodeNumber: "4",
                title: "SAVE THE\nCORAL",
                status: .locked,
                episodeId: 4,
                onTap: {}
            )
            
            EpisodeCard(
                episodeNumber: "5",
                title: "WELCOME\nHOME",
                status: .locked,
                episodeId: 5,
                onTap: {}
            )
            
            EpisodeCard(
                episodeNumber: "6",
                title: "BE THE\nOCEAN HERO!",
                status: .locked,
                episodeId: 6,
                onTap: {}
            )

        }
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Color.blue.opacity(0.5).ignoresSafeArea()

        EpisodeListView()
    }
}
