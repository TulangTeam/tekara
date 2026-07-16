//
//  ChapterIsland.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterIsland: View {
    let name: String
    let imageName: String
    let isLocked: Bool
    let size: CGSize
    let action: () -> Void

    var islandHeight: CGFloat {
        size.height * 0.42
    }

    var body: some View {
        Button(action: action) {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: islandHeight)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    .overlay(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(isLocked ? Color.black.opacity(0.5) : Color.black.opacity(0.2))
                    )

                if isLocked {
                    VStack(spacing: 6) {
                        Image(systemName: "lock.fill")
                            .font(.system(size: 28))
                            .foregroundColor(.white)
                    }
                    .padding(12)
                    .background(Circle().fill(Color.black.opacity(0.4)))
                }

                VStack {
                    Spacer()
                    Text(name)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .shadow(color: .black.opacity(0.7), radius: 2, x: 0, y: 1)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 6)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.black.opacity(0.5)))
                }
                .padding(8)
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(isLocked)
    }
}
