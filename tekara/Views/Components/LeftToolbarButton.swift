//
//  LeftToolbarButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct LeftToolbarButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        IconCircleButton(
            iconName: iconName,
            audioManager: nil
        ) {
            action()
        }
    }
}

#Preview {
    ZStack {
        Color.blue
        LeftToolbarButton(iconName: "gearshape.fill", action: {})
    }
}
