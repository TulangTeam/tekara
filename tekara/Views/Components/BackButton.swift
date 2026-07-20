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
        Button(action: {
            audioManager?.playSFX(named: "bubblesound.mp3")
            action()
        }) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 54, height: 54)
                .background(Color(red: 0.27, green: 0.17, blue: 0.13))
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white, lineWidth: 4)
                )
                .shadow(color: .black.opacity(0.25), radius: 6, x: 0, y: 4)
        }
    }
}

#Preview {
    ZStack {
        Color.gray.opacity(0.2)
            .ignoresSafeArea()
        
        BackButton(action: {
            #if DEBUG
            print("Back button tapped!")
            #endif
        })
    }
}
