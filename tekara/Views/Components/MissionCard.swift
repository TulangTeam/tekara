//
//  MissionCard.swift
//  tekara
//
//  Created by Tekara Team on 19/07/26.
//

import SwiftUI

public enum MissionRowStatus {
    case inProgress
    case completed
    case failed
}

/// Card misi yang menampilkan progress pengumpulan sampah dan misi opsional di pulau
struct MissionCard: View {
    @Bindable var manager: TrashInteractionManager
    
    private let cardBackground = PopupStyle.cardBackground
    private let themeBlue = PopupStyle.themeBlue
    
    var body: some View {
        VStack(spacing: 10) {
            CardHeaderPill(text: "Missions")

            VStack(alignment: .leading, spacing: 10) {
                MissionRow(
                    iconName: "trash.fill",
                    iconColor: PopupStyle.themeBlue,
                    text: "Collect \(manager.totalTrashCount) trash\n\(manager.collectedTrashCount)/\(manager.totalTrashCount)",
                    isCompleted: manager.isMissionComplete
                )

                // 2. Use Gloves
                MissionRow(
                    iconName: "hand.raised.fill",
                    iconColor: Color(hex: "F59E0B"),
                    text: "Use hand gloves\nto pick up trash",
                    isCompleted: manager.selectedTool == .gloves
                )

                // 3. Dispose to Bin
                MissionRow(
                    iconName: "arrow.down.to.line.compact",
                    iconColor: PopupStyle.themeGreen,
                    text: "Dispose trash\nin the bin",
                    isCompleted: manager.collectedTrashCount > 0
                )

                // 4. Avoid Sea Star (Optional)
                MissionRow(
                    iconName: "star.fill",
                    iconColor: Color(hex: "EC4899"),
                    text: "Avoid picking\nsea star (Optional)",
                    isCompleted: manager.pickedSeaStarCount == 0
                )

                // 5. Avoid Sea Shell (Optional)
                MissionRow(
                    iconName: "sparkles",
                    iconColor: Color(hex: "8B5CF6"),
                    text: "Avoid picking\nsea shell (Optional)",
                    isCompleted: manager.pickedShellCount == 0
                )
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 12)
        }
        .frame(width: 210)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    PopupStyle.cardEdge,
                    lineWidth: 1.5
                )
        )
    }
}

