//
//  ToolInfoPopup.swift
//  tekara
//
//  Created by Tekara Team on 21/07/26.
//

import SwiftUI

/// Pop-up modal explaining a tool's description and usage in Tekara.
struct ToolInfoPopup: View {
    let tool: CleanupTool
    let onClose: () -> Void

    var body: some View {
        PopupCard(title: tool.rawValue, headerColor: tool.color) {
            VStack(spacing: 16) {
                // Tool Icon
                ZStack {
                    Circle()
                        .fill(tool.color.opacity(0.15))
                        .frame(width: 80, height: 80)

                    Image(systemName: tool.iconName)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundStyle(tool.color)
                }
                .padding(.top, 4)

                // Tool Description Text
                Text(tool.toolDescription)
                    .font(.custom("Baloo 2", size: 18))
                    .fontWeight(.semibold)
                    .foregroundColor(PopupStyle.textColor)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .fixedSize(horizontal: false, vertical: true)

                // Close Action Button
                PopupButton(title: "Got it!", color: PopupStyle.themeBlue, action: onClose)
                    .padding(.top, 8)
            }
        }
    }
}

#Preview {
    ToolInfoPopup(tool: .gloves, onClose: {})
}
