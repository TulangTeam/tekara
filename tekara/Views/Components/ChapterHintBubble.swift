//
//  ChapterHintBubble.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 23/07/26.
//

import SwiftUI

struct ChapterHintBubble: View {
    var message: String
    var characterImage: String = "kaibubble"
    
    private let fillColor = Color(red: 0.09, green: 0.33, blue: 0.53).opacity(0.55)
    private let borderColor = Color.white.opacity(0.85)
    
    private let barHeight: CGFloat = 60
    private let characterHeight: CGFloat = 260
    private let maxBarWidth: CGFloat = 600
    
    var body: some View {
        ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: barHeight / 2)
                .fill(fillColor)
                .overlay(
                    RoundedRectangle(cornerRadius: barHeight / 2)
                        .stroke(borderColor, lineWidth: 2)
                )
                .frame(height: barHeight)
            
            Text(message)
                .font(.custom("Baloo 2", size: 20).bold())
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .lineLimit(2)
                .minimumScaleFactor(0.85)
                .frame(maxWidth: .infinity)
                .padding(.leading, 90)
                .padding(.trailing, 28)
            
            Image(characterImage)
                .resizable()
                .scaledToFit()
                .frame(height: characterHeight)
                .offset(x: -54, y: -8)
        }
        .frame(width: maxBarWidth, height: characterHeight)
    }
}

#Preview {
    ZStack {
        Color(red: 0.15, green: 0.55, blue: 0.8).ignoresSafeArea()
        ChapterHintBubble(message: "Finish all episodes to unlock the next map!")
    }
}
