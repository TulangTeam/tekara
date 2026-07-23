//
//  SeaCreatureWarningPopup.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 23/07/26.
//

import SwiftUI
import RealityKit

struct SeaCreatureWarningPopup: View {
    @Bindable var manager: TrashInteractionManager
    var type: SeaCreatureWarningType

    // Adjust card background opacity here (0.0 = completely transparent, 1.0 = solid)
    var cardOpacity: Double = 0.5

    // Typewriter state tracking
    @State private var displayedText: String = ""
    @State private var isTyping: Bool = false

    private let toriTagColor = Color(red: 0.36, green: 0.75, blue: 0.67)
    private let buttonGreen = Color(red: 0.12, green: 0.69, blue: 0.18)

    private var dialogueText: String {
        switch type {
        case .seaStar:
            return "Oops! Sea stars are living creatures. Not everything on the beach is trash — we should protect them and leave them on the sand."
        case .shell:
            return "Oops! Sea shells are homes for ocean animals. Not everything on the beach is trash — let's put it back safely on the sand."
        }
    }

    var body: some View {
        VStack {
            Spacer()

            // Floating Genshin-style Warning Card
            warningDialogueCard
                .padding(.bottom, 20)
                .allowsHitTesting(true)
        }
    }

    // MARK: - Floating Dialogue Card
    private var warningDialogueCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            // 1. Speaker Identifier (TORI)
            Text("TORI")
                .font(.custom("Baloo 2", size: 18).bold())
                .foregroundColor(toriTagColor)

            // Glowing line under speaker name
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [toriTagColor.opacity(0.9), Color.white.opacity(0.2), Color.clear],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 2)
                .padding(.bottom, 4)

            // 2. Category Title & Typewriter Text
            VStack(alignment: .leading, spacing: 2) {
                Text("PROTECT SEA CREATURES!")
                    .font(.custom("Baloo 2", size: 12).bold())
                    .foregroundColor(Color.white.opacity(0.6))

                // Height reservation template + Animated Typewriter Text
                ZStack(alignment: .topLeading) {
                    Text(dialogueText)
                        .font(.custom("Baloo 2", size: 16).bold())
                        .lineSpacing(4)
                        .opacity(0)

                    Text(displayedText)
                        .font(.custom("Baloo 2", size: 16).bold())
                        .foregroundColor(.white)
                        .lineSpacing(4)
                        .multilineTextAlignment(.leading)
                }
            }

            // 3. Action Buttons
            HStack(spacing: 12) {
                // Keep Button (Dismiss)
                Button(action: {
                    withAnimation(.easeOut(duration: 0.2)) {
                        manager.seaCreatureWarningType = nil
                    }
                }) {
                    Text("Keep")
                        .font(.custom("Baloo 2", size: 14).bold())
                        .foregroundColor(.white.opacity(0.7))
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.12))
                        )
                }

                Spacer()

                // Put Back Button (Primary Action)
                Button(action: {
                    putBackCreature()
                    withAnimation(.easeOut(duration: 0.2)) {
                        manager.seaCreatureWarningType = nil
                    }
                }) {
                    HStack(spacing: 6) {
                        Image(systemName: "arrow.down.circle.fill")
                            .font(.system(size: 15, weight: .bold))
                        Text("Put Back on Sand")
                            .font(.custom("Baloo 2", size: 14).bold())
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 18)
                    .padding(.vertical, 8)
                    .background(
                        Capsule().fill(buttonGreen)
                    )
                    .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 2)
                }
            }
            .padding(.top, 8)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 16)
        .frame(maxWidth: 480)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.05, green: 0.12, blue: 0.20).opacity(cardOpacity),
                            Color(red: 0.03, green: 0.08, blue: 0.15).opacity(cardOpacity + 0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 1.5)
                )
                .shadow(color: .black.opacity(0.35), radius: 10, x: 0, y: 5)
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if isTyping {
                isTyping = false
                displayedText = dialogueText
            }
        }
        .task(id: dialogueText) {
            displayedText = ""
            isTyping = true

            for char in dialogueText {
                guard isTyping, !Task.isCancelled else { break }
                displayedText.append(char)
                try? await Task.sleep(nanoseconds: 18_000_000)
            }

            displayedText = dialogueText
            isTyping = false
        }
    }

    // MARK: - Logic
    private func putBackCreature() {
        if type == .seaStar, let heldStar = manager.heldSeaStarEntity {
            if let kaiPos = manager.kaiWorldPosition {
                heldStar.setPosition(kaiPos + SIMD3<Float>(0.4, 0, 0.4), relativeTo: nil)
            }
            heldStar.isEnabled = true
            manager.pickedSeaStarCount = max(0, manager.pickedSeaStarCount - 1)
            manager.heldSeaStarEntity = nil
        } else if type == .shell, let heldShell = manager.heldShellEntity {
            if let kaiPos = manager.kaiWorldPosition {
                heldShell.setPosition(kaiPos + SIMD3<Float>(0.4, 0, 0.4), relativeTo: nil)
            }
            heldShell.isEnabled = true
            manager.pickedShellCount = max(0, manager.pickedShellCount - 1)
            manager.heldShellEntity = nil
        }
    }
}
