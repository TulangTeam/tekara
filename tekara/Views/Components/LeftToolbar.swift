//
//  LeftToolbar.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct LeftToolbar: View {
    var onHelp: () -> Void
    var onGear: () -> Void
    @Bindable var audioManager: AudioManager

    var body: some View {
        HStack(spacing: 16) {
            LeftToolbarButton(iconName: "gearshape.fill") {
                audioManager.playSFX(named: "bubblesound.mp3")
                onGear()
            }
            LeftToolbarButton(iconName: audioManager.isMusicMuted ? "music.note.slash" : "music.note") {
                audioManager.playSFX(named: "bubblesound.mp3")
                audioManager.toggleMusicMute()
            }
            SpeakerButton(audioManager: audioManager)
            LeftToolbarButton(iconName: "questionmark.circle.fill") {
                audioManager.playSFX(named: "bubblesound.mp3")
                onHelp()
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
    }
}
