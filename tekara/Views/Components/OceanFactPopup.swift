//
//  OceanFactPopup.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

struct OceanFactPopup: View {
    var onBack: (() -> Void)? = nil
    let onNext: () -> Void

    var body: some View {
        PopupCard(title: "Ocean Fact") {
            VStack(spacing: 20) {
                Text(
                    "Trash left on the beach can be carried\ninto the ocean by the waves."
                )
                .font(.custom("Baloo 2", size: 17))
                .fontWeight(.semibold)
                .foregroundColor(PopupStyle.textColor)
                .multilineTextAlignment(.center)

                Text(
                    "Shells and sea stars are part of nature\nand should stay where they belong."
                )
                .font(.custom("Baloo 2", size: 17))
                .fontWeight(.semibold)
                .foregroundColor(PopupStyle.textColor)
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)

            HStack(spacing: 16) {
                if let onBack {
                    PopupButton(title: "Back", color: Color.gray, action: onBack)
                }

                PopupButton(title: "Next", action: onNext)
            }
        }
    }
}

#Preview {
    OceanFactPopup(onNext: {})
}
