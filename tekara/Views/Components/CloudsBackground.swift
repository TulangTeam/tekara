//
//  CloudsBackground.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct CloudsBackground: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CloudShape()
                    .fill(Color.white.opacity(0.8))
                    .frame(width: 200, height: 80)
                    .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.08)

                CloudShape()
                    .fill(Color.white.opacity(0.7))
                    .frame(width: 150, height: 60)
                    .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.12)

                CloudShape()
                    .fill(Color.white.opacity(0.75))
                    .frame(width: 180, height: 70)
                    .position(x: geometry.size.width * 0.75, y: geometry.size.height * 0.06)

                CloudShape()
                    .fill(Color.white.opacity(0.65))
                    .frame(width: 120, height: 50)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.15)
            }
        }
    }
}

struct CloudShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height

        path.addEllipse(in: CGRect(x: 0, y: height * 0.4, width: width * 0.4, height: height * 0.6))
        path.addEllipse(in: CGRect(x: width * 0.2, y: height * 0.2, width: width * 0.5, height: height * 0.7))
        path.addEllipse(in: CGRect(x: width * 0.5, y: height * 0.35, width: width * 0.45, height: height * 0.55))
        path.addEllipse(in: CGRect(x: width * 0.7, y: height * 0.45, width: width * 0.3, height: height * 0.5))

        return path
    }
}
