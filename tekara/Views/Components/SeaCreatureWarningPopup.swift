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

    private let cardEdge = Color(red: 0.95, green: 0.87, blue: 0.68)
    private let toriTagColor = Color(red: 0.36, green: 0.75, blue: 0.67)
    private let buttonGreen = Color(red: 0.12, green: 0.69, blue: 0.18)
    private let buttonGreenEdge = Color(red: 0.06, green: 0.48, blue: 0.11)

    private var dialogueText: String {
        switch type {
        case .seaStar:
            return "Oops! Sea stars are living creatures ⭐. Not everything on the beach is trash! We should protect them and leave them on the sand."
        case .shell:
            return "Oops! Sea shells are homes for ocean animals 🐚. Not everything on the beach is trash! Let's put it back safely on the sand."
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            // Main White Card Face
            VStack(spacing: 16) {
                HStack(alignment: .center, spacing: 14) {
                    // Tori Avatar
                    ZStack {
                        Circle()
                            .fill(toriTagColor.opacity(0.2))
                            .frame(width: 60, height: 60)

                        if UIImage(named: "avatar_tori") != nil {
                            Image("avatar_tori")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                        } else {
                            Image(systemName: "turtle.fill")
                                .font(.system(size: 30))
                                .foregroundColor(toriTagColor)
                        }
                    }
                    .overlay(
                        Circle().stroke(toriTagColor, lineWidth: 4)
                    )

                    // Warning Speech Text
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Protect Sea Creatures!")
                            .font(.custom("Baloo 2", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(PopupStyle.themeBlue)

                        Text(dialogueText)
                            .font(.custom("Baloo 2", size: 15))
                            .fontWeight(.bold)
                            .foregroundColor(PopupStyle.textColor)
                            .lineSpacing(4)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }

                // Action Buttons
                HStack(spacing: 12) {
                    // Keep Button
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            manager.seaCreatureWarningType = nil
                        }
                    }) {
                        Text("Keep")
                            .font(.custom("Baloo 2", size: 14))
                            .fontWeight(.bold)
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.gray.opacity(0.15))
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
                                .font(.system(size: 16, weight: .bold))
                            Text("Put Back on Sand 🌊")
                                .font(.custom("Baloo 2", size: 14))
                                .fontWeight(.bold)
                        }
                        .foregroundColor(.white)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 10)
                        .background(
                            Capsule().fill(buttonGreen)
                        )
                        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 22)
            .padding(.top, 28)
            .padding(.bottom, 18)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.25), radius: 12, x: 0, y: 6)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(cardEdge, lineWidth: 4)
            )

            // Tori Speaker Pill Badge
            HStack(spacing: 6) {
                Text("🐢")
                    .font(.system(size: 14))
                Text("Tori")
                    .font(.custom("Baloo 2", size: 15))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .background(
                Capsule().fill(toriTagColor)
            )
            .overlay(
                Capsule().strokeBorder(Color.white, lineWidth: 2.5)
            )
            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
            .offset(y: -15)
        }
        .frame(maxWidth: 440)
        .padding(.horizontal, 20)
    }

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
