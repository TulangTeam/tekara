//
//  OceanShineEffect.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct OceanShineEffect: View {
    @State private var animateShine = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<6, id: \.self) { index in
                    ShineSpot(
                        xOffset: CGFloat(index) * geometry.size.width / 5,
                        animate: animateShine
                    )
                }
            }
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 3).repeatForever(autoreverses: true)) {
                animateShine = true
            }
        }
    }
}

struct ShineSpot: View {
    let xOffset: CGFloat
    let animate: Bool

    var body: some View {
        Ellipse()
            .fill(
                RadialGradient(
                    colors: [Color.white.opacity(0.3), Color.clear],
                    center: .center,
                    startRadius: 0,
                    endRadius: 80
                )
            )
            .frame(width: 120, height: 60)
            .offset(x: xOffset, y: animate ? 0 : 20)
            .opacity(animate ? 0.6 : 0.2)
    }
}
