//
//  BackButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var audioManager: AudioManager?

    private let iconColor = Color(red: 0.11, green: 0.5, blue: 0.62)   // ocean blue
    private let edgeColor = Color(red: 0.82, green: 0.88, blue: 0.9)   // rim peeking out below

    private let size: CGFloat = 52
    private let pressDepth: CGFloat = 5

    @State private var isPressed = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Base — fixed rim
            Circle()
                .fill(edgeColor)
                .frame(width: size, height: size)

            // Top face — raised at rest, drops flush on press
            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                .overlay(
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22, weight: .bold)) // Matched to size 22
                        .foregroundColor(iconColor)
                        .offset(x: -1) // Optically centers the chevron
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: size, height: size + pressDepth)
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
        // Light background to see the white border
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        BackButton(action: {
            print("Back button tapped!")
        })
    }
}
