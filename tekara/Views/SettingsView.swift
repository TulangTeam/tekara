//
//  SettingsView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .clipped()
                    .overlay(Color.black.opacity(0.4))

                VStack(spacing: 32) {
                    // Header
                    HStack {
                        BackButton {
                            viewModel.navigateTo(.welcome)
                        }
                        Spacer()
                        Text("Settings")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 4)
                        Spacer()
                        // Placeholder for symmetry
                        Color.clear.frame(width: 44, height: 44)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, geometry.safeAreaInsets.top + 16)

                    Spacer()

                    // Settings options placeholder
                    VStack(spacing: 20) {
                        SettingsRow(icon: "speaker.wave.2.fill", title: "Sound", isOn: viewModel.gameState.isSoundEnabled) {
                            viewModel.toggleSound()
                        }

                        SettingsRow(icon: "music.note", title: "Music", isOn: true) {}

                        SettingsRow(icon: "hand.tap.fill", title: "Haptics", isOn: true) {}
                    }
                    .padding(.horizontal, 40)

                    Spacer()

                    // Version info
                    Text("Tekara v1.0")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.6))
                        .padding(.bottom, geometry.safeAreaInsets.bottom + 40)
                }
            }
            .ignoresSafeArea()
        }
    }
}

// MARK: - Settings Row

struct SettingsRow: View {
    let icon: String
    let title: String
    let isOn: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)

            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: .constant(isOn))
                .labelsHidden()
                .tint(.orange)
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.ultraThinMaterial)
        )
    }
}

#Preview {
    SettingsView(viewModel: GameViewModel())
}
