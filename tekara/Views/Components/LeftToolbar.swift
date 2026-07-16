//
//  LeftToolbar.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct LeftToolbar: View {
    let onMusicToggle: () -> Void
    let onSoundToggle: () -> Void
    let isSoundEnabled: Bool
    let onHelp: () -> Void
    let onGear: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            LeftToolbarButton(iconName: "gearshape.fill", action: onGear)
            LeftToolbarButton(iconName: "music.note.slash", action: onMusicToggle)
            LeftToolbarButton(iconName: isSoundEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill", action: onSoundToggle)
            LeftToolbarButton(iconName: "questionmark.circle.fill", action: onHelp)
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
    }
}

#Preview {
    ZStack {
        Color.blue
        LeftToolbar(
            onMusicToggle: {},
            onSoundToggle: {},
            isSoundEnabled: true,
            onHelp: {},
            onGear: {}
        )
    }
}
