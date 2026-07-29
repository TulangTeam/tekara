//
//  CongratulationsPopup.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI
import UIKit

struct CongratulationsPopup: View {
    let episodeId: Int
    let onBackToEpisodes: () -> Void
    let onNextEpisode: () -> Void

    // Scoring TBD — for now every completion is 3 stars.
    private let starsEarned: Int = 3

    @State private var starScales: [CGFloat] = [0, 0, 0]
    @State private var burstTrigger = false
    @State private var textOpacity: Double = 0
    @State private var buttonsOffset: CGFloat = 24
    @State private var buttonsOpacity: Double = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let audioManager = AudioManager.shared
    private let gold = Color(red: 0.90, green: 0.82, blue: 0.15)
    private let dimGray = Color(red: 0.72, green: 0.72, blue: 0.72)

    private var episodeOrdinal: String {
        switch episodeId {
        case 1: return "1st"
        case 2: return "2nd"
        case 3: return "3rd"
        default: return "\(episodeId)th"
        }
    }

    var body: some View {
        ZStack {
            // Confetti layer sits behind the card so it never intercepts taps.
            CelebrationBurst(trigger: burstTrigger)
                .frame(width: 480, height: 480)
                .allowsHitTesting(false)

            PopupCard(title: "Awesome job!", headerColor: PopupStyle.successFace) {
                VStack(spacing: 18) {
                    HStack(spacing: 10) {
                        ForEach(0..<3, id: \.self) { i in
                            Image(systemName: i < starsEarned ? "star.fill" : "star")
                                .font(.system(size: 34))
                                .foregroundColor(i < starsEarned ? gold : dimGray)
                                .scaleEffect(starScales[i])
                        }
                    }

                    Text(
                        "You finished the \(episodeOrdinal) episode\nof Seashore & coral reef!"
                    )
                    .font(.custom("Baloo 2", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(PopupStyle.textColor)
                    .multilineTextAlignment(.center)
                    .opacity(textOpacity)
                }
                .padding(.horizontal, 24)

                HStack(spacing: 16) {
                    PopupButton(
                        title: "Back to episodes",
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
                .offset(y: buttonsOffset)
                .opacity(buttonsOpacity)
            }
        }
        .onAppear { celebrate() }
    }

    // Sequences completion into a beat — impact → stars count up
    // (each with its own chime) → text settles → actions arrive last,
    // once there's something to act on. Reduce Motion collapses the
    // timeline to its end state immediately.
    private func celebrate() {
        guard !reduceMotion else {
            starScales = [1, 1, 1]
            textOpacity = 1
            buttonsOffset = 0
            buttonsOpacity = 1
            return
        }

        UINotificationFeedbackGenerator().notificationOccurred(.success)
        audioManager.playSFX(named: "fanfare.mp3")
        burstTrigger = true

        for i in 0..<starsEarned {
            let delay = 0.45 + Double(i) * 0.18
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                audioManager.playSFX(named: "starpop.mp3")
            }
            withAnimation(.spring(response: 0.4, dampingFraction: 0.5).delay(delay)) {
                starScales[i] = 1
            }
        }
        withAnimation(.easeOut(duration: 0.2).delay(0.45)) {
            for i in starsEarned..<3 { starScales[i] = 1 }
        }
        withAnimation(.easeOut(duration: 0.3).delay(0.9)) {
            textOpacity = 1
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7).delay(1.15)) {
            buttonsOffset = 0
            buttonsOpacity = 1
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