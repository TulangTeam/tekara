//
//  EpisodeCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodeCard: View {
    var episodeNumber: String = "1"
    var title: String = "CLEAN UP THE\nSEASHORE"
    var status: EpisodeStatus = .begin
    var episodeId: Int = 1
    var stars: Int = 0
    var onTap: (() -> Void)? = nil
    var audioManager: AudioManager? = nil

    private let cardBackground = PopupStyle.cardBackground
    private let themeBlue = PopupStyle.themeBlue

    private let cardWidth: CGFloat = 160
    private let cardHeight: CGFloat = 340
    private let cardPressDepth: CGFloat = 6   // card-level 3D lip
    private let badgeSize: CGFloat = 60
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 36
    private let buttonPressDepth: CGFloat = 4
    private let borderWidth: CGFloat = 4

    @State private var buttonPressed = false
    @State private var pulse = false   // "next episode" spotlight animation

    var body: some View {
        ZStack(alignment: .bottom) {
            // NEW — base layer, gives the whole card the same tactile lip as buttons
            RoundedRectangle(cornerRadius: 24)
                .fill(status.cardEdge)
                .frame(width: cardWidth, height: cardHeight)

            cardFace
                .offset(y: -cardPressDepth)
        }
        .frame(width: cardWidth, height: cardHeight + cardPressDepth)
        .saturation(status == .locked ? 0 : 1)   // CHANGED — true desaturation, not just opacity
        .opacity(status == .locked ? 0.75 : 1.0)
        .overlay(alignment: .topTrailing) {
            if status == .begin {
                nextBadge
            }
        }
        .onAppear {
            if status == .begin {
                withAnimation(.easeInOut(duration: 0.9).repeatForever(autoreverses: true)) {
                    pulse = true
                }
            }
        }
    }

    private var cardFace: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(status.badgeColor)
                    .frame(width: badgeSize, height: badgeSize)

                Text(episodeNumber)
                    .font(.custom("Baloo 2", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.top, 20)

            Spacer()

            Text(title)
                .font(.custom("Baloo 2", size: 14))
                .fontWeight(.heavy)
                .foregroundColor(themeBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

            StarRating(filled: stars)
                .padding(.top, 8)

            Spacer()

            statusButtonView
                .padding(.bottom, 16)
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24)
                .stroke(status.borderColor, lineWidth: status == .begin ? borderWidth + 1 : borderWidth)
        )
    }

    // NEW — a small sticker-style badge that marks the next playable episode,
    // so a child scanning the row doesn't have to read text to know where to tap.
    private var nextBadge: some View {
        Image(systemName: "star.fill")
            .font(.system(size: 16, weight: .bold))
            .foregroundColor(.white)
            .padding(8)
            .background(Circle().fill(Color(red: 1.0, green: 0.48, blue: 0.33)))
            .overlay(Circle().stroke(Color.white, lineWidth: 2))
            .scaleEffect(pulse ? 1.12 : 0.95)
            .offset(x: 8, y: -8 - cardPressDepth)
    }

    private var statusButtonView: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(status.buttonEdge)
                .frame(width: buttonWidth, height: buttonHeight)

            Capsule()
                .fill(status.buttonTop)
                .frame(width: buttonWidth, height: buttonHeight)
                .overlay(
                    Group {
                        if status == .locked {
                            Image(systemName: "lock.fill")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(.white)
                        } else {
                            Text(status.text)
                                .font(.custom("Baloo 2", size: 16))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                    }
                )
                .offset(y: buttonPressed ? 0 : -buttonPressDepth)
        }
        .frame(width: buttonWidth, height: buttonHeight + buttonPressDepth)
        .contentShape(Rectangle())
        .onTapGesture {
            guard status != .locked else { return }
            audioManager?.playSFX(named: "bubblesound.mp3")
            withAnimation(.easeOut(duration: 0.06)) { buttonPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { buttonPressed = false }
                if status == .begin { onTap?() }
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.11, green: 0.44, blue: 0.62)
            .ignoresSafeArea()

        HStack(spacing: 24) {
            EpisodeCard(episodeNumber: "1", title: "CLEAN UP THE\nSEASHORE", status: .begin, stars: 2)
            EpisodeCard(episodeNumber: "2", title: "SAVE THE\nTURTLES", status: .completed, stars: 2)
            EpisodeCard(episodeNumber: "3", title: "LOST LITTLE\nFISH", status: .locked, stars: 0)
        }
    }
}
