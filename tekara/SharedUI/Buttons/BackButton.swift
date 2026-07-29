//
//  BackButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    var audioManager: AudioManager?

    var body: some View {
        IconCircleButton(
            iconName: "chevron.left",
            iconOffset: CGSize(width: -1, height: 0),
            audioManager: audioManager
        ) {
            action()
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()

        BackButton(action: {
            print("Back button tapped!")
        })
    }
}
