//
//  CardHeaderPill.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct CardHeaderPill: View {
    var text: String
    var backgroundColor: Color = PopupStyle.themeBlue

    var body: some View {
        Text(text)
            .font(.custom("Baloo 2", size: 18))
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.horizontal, 28)
            .padding(.vertical, 6)
            .background(Capsule().fill(backgroundColor))
            .offset(y: -8)
    }
}

#Preview {
    VStack(spacing: 20) {
        CardHeaderPill(text: "Missions")
        CardHeaderPill(text: "Tools")
        CardHeaderPill(text: "Custom", backgroundColor: PopupStyle.themeGreen)
    }
    .padding()
    .background(PopupStyle.cardBackground)
}
