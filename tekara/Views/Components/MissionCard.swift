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
        VStack(spacing: 8) {
            Text("Missions")
                .font(.custom("Baloo 2", size: 18))
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.horizontal, 28)
                .padding(.vertical, 6)
                .background(
                    Capsule().fill(themeBlue)
                )
                .offset(y: -8)
            
            VStack(alignment: .leading, spacing: 8) {
                // 1. Collect Trash
                MissionRow(
                    iconName: "trash.fill",
                    iconColor: PopupStyle.themeBlue,
                    text: "Collect \(manager.totalTrashCount) trash\n\(manager.collectedTrashCount)/\(manager.totalTrashCount)",
                    status: manager.isMissionComplete ? .completed : .inProgress
                )
                
                // 2. Use Gloves
                MissionRow(
                    iconName: "hand.raised.fill",
                    iconColor: Color(hex: "F59E0B"),
                    text: "Use hand gloves\nto pick up trash",
                    status: manager.selectedTool == .gloves ? .completed : .inProgress
                )
                
                // 3. Dispose to Bin
                MissionRow(
                    iconName: "arrow.down.to.line.compact",
                    iconColor: PopupStyle.themeGreen,
                    text: "Dispose trash\nin the bin",
                    status: manager.collectedTrashCount > 0 ? .completed : .inProgress
                )

                // 4. Avoid Sea Star (Optional)
                MissionRow(
                    iconName: "star.fill",
                    iconColor: Color(hex: "EC4899"),
                    text: "Avoid picking\nsea star (Optional)",
                    status: manager.pickedSeaStarCount == 0 ? .completed : .failed
                )

                // 5. Avoid Sea Shell (Optional)
                MissionRow(
                    iconName: "sparkles",
                    iconColor: Color(hex: "8B5CF6"),
                    text: "Avoid picking\nsea shell (Optional)",
                    status: manager.pickedShellCount == 0 ? .completed : .failed
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
                .strokeBorder(PopupStyle.borderColor, lineWidth: 1.5)
        )
    }
}

private struct MissionRow: View {
    let iconName: String
    let iconColor: Color
    let text: String
    let status: MissionRowStatus
    
    var body: some View {
        HStack(alignment: .top, spacing: 10) {
            Image(systemName: iconSystemName)
                .font(.system(size: 20))
                .foregroundStyle(iconColorStyle)
                .frame(width: 28, height: 28)
            
            Text(text)
                .font(.custom("Baloo 2", size: 12))
                .fontWeight(.semibold)
                .foregroundColor(PopupStyle.textColor)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    private var iconSystemName: String {
        switch status {
        case .completed: return "checkmark.circle.fill"
        case .failed: return "xmark.circle.fill"
        case .inProgress: return iconName
        }
    }
    
    private var iconColorStyle: Color {
        switch status {
        case .completed: return PopupStyle.themeGreen
        case .failed: return Color(hex: "EF4444")
        case .inProgress: return iconColor
        }
    }
}
