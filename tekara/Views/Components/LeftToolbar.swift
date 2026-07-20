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

struct SpeakerButton: View {
    @Bindable var audioManager: AudioManager
    @State private var wiggleX: CGFloat = 0
    @State private var isPressed = false

    private let iconColor = Color(red: 0.11, green: 0.5, blue: 0.62)
    private let edgeColor = Color(red: 0.82, green: 0.88, blue: 0.9)
    private let size: CGFloat = 52
    private let pressDepth: CGFloat = 5

    var body: some View {
        ZStack(alignment: .bottom) {
            Circle()
                .fill(edgeColor)
                .frame(width: size, height: size)

            Circle()
                .fill(Color.white)
                .frame(width: size, height: size)
                .overlay(Capsule().stroke(Color.yellow, lineWidth: 2))
                .overlay(
                    Image(systemName: audioManager.isSFXMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(iconColor)
                        .offset(x: wiggleX)
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: size, height: size + pressDepth)
        .contentShape(Rectangle())
        .onTapGesture {
            if audioManager.isSFXMuted {
                audioManager.playSFX(named: "bubblesound.mp3")
            }
            withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                wiggleX = audioManager.isSFXMuted ? 3 : -3
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    wiggleX = 0
                }
                audioManager.toggleSFXMute()
            }
        }
    }
}
