//
//  ToolsMenuCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct ToolsMenuCard: View {
    @Bindable var manager: TrashInteractionManager
    @State private var selectedToolForInfo: CleanupTool? = nil

    private let cardBackground = PopupStyle.cardBackground
    private let cardEdge = PopupStyle.cardEdge
    private let pressDepth: CGFloat = 6

    var body: some View {
        ZStack(alignment: .top) {
            // 3D Base Lip & Face — hidden when info popup is showing
            if selectedToolForInfo == nil {
                cardFace
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(cardEdge)
                            .offset(y: pressDepth)
                    )
                    .padding(.bottom, pressDepth)

                // Header Pill matching MissionCard
                CardHeaderPill(text: "Tools", backgroundColor: PopupStyle.themeBlue)
                    .offset(y: -16)
            }

            // Tool Info Popup Modal
            if let infoTool = selectedToolForInfo {
                ToolInfoPopup(
                    tool: infoTool,
                    onClose: {
                        withAnimation(.easeOut(duration: 0.2)) {
                            selectedToolForInfo = nil
                        }
                    }
                )
                .transition(.opacity)
            }
        }
    }

    private var cardFace: some View {
        VStack(spacing: 8) {
            Spacer().frame(height: 6) // clears the floating header pill

            ForEach(CleanupTool.allCases) { tool in
                ToolMenuRow(
                    tool: tool,
                    isSelected: manager.selectedTool == tool,
                    onSelect: {
                        withAnimation(
                            .spring(response: 0.35, dampingFraction: 0.7)
                        ) {
                            if manager.selectedTool == tool {
                                manager.selectedTool = nil
                            } else {
                                manager.selectedTool = tool
                            }
                        }
                    },
                    onInfoTap: {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.75)) {
                            selectedToolForInfo = tool
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 12)
        .padding(.top, 16)
        .padding(.bottom, 14)
        .frame(width: 220) // Matched to MissionCard width
        .background(
            RoundedRectangle(cornerRadius: 20).fill(cardBackground)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20).stroke(cardEdge, lineWidth: 3)
        )
    }
}

private struct ToolMenuRow: View {
    let tool: CleanupTool
    let isSelected: Bool
    let onSelect: () -> Void
    let onInfoTap: () -> Void

    var body: some View {
        HStack(spacing: 8) {
            Button(action: onSelect) {
                HStack(spacing: 8) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isSelected
                                    ? tool.color : Color.white.opacity(0.7)
                            )
                            .frame(width: 36, height: 36)

                        Image(systemName: tool.iconName)
                            .font(.system(size: 18))
                            .foregroundStyle(
                                isSelected
                                    ? .white : Color(red: 0.35, green: 0.35, blue: 0.35)
                            )
                    }

                    Text(tool.rawValue)
                        .font(.custom("Baloo 2", size: 12))
                        .fontWeight(.semibold)
                        .foregroundColor(PopupStyle.textColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Spacer(minLength: 0)
                }
            }
            .buttonStyle(ScaleButtonStyle())

            Button(action: onInfoTap) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 18))
                    .foregroundStyle(PopupStyle.themeBlue)
                    .padding(2)
            }
            .buttonStyle(ScaleButtonStyle())
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(isSelected ? tool.color.opacity(0.18) : Color.white.opacity(0.5))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .strokeBorder(isSelected ? tool.color : Color.clear, lineWidth: 1.5)
        )
    }
}

#Preview {
    ZStack {
        Color.gray.ignoresSafeArea()
        ToolsMenuCard(manager: TrashInteractionManager())
    }
}
