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
    static let cardPressDepth: CGFloat = 8   // NEW — matches DialogueCard's static lip

    static let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.72)

    // CHANGED — success/neutral now match the kit's shared color-token pairs
    // (see design-guidelines.md §4) instead of one-off popup-local colors.
    static let successFace = Color(red: 0.37, green: 0.82, blue: 0.41)
    static let successEdge = Color(red: 0.16, green: 0.55, blue: 0.19)
    static let neutralFace = Color.gray
    static let neutralEdge = Color(red: 0.35, green: 0.35, blue: 0.35)
    static let themeGreen = Color(red: 0.37, green: 0.82, blue: 0.41)
    static let themeRed = Color(red: 0.85, green: 0.30, blue: 0.25)
    static let themeRedEdge = Color(red: 0.58, green: 0.16, blue: 0.12)   // NEW

    static let cardBackground = Color(red: 0.92, green: 0.91, blue: 0.87)
    static let cardEdge = Color(red: 0.78, green: 0.76, blue: 0.69)       // NEW — replaces borderColor+shadow
    static let textColor = Color(red: 0.25, green: 0.25, blue: 0.25)
}

struct PopupCard<Content: View>: View {
    let title: String
    var headerColor: Color = PopupStyle.themeBlue
    @ViewBuilder let content: () -> Content

    @State private var popupScale: CGFloat = 0.85   // CHANGED — was 0
    @State private var popupOpacity: Double = 0      // NEW
    @State private var bgOpacity: Double = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion   // NEW

    var body: some View {
        ZStack {
            Color.black.opacity(0.4 * bgOpacity)
                .ignoresSafeArea()
                .onTapGesture {}

            ZStack(alignment: .top) {
                // FIXED — base lip is now a sized .background() on cardFace,
                // not an ambient .shadow(). Same bug class as the dialogue card:
                // a shadow reads as ambient light, not a physical edge.
                cardFace
                    .background(
                        RoundedRectangle(cornerRadius: 24)
                            .fill(PopupStyle.cardEdge)
                            .offset(y: PopupStyle.cardPressDepth)
                    )
                    .padding(.bottom, PopupStyle.cardPressDepth)

                Text(title)
                    .font(.custom("Baloo 2", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 36)
                    .padding(.vertical, 8)
                    .background(Capsule().fill(headerColor))
                    .overlay(Capsule().stroke(Color.white, lineWidth: 3))
                    .offset(y: -18)
            }
            .scaleEffect(popupScale)
            .opacity(popupOpacity)
        }
        .onAppear { animateIn() }
    }

    private var cardFace: some View {
        VStack(spacing: 16) {
            Spacer().frame(height: 14)   // room for the floating title
            content()
        }
        .padding(.bottom, 20)
        .frame(width: PopupStyle.cardWidth)
        .background(
            RoundedRectangle(cornerRadius: 24).fill(PopupStyle.cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24).stroke(PopupStyle.cardEdge, lineWidth: 3)
        )
    }

    // NEW — extracted, and now respects Reduce Motion
    private func animateIn() {
        guard !reduceMotion else {
            bgOpacity = 1
            popupScale = 1
            popupOpacity = 1
            return
        }
        withAnimation(.easeOut(duration: 0.3)) { bgOpacity = 1 }
        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.1)) {
            popupScale = 1
            popupOpacity = 1
        }
    }
}

/// Shared capsule action button used inside popups.
private struct ButtonSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct PopupButton: View {
    let title: String
    var face: Color = PopupStyle.successFace
    var edge: Color = PopupStyle.successEdge
    var isEnabled: Bool = true
    let action: () -> Void

    @State private var isPressed = false
    @State private var size: CGSize = CGSize(width: 140, height: 40)
    private let pressDepth: CGFloat = 5

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(isEnabled ? edge : PopupStyle.neutralEdge)
                .frame(width: size.width, height: size.height)

            Capsule()
                .fill(isEnabled ? face : PopupStyle.neutralFace)
                .frame(width: size.width, height: size.height)
                .overlay(
                    Text(title)
                        .font(.custom("Baloo 2", size: 17).bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: size.width, height: size.height + pressDepth)
        .background(
            Text(title)
                .font(.custom("Baloo 2", size: 17).bold())
                .padding(.horizontal, 32)
                .padding(.vertical, 10)
                .fixedSize()
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: ButtonSizeKey.self, value: proxy.size)
                    }
                )
                .hidden()
        )
        .onPreferenceChange(ButtonSizeKey.self) { size = $0 }
        .saturation(isEnabled ? 1 : 0)
        .opacity(isEnabled ? 1 : 0.75)
        .contentShape(Rectangle())
        .onTapGesture {
            guard isEnabled else { return }
            withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
                action()
            }
        }
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
