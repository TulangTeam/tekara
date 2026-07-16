//
//  PlayButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct PlayButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Image("labelgreen")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                Text("PLAY")
                    .font(.custom("SourGummy-Black", size: 28, relativeTo: .title))
                    .bold()
                    .foregroundColor(.white)
                    .padding(.bottom, 5)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

#Preview {
    ZStack {
        Color.blue
        PlayButton(action: {})
    }
}
