//
//  IconCircleButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

/// Shared 3D circular icon button used by BackButton and LeftToolbarButton.
struct IconCircleButton: View {
    let iconName: String
    var iconOffset: CGSize = .zero
    var audioManager: AudioManager? = nil
    let action: () -> Void

    private let iconColor = Color(red: 0.11, green: 0.5, blue: 0.62)
    private let edgeColor = Color(red: 0.82, green: 0.88, blue: 0.9)
    private let size: CGFloat = 52
    private let pressDepth: CGFloat = 5

    @State private var isPressed = false

    var body: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .fill(edgeColor)
                .frame(width: size, height: size)

            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .overlay(Circle().stroke(Color.yellow, lineWidth: 2))
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(iconColor)
                        .offset(iconOffset)
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
    HStack(spacing: 20) {
        IconCircleButton(iconName: "chevron.left", iconOffset: CGSize(width: -1, height: 0)) {}
        IconCircleButton(iconName: "gearshape.fill") {}
        IconCircleButton(iconName: "questionmark.circle.fill") {}
    }
    .padding()
}
