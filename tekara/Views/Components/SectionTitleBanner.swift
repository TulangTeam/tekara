//
//  SectionTitleBanner.swift
//  tekara
//

import SwiftUI

struct SectionTitleBanner: View {
    var title: String
    var subtitle: String? = nil
    var leadingDecoration: String? = nil
    var trailingDecoration: String? = nil

    private let faceColor = Color(red: 0.98, green: 0.65, blue: 0.15)
    private let edgeColor = Color(red: 0.75, green: 0.42, blue: 0.02)
    private let subtitleFace = Color(red: 0.20, green: 0.44, blue: 0.76)
    private let subtitleEdge = Color(red: 0.10, green: 0.28, blue: 0.55)

    private let pressDepth: CGFloat = 6
    private let subtitlePressDepth: CGFloat = 3

    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .bottom) {
                Capsule().fill(edgeColor)

                Capsule()
                    .fill(faceColor)
                    .overlay(Capsule().stroke(Color.white, lineWidth: 4))
                    .overlay(
                        Text(title.uppercased())
                            .font(.custom("Baloo 2", size: 22).bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    )
                    .padding(.bottom, pressDepth)
                    .offset(y: -pressDepth)
            }
            .frame(height: 58 + pressDepth)
            .zIndex(0)

            if let subtitle {
                ZStack(alignment: .bottom) {
                    Capsule().fill(subtitleEdge)

                    Capsule()
                        .fill(subtitleFace)
                        .overlay(Capsule().stroke(Color.white, lineWidth: 3))
                        .overlay(
                            Text(subtitle.uppercased())
                                .font(.custom("Baloo 2", size: 13).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 18)
                        )
                        .padding(.bottom, subtitlePressDepth)
                        .offset(y: -subtitlePressDepth)
                }
                .frame(height: 30 + subtitlePressDepth)
                .offset(y: -14)
                .zIndex(1)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .overlay(alignment: .topLeading) {
            if let leadingDecoration {
                Image(leadingDecoration)
                    .offset(x: -18, y: -22)
            }
        }
        .overlay(alignment: .topTrailing) {
            if let trailingDecoration {
                Image(trailingDecoration)
                    .offset(x: 18, y: -6)
            }
        }
    }
}

#Preview {
    ZStack {
        Color(red: 0.85, green: 0.93, blue: 0.97).ignoresSafeArea()

        VStack(spacing: 60) {
            SectionTitleBanner(
                title: "Ocean map",
                leadingDecoration: "coral_red",
                trailingDecoration: "coral_purple"
            )
            .frame(width: 340)

            SectionTitleBanner(
                title: "Seashore & coral reef",
                subtitle: "Episode 1–6",
                leadingDecoration: "coral_red",
                trailingDecoration: "coral_cluster"
            )
            .frame(width: 400)
        }
    }
}
