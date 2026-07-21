//
//  MissionCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct MissionCard: View {
    @Bindable var manager: TrashInteractionManager

    var body: some View {
        VStack(spacing: 10) {
            Text("Missions")
                .font(.custom("Baloo 2", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(PopupStyle.themeBlue)
                )
                .offset(y: -8)

            VStack(alignment: .leading, spacing: 10) {
                MissionRow(
                    iconName: "trash.fill",
                    iconColor: PopupStyle.themeBlue,
                    text:
                        "Collect \(manager.totalTrashCount) trash\n\(manager.collectedTrashCount)/\(manager.totalTrashCount)",
                    isCompleted: manager.isMissionComplete
                )

                MissionRow(
                    iconName: "hand.raised.fill",
                    iconColor: Color(hex: "F59E0B"),
                    text: "Use hand gloves\nto pick up trash",
                    isCompleted: manager.selectedTool == .gloves
                )

                MissionRow(
                    iconName: "arrow.down.to.line.compact",
                    iconColor: PopupStyle.themeGreen,
                    text: "Dispose trash\nin the bin",
                    isCompleted: manager.collectedTrashCount > 0
                )
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 14)
        }
        .frame(width: 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(PopupStyle.cardBackground)
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

// MARK: - Mission Row

private struct MissionRow: View {
    let iconName: String
    let iconColor: Color
    let text: String
    let isCompleted: Bool

    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: isCompleted ? "checkmark.circle.fill" : iconName)
                .font(.system(size: 22))
                .foregroundStyle(
                    isCompleted
                        ? Color(red: 0.18, green: 0.73, blue: 0.16) : iconColor
                )
                .frame(width: 32, height: 32)

            Text(text)
                .font(.custom("Baloo 2", size: 13))
                .fontWeight(.semibold)
                .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
