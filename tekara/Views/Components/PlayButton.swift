//
//  PlayButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct PlayButton: View {
    var label: String = "PLAY"
    var action: () -> Void
    var audioManager: AudioManager?

    private let buttonGreen = Color(red: 0.37, green: 0.82, blue: 0.41)     // top face
    private let buttonGreenDark = Color(red: 0.16, green: 0.55, blue: 0.19) // base edge

    @State private var isPressed = false

    private let width: CGFloat = 240
    private let height: CGFloat = 65
    private let pressDepth: CGFloat = 8 // visible edge thickness at rest

    var body: some View {
        ZStack(alignment: .bottom) {
            // Base layer — fixed at the bottom, this is the "edge" you see peeking out
            Capsule()
                .fill(buttonGreenDark)
                .frame(width: width, height: height)

            // Top face — sits ABOVE the base at rest (exposing the edge below it),
            // and drops down flush with the base when pressed.
            Capsule()
                .fill(buttonGreen)
//                .overlay(Capsule().stroke(Color.white, lineWidth: 4))
                .frame(width: width, height: height)
                .overlay(
                    Text(label)
                        .font(.custom("Baloo 2", size: 28, relativeTo: .title))
                        .bold()
                        .foregroundColor(.white)
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: width, height: height + pressDepth)
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
    ZStack {
        Color(red: 0.0, green: 0.53, blue: 1.0)
            .ignoresSafeArea()

        PlayButton(action: {})
    }
}
