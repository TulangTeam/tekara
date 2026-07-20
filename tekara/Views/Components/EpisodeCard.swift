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
        case .completed: return "Play"
        case .locked: return "Locked"
        }
    }

    // 3D capsule button colors
    var buttonTop: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return .gray
        }
    }

    var buttonEdge: Color {
        switch self {
        case .begin: return Color(red: 0.62, green: 0.51, blue: 0.0)
        case .completed: return Color(red: 0.16, green: 0.55, blue: 0.19)
        case .locked: return Color(red: 0.35, green: 0.35, blue: 0.35)
        }
    }

    // Flat badge circle color
    var badgeColor: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return .gray
        }
    }

    // Card border color
    var borderColor: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return Color(red: 0.72, green: 0.72, blue: 0.72)
        }
    }
}

struct StarRating: View {
    let filled: Int
    let total: Int = 3

    private let starColor = Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
    private let emptyColor = Color(red: 0.72, green: 0.72, blue: 0.72)

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...total, id: \.self) { index in
                Image(systemName: index <= filled ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundColor(index <= filled ? starColor : emptyColor)
            }
        }
    }
}

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
    private let badgeSize: CGFloat = 60
    private let buttonWidth: CGFloat = 120
    private let buttonHeight: CGFloat = 36
    private let buttonPressDepth: CGFloat = 4
    private let borderWidth: CGFloat = 4

    @State private var buttonPressed = false

    var body: some View {
        VStack(spacing: 0) {
            // Flat badge circle — NOT clickable
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

            // Title
            Text(title)
                .font(.custom("Baloo 2", size: 14))
                .fontWeight(.heavy)
                .foregroundColor(themeBlue)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 10)

            // Star rating
            StarRating(filled: stars)
                .padding(.top, 8)

            Spacer()

            // 3D status button
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
                .stroke(status.borderColor, lineWidth: borderWidth)
        )
        .opacity(status == .locked ? 0.6 : 1.0)
    }

    // 3D capsule button — the only clickable element
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

        HStack(spacing: 20) {
            EpisodeCard(episodeNumber: "1", title: "CLEAN UP THE\nSEASHORE", status: .begin, stars: 2)
            EpisodeCard(episodeNumber: "2", title: "SAVE THE\nTURTLES", status: .completed, stars: 2)
            EpisodeCard(episodeNumber: "3", title: "LOST LITTLE\nFISH", status: .locked, stars: 0)
        }
    }
}
