//
//  MissionRow.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct MissionRow: View {
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

#Preview {
    VStack(spacing: 12) {
        MissionRow(
            iconName: "trash.fill",
            iconColor: PopupStyle.themeBlue,
            text: "Collect 10 trash\n3/10",
            isCompleted: false
        )
        MissionRow(
            iconName: "checkmark.circle.fill",
            iconColor: PopupStyle.themeGreen,
            text: "Dispose trash\nin the bin",
            isCompleted: true
        )
    }
    .padding()
    .background(PopupStyle.cardBackground)
}
