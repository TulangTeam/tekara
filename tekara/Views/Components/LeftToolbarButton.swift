//
//  LeftToolbarButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct LeftToolbarButton: View {
    let iconName: String
    let action: () -> Void

    private let iconColor = Color(red: 0.11, green: 0.5, blue: 0.62)   // ocean blue
    private let edgeColor = Color(red: 0.82, green: 0.88, blue: 0.9)   // rim peeking out below

    private let size: CGFloat = 52
    private let pressDepth: CGFloat = 5

    @State private var isPressed = false

    var body: some View {
        ZStack(alignment: .bottom) {
            // Base — fixed rim, this is what makes it read as 3D
            Circle()
                .fill(edgeColor)
                .frame(width: size, height: size)

            // Top face — raised at rest, drops flush on press
            Circle()
                .fill(Color.white)
                .overlay(Capsule().stroke(Color.yellow, lineWidth: 2))
                .frame(width: size, height: size)
                .overlay(
                    Image(systemName: iconName)
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(iconColor)
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: size, height: size + pressDepth)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
            }
            action()
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        LeftToolbarButton(iconName: "gearshape.fill", action: {})
    }
}
