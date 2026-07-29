//
//  ToolGridItem.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct ToolGridItem: View {
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

#Preview {
    HStack(spacing: 12) {
        ToolGridItem(tool: .gloves, isSelected: false, action: {})
        ToolGridItem(tool: .netScissor, isSelected: true, action: {})
        ToolGridItem(tool: .coralCleaner, isSelected: false, action: {})
    }
    .padding()
    .background(PopupStyle.cardBackground)
}
