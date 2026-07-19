//
//  ToolsMenuCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct ToolsMenuCard: View {
    @Bindable var manager: TrashInteractionManager

    private let cardBackground = Color(red: 0.92, green: 0.91, blue: 0.87)
    private let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.72)

    var body: some View {
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

            LazyVGrid(
                columns: [
                    GridItem(.flexible(), spacing: 8),
                    GridItem(.flexible(), spacing: 8),
                ],
                spacing: 10
            ) {
                ForEach(CleanupTool.allCases) { tool in
                    ToolGridItem(
                        tool: tool,
                        isSelected: manager.selectedTool == tool,
                        action: {
                            withAnimation(
                                .spring(response: 0.35, dampingFraction: 0.7)
                            ) {
                                if manager.selectedTool == tool {
                                    manager.selectedTool = nil
                                } else {
                                    manager.selectedTool = tool
                                }
                            }
                        }
                    )
                }
            }
            .padding(.horizontal, 12)
            .padding(.bottom, 14)
        }
        .frame(width: 170)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(cardBackground)
                .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(
                    Color(red: 0.85, green: 0.83, blue: 0.78),
                    lineWidth: 1.5
                )
        )
    }
}

private struct ToolGridItem: View {
    let tool: CleanupTool
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: tool.iconName)
                    .font(.system(size: 26))
                    .foregroundStyle(
                        isSelected
                            ? .white : Color(red: 0.35, green: 0.35, blue: 0.35)
                    )
                    .frame(width: 48, height: 48)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(
                                isSelected
                                    ? tool.color : Color.white.opacity(0.6)
                            )
                    )

                Text(tool.rawValue)
                    .font(.custom("Baloo 2", size: 11))
                    .fontWeight(.semibold)
                    .foregroundColor(Color(red: 0.30, green: 0.30, blue: 0.30))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
