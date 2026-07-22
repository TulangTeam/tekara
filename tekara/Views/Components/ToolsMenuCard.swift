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
    private let themeBlue = PopupStyle.themeBlue

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                Text("Tools")
                    .font(.custom("Baloo 2", size: 18))
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 6)
                    .background(
                        Capsule().fill(themeBlue)
                    )
                    .offset(y: -8)

                VStack(spacing: 8) {
                    ForEach(CleanupTool.allCases) { tool in
                        ToolGridItem(
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
                .padding(.horizontal, 10)
                .padding(.bottom, 12)
            }
            .frame(width: 195)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(cardBackground)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(PopupStyle.borderColor, lineWidth: 1.5)
            )

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
}

private struct ToolGridItem: View {
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
                            .frame(width: 40, height: 40)

                        Image(systemName: tool.iconName)
                            .font(.system(size: 20))
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
