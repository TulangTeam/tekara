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
            ToolbarButton(iconName: "gearshape.fill", action: onSettings)
            ToolbarButton(iconName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill", action: onSoundToggle)
            ToolbarButton(iconName: "house.fill", action: onHome)
            ToolbarButton(iconName: "questionmark.circle.fill", action: {})
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
