//
//  SquishButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct SquishCapsuleButton: View {
    let text: String
    let top: Color
    let edge: Color
    var horizontalPadding: CGFloat = 30
    var audioManager: AudioManager?
    let action: () -> Void

    @State private var isPressed = false
    private let pressDepth: CGFloat = 5

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(edge)

            Capsule()
                .fill(top)
                .overlay(Capsule().stroke(Color.white, lineWidth: 3))
                .overlay(
                    Text(text)
                        .font(.custom("Baloo 2", size: 18).bold())
                        .foregroundColor(.white)
                )
                .padding(.bottom, pressDepth)
                .offset(y: isPressed ? pressDepth : 0)
        }
        .padding(.horizontal, horizontalPadding)
        .padding(.vertical, 12)
        .fixedSize()
        .contentShape(Rectangle())
        .onTapGesture {
            audioManager?.playSFX(named: "bubblesound.mp3")
            withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
                action()
            }
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        SquishCapsuleButton(text: "Back", top: Color.gray, edge: PopupStyle.neutralEdge) {}
        SquishCapsuleButton(text: "Next", top: PopupStyle.themeGreen, edge: PopupStyle.successEdge) {}
        SquishCapsuleButton(text: "Play", top: PopupStyle.themeBlue, edge: PopupStyle.themeBlue.opacity(0.6)) {}
    }
    .padding()
    .background(Color(red: 0.92, green: 0.91, blue: 0.87))
}