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
        HStack(spacing: 20) {
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

struct SpeakerButton: View {
    @Bindable var audioManager: AudioManager
    @State private var offsetX: CGFloat = 0

    var body: some View {
        Button(action: {
            // SFX plays when unmuting (not when muting)
            if audioManager.isSFXMuted {
                audioManager.playSFX(named: "bubblesound.mp3")
            }

            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                offsetX = audioManager.isSFXMuted ? 3 : -3
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    offsetX = 0
                }
                audioManager.toggleSFXMute()
            }
        }) {
            Image(systemName: audioManager.isSFXMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
                .frame(width: 48, height: 40)
                .offset(x: offsetX)
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        LeftToolbar(
            onHelp: {},
            onGear: {},
            audioManager: AudioManager.shared
        )
    }
}
