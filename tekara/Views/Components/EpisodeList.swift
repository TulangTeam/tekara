//
//  EpisodeList.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodeListView: View {
    var body: some View {


        HStack(spacing: 20) {

            EpisodeCard(
                episodeNumber: "1",
                title: "CLEAN UP THE\nSEASHORE",
                status: .completed
            )

            EpisodeCard(
                episodeNumber: "2",
                title: "SAVE THE\nTURTLES",
                status: .begin
            )

            EpisodeCard(
                episodeNumber: "3",
                title: "LOST LITTLE\nFISH",
                status: .locked
            )

            EpisodeCard(
                episodeNumber: "4",
                title: "SAVE THE\nCORAL",
                status: .locked
            )

            EpisodeCard(
                episodeNumber: "5",
                title: "WELCOME\nHOME",
                status: .locked
            )

            EpisodeCard(
                episodeNumber: "6",
                title: "BE THE\nOCEAN HERO!",
                status: .locked
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
