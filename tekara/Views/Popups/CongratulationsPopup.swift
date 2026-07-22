//
//  CongratulationsPopup.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct CongratulationsPopup: View {
    let episodeId: Int
    let onBackToEpisodes: () -> Void
    let onNextEpisode: () -> Void

    private var episodeOrdinal: String {
        switch episodeId {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(episodeId)th"
        }
    }

    var body: some View {
        PopupCard(title: "Congratulations") {
            Text(
                "You have completed the \(episodeOrdinal) episode\nof Seashore & Coral Reef!"
            )
            .font(.custom("Baloo 2", size: 20))
            .fontWeight(.bold)
            .foregroundColor(PopupStyle.textColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)

            HStack(spacing: 16) {
                PopupButton(
                    title: "Back to Episodes",
                    face: PopupStyle.themeRed,
                    edge: PopupStyle.themeRedEdge,
                    action: onBackToEpisodes
                )

                // Placeholder: only episode 1 exists for now
                PopupButton(
                    title: "Next episode",
                    isEnabled: false,
                    action: onNextEpisode
                )
            }
        }
    }
}

#Preview {
    CongratulationsPopup(
        episodeId: 1,
        onBackToEpisodes: {},
        onNextEpisode: {}
    )
}
