//
//  MissionCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

public enum MissionRowStatus {
    case inProgress
    case completed
    case failed
}

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
                    text: "Clean Up Beach\n\(manager.collectedTrashCount)/\(manager.totalTrashCount) collected",
                    isCompleted: manager.isMissionComplete
                )

                // 2. Use Gloves
                MissionRow(
                    iconName: "hand.raised.fill",
                    iconColor: Color(hex: "F59E0B"),
                    text: "Equip Hand Gloves\nfrom the Hut",
                    isCompleted: manager.selectedTool == .gloves
                )

                // 3. Dispose to Bin
                MissionRow(
                    iconName: "trash.fill",
                    iconColor: PopupStyle.themeGreen,
                    text: "Dispose Trash\ninto the Bin",
                    isCompleted: manager.collectedTrashCount > 0
                )

                // 4. Avoid Sea Star (Optional)
                MissionRow(
                    iconName: "star.fill",
                    iconColor: Color(hex: "EC4899"),
                    text: "Protect Sea Stars\n(Optional)",
                    isCompleted: manager.pickedSeaStarCount == 0
                )

                // 5. Avoid Sea Shell (Optional)
                MissionRow(
                    iconName: "sparkles",
                    iconColor: Color(hex: "8B5CF6"),
                    text: "Preserve Shells\n(Optional)",
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
                .shadow(color: .black.opacity(0.18), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            PopupStyle.themeBlue.opacity(0.6),
                            PopupStyle.cardEdge
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 2
                )
        )
    }
}

