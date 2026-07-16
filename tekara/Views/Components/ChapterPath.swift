//
//  ChapterPath.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterPath: View {
    let geometry: GeometryProxy

    var body: some View {
        Path { path in
            let seashoreX = geometry.size.width * 0.22
            let seashoreY = geometry.size.height * 0.5
            let seagrassX = geometry.size.width * 0.52
            let seagrassY = geometry.size.height * 0.3

            path.move(to: CGPoint(x: seashoreX, y: seashoreY))
            path.addLine(to: CGPoint(x: seagrassX, y: seagrassY))

            let mangroveX = geometry.size.width * 0.7
            let mangroveY = geometry.size.height * 0.65

            path.move(to: CGPoint(x: seagrassX, y: seagrassY))
            path.addLine(to: CGPoint(x: mangroveX, y: mangroveY))

            let deepX = geometry.size.width * 0.88
            let deepY = geometry.size.height * 0.35

            path.move(to: CGPoint(x: seagrassX, y: seagrassY))
            path.addLine(to: CGPoint(x: deepX, y: deepY))
        }
        .stroke(style: StrokeStyle(lineWidth: 3, dash: [10, 8]))
        .foregroundColor(Color(hex: "FFD700").opacity(0.8))
    }
}
