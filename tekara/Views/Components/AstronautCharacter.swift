//
//  AstronautCharacter.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct AstronautCharacter: View {
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Circle()
                    .fill(Color(hex: "1E3A5F"))
                    .frame(width: 50, height: 50)
                    .overlay(Circle().stroke(Color.white, lineWidth: 3))
                    .overlay(
                        Circle()
                            .fill(Color(hex: "87CEEB").opacity(0.8))
                            .frame(width: 36, height: 36)
                    )

                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(hex: "2E5A8F"))
                    .frame(width: 40, height: 50)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.white, lineWidth: 2))

                HStack(spacing: 4) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 12, height: 30)
                    Spacer()
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 12, height: 30)
                }
                .frame(width: 50)

                HStack(spacing: 6) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 14, height: 25)
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color(hex: "2E5A8F"))
                        .frame(width: 14, height: 25)
                }
            }

            Image(systemName: "star.fill")
                .font(.system(size: 20))
                .foregroundColor(Color(hex: "FFD700"))
                .shadow(color: .yellow.opacity(0.8), radius: 8)
                .offset(x: 30, y: -20)
        }
    }
}
