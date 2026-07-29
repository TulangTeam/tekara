//
//  DidYouKnowPopup.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 20/07/26.
//

import AVKit
import SwiftUI

struct DidYouKnowPopup: View {
    let video: FactVideo
    var onBack: (() -> Void)? = nil
    let onNext: () -> Void

    @State private var player: AVPlayer? = nil

    var body: some View {
        PopupCard(title: "Did you know?") {
            Group {
                if let player {
                    VideoPlayer(player: player)
                } else {
                    Color.black
                }
            }
            .aspectRatio(16 / 9, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal, 28)

            Text(video.sourceCredit)
                .font(.custom("Baloo 2", size: 14))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.35, green: 0.22, blue: 0.12))

            HStack(spacing: 16) {
                if let onBack {
                    PopupButton(title: "Back", face: Color.gray, edge: PopupStyle.neutralEdge, action: {
                        player?.pause()
                        onBack()
                    })
                }

                PopupButton(title: "Next", action: {
                    player?.pause()
                    onNext()
                })
            }
        }
        .onAppear {
            if let url = Bundle.main.url(
                forResource: video.videoName,
                withExtension: "mp4"
            ) {
                let newPlayer = AVPlayer(url: url)
                newPlayer.play()
                player = newPlayer
            }
        }
        .onDisappear {
            player?.pause()
            player = nil
        }
    }
}

#Preview {
    DidYouKnowPopup(
        video: FactVideoData.getVideo(for: 1),
        onNext: {}
    )
}
