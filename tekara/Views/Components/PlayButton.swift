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
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(hex: "8B6914"),
                                Color(hex: "A67C00"),
                                Color(hex: "8B6914")
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 180, height: 60)
                    .overlay(
                        VStack(spacing: 8) {
                            ForEach(0..<4, id: \.self) { _ in
                                Rectangle()
                                    .fill(Color.black.opacity(0.1))
                                    .frame(height: 1)
                            }
                        }
                        .padding(.horizontal, 20)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(hex: "5C4A1A"), lineWidth: 3)
                    )
                    .shadow(color: .black.opacity(0.4), radius: 8, x: 0, y: 4)

                Text("PLAY")
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
            }
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
