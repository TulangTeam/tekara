//
//  ExitConfirmationPopup.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 20/07/26.
//

import SwiftUI

struct ExitConfirmationPopup: View {
    let onStay: () -> Void
    let onLeave: () -> Void

    var body: some View {
        PopupCard(title: "Leave Game?", headerColor: PopupStyle.themeRed) {
            Text(
                "Are you sure you want to leave?\nYour mission progress will be lost!"
            )
            .font(.custom("Baloo 2", size: 20))
            .fontWeight(.bold)
            .foregroundColor(PopupStyle.textColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 24)

            HStack(spacing: 16) {
                PopupButton(
                    title: "Keep Playing",
                    action: onStay
                )

                PopupButton(
                    title: "Leave",
                    color: PopupStyle.themeRed,
                    action: onLeave
                )
            }
        }
    }
}

#Preview {
    ExitConfirmationPopup(onStay: {}, onLeave: {})
}
