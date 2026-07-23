//
//  MissionCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//
import SwiftUI

struct MissionCard: View {
    @Bindable var manager: TrashInteractionManager

    private let cardBackground = PopupStyle.cardBackground
    private let cardEdge = PopupStyle.cardEdge   // CHANGED — reuses the kit's shared edge
                                                   // token instead of a one-off gradient
    private let pressDepth: CGFloat = 6           // NEW — static lip, matches episode/popup cards

    var body: some View {
        ZStack(alignment: .top) {
            // FIXED — base lip sized to cardFace via .background(), same
            // structural fix applied to every other card in the kit.
            cardFace
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(cardEdge)
                        .offset(y: pressDepth)
                )
                .padding(.bottom, pressDepth)

            CardHeaderPill(text: "Missions", backgroundColor: PopupStyle.themeBlue)
                .offset(y: -16)
        }
    }

    private var cardFace: some View {
        VStack(alignment: .leading, spacing: 12) {
            Spacer().frame(height: 6)   // clears the floating header pill

            MissionRow(
                iconName: "trash.fill",
                badgeColor: PopupStyle.themeBlue,
                title: "Collect 5 trash",
                progressText: "\(manager.collectedTrashCount)/\(manager.totalTrashCount)",
                isCompleted: manager.collectedTrashCount >= manager.totalTrashCount
            )
            MissionRow(
                iconName: "hand.raised.fill",
                badgeColor: Color(hex: "F59E0B"),
                title: "Equip gloves",
                progressText: nil,
                isCompleted: manager.selectedTool == .gloves
            )
            MissionRow(
                iconName: "trash.fill",
                badgeColor: PopupStyle.themeGreen,
                title: "Put trash in bin",
                progressText: nil,
                isCompleted: manager.collectedTrashCount > 0 && manager.selectedTool != .gloves
            )
            MissionRow(
                iconName: "exclamationmark.triangle.fill",
                badgeColor: Color(hex: "EC4899"),
                title: "Don't pick sea stars",
                progressText: nil,
                isCompleted: manager.pickedSeaStarCount == 0,
                alertIconName: "star.fill"
            )
            MissionRow(
                iconName: "exclamationmark.triangle.fill",
                badgeColor: Color(hex: "8B5CF6"),
                title: "Don't pick shells",
                progressText: nil,
                isCompleted: manager.pickedShellCount == 0,
                alertIconName: "sparkles"
            )
        }
        .padding(.horizontal, 14)
        .padding(.top, 16)
        .padding(.bottom, 14)
        .frame(width: 220)
        .background(
            RoundedRectangle(cornerRadius: 20).fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(cardEdge, lineWidth: 3)
        )
    }
}
