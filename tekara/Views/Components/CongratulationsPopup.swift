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

    private let cardBackground = Color(red: 0.92, green: 0.91, blue: 0.87)
    private let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.72)
    private let themeGreen = Color(red: 0.18, green: 0.73, blue: 0.16)
    private let themeRed = Color(red: 0.85, green: 0.30, blue: 0.25)

    @State private var popupScale: CGFloat = 0
    @State private var bgOpacity: Double = 0

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
            Color.black.opacity(0.4 * bgOpacity)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(spacing: 18) {
                Text("Congratulations")
                    .font(.custom("Baloo 2", size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(themeBlue)
                    )
                    .offset(y: -10)

                Text(
                    "You have completed the \(episodeOrdinal) episode\nof Seashore & Coral Reef!"
                )
                .font(.custom("Baloo 2", size: 20))
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)

                HStack(spacing: 16) {
                    Button(action: onBackToEpisodes) {
                        Text("Back to Episodes")
                            .font(.custom("Baloo 2", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(themeRed)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())

                    Button(action: onNextEpisode) {
                        Text("Next episode")
                            .font(.custom("Baloo 2", size: 16))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                Capsule().fill(themeGreen)
                            )
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
                .padding(.bottom, 20)
            }
            .frame(maxWidth: 480)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(cardBackground)
                    .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(themeBlue.opacity(0.6), lineWidth: 3)
            )
            .padding(.horizontal, 40)
            .scaleEffect(popupScale)
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.3)) {
                bgOpacity = 1
            }
            withAnimation(
                .spring(response: 0.7, dampingFraction: 0.6).delay(0.1)
            ) {
                popupScale = 1
            }
        }
    }
}
