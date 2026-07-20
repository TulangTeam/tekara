//
//  PopupCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 20/07/26.
//

import SwiftUI

/// Shared popup styling — adjust here, all popups follow.
enum PopupStyle {
    static let cardWidth: CGFloat = 520
    static let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.72)
    static let themeGreen = Color(red: 0.18, green: 0.73, blue: 0.16)
    static let themeRed = Color(red: 0.85, green: 0.30, blue: 0.25)
    static let cardBackground = Color(red: 0.92, green: 0.91, blue: 0.87)
    static let borderColor = Color(red: 0.85, green: 0.83, blue: 0.78)
    static let textColor = Color(red: 0.25, green: 0.25, blue: 0.25)
    static let disabledGray = Color.gray
}

/// Reusable popup shell shared by all mission popups.
/// Owns the dimmed background, fixed card width, capsule header,
/// card styling and the spring scale-in animation.
/// Height grows with content; width stays consistent across popups.
struct PopupCard<Content: View>: View {
    let title: String
    var headerColor: Color = PopupStyle.themeBlue
    @ViewBuilder let content: () -> Content

    @State private var popupScale: CGFloat = 0
    @State private var bgOpacity: Double = 0

    var body: some View {
        ZStack {
            Color.black.opacity(0.4 * bgOpacity)
                .ignoresSafeArea()
                .onTapGesture {}

            VStack(spacing: 16) {
                Text(title)
                    .font(.custom("Baloo 2", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(headerColor)
                    )
                    .overlay(
                        Capsule().stroke(Color.white, lineWidth: 3)
                    )
                    .offset(y: -10)

                content()
            }
            .padding(.bottom, 20)
            .frame(width: PopupStyle.cardWidth)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(PopupStyle.cardBackground)
                    .shadow(color: .black.opacity(0.2), radius: 16, x: 0, y: 8)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(PopupStyle.borderColor, lineWidth: 2)
            )
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

/// Shared capsule action button used inside popups.
struct PopupButton: View {
    let title: String
    var color: Color = PopupStyle.themeGreen
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.custom("Baloo 2", size: 17))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 32)
                .padding(.vertical, 10)
                .background(
                    Capsule().fill(isEnabled ? color : PopupStyle.disabledGray)
                )
                .overlay(
                    Capsule().stroke(Color.white, lineWidth: 3)
                )
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(!isEnabled)
        .opacity(isEnabled ? 1.0 : 0.6)
    }
}

#Preview {
    PopupCard(title: "Did you know?") {
        Text("Any content goes here — the card keeps the same width\nbut grows in height as needed.")
            .font(.custom("Baloo 2", size: 17))
            .multilineTextAlignment(.center)

        PopupButton(title: "Next", action: {})
    }
}
