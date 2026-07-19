//
//  OceanFactPopup.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct OceanFactPopup: View {
    let onNext: () -> Void

    private let cardBackground = Color(red: 0.92, green: 0.91, blue: 0.87)
    private let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.72)
    private let themeGreen = Color(red: 0.18, green: 0.73, blue: 0.16)

    @State private var popupScale: CGFloat = 0
    @State private var bgOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.4 * bgOpacity)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(spacing: 20) {
                Text("Ocean Fact")
                    .font(.custom("Baloo 2", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(themeBlue)
                    )
                    .offset(y: -10)

                VStack(spacing: 20) {
                    Text(
                        "Trash left on the beach can be carried\ninto the ocean by the waves."
                    )
                    .font(.custom("Baloo 2", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                    .multilineTextAlignment(.center)

                    Text(
                        "Shells and sea stars are part of nature\nand should stay where they belong."
                    )
                    .font(.custom("Baloo 2", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.25, green: 0.25, blue: 0.25))
                    .multilineTextAlignment(.center)
                }
                .padding(.horizontal, 24)

                Button(action: onNext) {
                    Text("Next")
                        .font(.custom("Baloo 2", size: 18))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(themeGreen)
                        )
                }
                .buttonStyle(ScaleButtonStyle())
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
                    .strokeBorder(
                        Color(red: 0.85, green: 0.83, blue: 0.78),
                        lineWidth: 2
                    )
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
