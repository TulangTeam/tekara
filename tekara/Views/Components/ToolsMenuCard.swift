//
//  ToolsMenuCard.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct ToolsMenuCard: View {
    @Bindable var manager: TrashInteractionManager

    var body: some View {
        VStack(spacing: 12) {
            CardHeaderPill(text: "Tools")

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


