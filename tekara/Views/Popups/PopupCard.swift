//
//  PopupCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 20/07/26.
//

import SwiftUI

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

#Preview {
    PopupCard(title: "Did you know?") {
        Text("This is sample content inside the popup card.\nIt can be any SwiftUI view.")
            .font(.custom("Baloo 2", size: 17))
            .multilineTextAlignment(.center)
            .foregroundColor(PopupStyle.textColor)
        HStack(spacing: 16) {
            PopupButton(title: "Back", face: Color.gray, edge: PopupStyle.neutralEdge) {}
            PopupButton(title: "Next") {}
        }
    }
}
