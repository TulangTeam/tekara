//
//  MissionRow.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct MissionRow: View {
    let iconName: String
    let badgeColor: Color
    let title: String
    var progressText: String? = nil
    let isCompleted: Bool
    var alertIconName: String? = nil   // shown (pulsing) when !isCompleted to warn the user

    private let successGreen = PopupStyle.themeGreen

    @State private var badgeScale: CGFloat = 1
    @State private var alertPulse: CGFloat = 1   // drives the alert bounce when mission is broken

    var body: some View {
        HStack(alignment: .center, spacing: 10) {
            // CHANGED — icon now sits inside a filled circular badge instead
            // of floating bare. Reads as a collectible sticker, not a list glyph.
            ZStack {
                Circle()
                    .fill(isCompleted ? successGreen : badgeColor)
                    .frame(width: 34, height: 34)

                Image(systemName: isCompleted ? "checkmark" : iconName)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.white)
            }
            .scaleEffect(alertIconName != nil && !isCompleted ? alertPulse : badgeScale)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.custom("Baloo 2", size: 13).bold())
                    .foregroundColor(
                        isCompleted
                            ? Color(red: 0.30, green: 0.30, blue: 0.30).opacity(0.55)
                            : Color(red: 0.30, green: 0.30, blue: 0.30)
                    )
                    // CHANGED — completed rows dim slightly and gain a
                    // strikethrough, so "done" reads at a glance without
                    // needing to compare icon colors row to row.
                    .strikethrough(isCompleted, color: Color(red: 0.30, green: 0.30, blue: 0.30).opacity(0.4))

                if let progressText {
                    Text(progressText)
                        .font(.custom("Baloo 2", size: 11).bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(
                            Capsule().fill(isCompleted ? successGreen.opacity(0.6) : badgeColor.opacity(0.75))
                        )
                }
            }

            Spacer(minLength: 0)
        }
        .onChange(of: isCompleted) { wasCompleted, nowCompleted in
            if alertIconName != nil {
                // Alert bounce when user breaks an avoid-mission (picks sea star/shell)
                if wasCompleted && !nowCompleted {
                    AudioManager.shared.playSFX(named: "starpop.mp3")
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.4).repeatCount(3)) {
                        alertPulse = 1.3
                    }
                    withAnimation(.spring(response: 0.25, dampingFraction: 0.6).delay(0.75)) {
                        alertPulse = 1
                    }
                }
                return
            }
            // Normal completion bounce
            guard !wasCompleted, nowCompleted else { return }
            AudioManager.shared.playSFX(named: "starpop.mp3")
            withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
                badgeScale = 1.35
            }
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6).delay(0.12)) {
                badgeScale = 1
            }
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        MissionRow(
            iconName: "trash.fill",
            badgeColor: PopupStyle.themeBlue,
            title: "Clean up beach",
            progressText: "3/10",
            isCompleted: false
        )
        MissionRow(
            iconName: "trash.fill",
            badgeColor: PopupStyle.themeGreen,
            title: "Dispose trash in the bin",
            progressText: nil,
            isCompleted: true
        )
    }
    .padding()
    .background(PopupStyle.cardBackground)
}
