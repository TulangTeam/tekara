//
//  StarRating.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct StarRating: View {
    let filled: Int
    let total: Int = 3

    private let starColor = Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
    private let emptyColor = Color(red: 0.72, green: 0.72, blue: 0.72)

    var body: some View {
        HStack(spacing: 4) {
            ForEach(1...total, id: \.self) { index in
                Image(systemName: index <= filled ? "star.fill" : "star")
                    .font(.system(size: 14))
                    .foregroundColor(index <= filled ? starColor : emptyColor)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(
            Capsule().fill(Color.black.opacity(0.05))
        )
    }
}

#Preview {
    HStack(spacing: 20) {
        StarRating(filled: 0)
        StarRating(filled: 1)
        StarRating(filled: 2)
        StarRating(filled: 3)
    }
    .padding()
}
