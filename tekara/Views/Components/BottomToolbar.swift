//
//  BottomToolbar.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct BottomToolbar: View {
    let onSettings: () -> Void
    let onSoundToggle: () -> Void
    let isSoundEnabled: Bool
    let onHome: () -> Void

    var body: some View {
        HStack(spacing: 24) {
            // Settings
            ToolbarButton(
                iconName: "gearshape.fill",
                action: onSettings
            )

            // Sound toggle
            ToolbarButton(
                iconName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill",
                action: onSoundToggle
            )

            // Back to welcome
            ToolbarButton(
                iconName: "house.fill",
                action: onHome
            )

            // Help
            ToolbarButton(
                iconName: "questionmark.circle.fill",
                action: {}
            )
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 14)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
        )
    }
}

// MARK: - Toolbar Button

struct ToolbarButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.blue
        VStack {
            Spacer()
            BottomToolbar(
                onSettings: {},
                onSoundToggle: {},
                isSoundEnabled: true,
                onHome: {}
            )
            .padding(.bottom, 50)
        }
    }
}
