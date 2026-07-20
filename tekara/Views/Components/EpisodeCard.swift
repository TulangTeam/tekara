//
//  EpisodeCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

enum EpisodeStatus {
    case begin
    case completed
    case locked

    var text: String {
        switch self {
        case .begin: return "Begin"
        case .completed: return "Completed"
        case .locked: return "Locked"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.18, green: 0.73, blue: 0.16)
        case .locked: return Color.gray
        }
    }
}

struct EpisodeCard: View {
    var episodeNumber: String = "1"
    var title: String = "CLEAN UP THE\nSEASHORE"
    var status: EpisodeStatus = .completed
    var episodeId: Int = 1
    var onTap: (() -> Void)? = nil
    var audioManager: AudioManager? = nil

    let cardBackground = PopupStyle.cardBackground
    let themeBlue = PopupStyle.themeBlue

    var body: some View {
        Button(action: {
            audioManager?.playSFX(named: "bubblesound.mp3")
            if status == .begin {
                onTap?()
            }
        }) {
            VStack {
                Text(episodeNumber)
                    .font(.custom("Baloo 2", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .frame(width: 60, height: 60)
                    .background(Circle().fill(themeBlue))
                    .padding(.top, 30)

                Spacer()

                Text(title)
                    .font(.custom("Baloo 2", size: 16))
                    .fontWeight(.heavy)
                    .foregroundColor(themeBlue)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 10)
                    .padding(.bottom, 12)

                Text(status.text)
                    .font(.custom("Baloo 2", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(status.backgroundColor))
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
            }
            .frame(width: 160, height: 340)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(cardBackground)
            )
            .opacity(status == .locked ? 0.6 : 1.0)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.8).ignoresSafeArea()

        HStack(spacing: 20) {
            EpisodeCard()
        }
    }
}
