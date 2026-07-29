//
//  CelebrationBurst.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import SwiftUI

private struct ConfettiPiece: Identifiable {
    let id = UUID()
    let angle: Double
    let distance: CGFloat
    let color: Color
    let shape: ShapeKind
    let rotation: Double

    enum ShapeKind { case star, circle, diamond }
}

/// Lightweight confetti burst for the mission-complete moment.
/// Uses flat shapes/icons (no gradients or glow) so it reads as
/// "confetti", not a special-effects layer that clashes with the
/// rest of the kit. Honors Reduce Motion by skipping animation.
struct CelebrationBurst: View {
    var trigger: Bool

    // Reuses existing kit tokens rather than inventing new confetti colors.
    private let palette: [Color] = [
        Color(red: 0.90, green: 0.82, blue: 0.15), // gold (attention)
        Color(red: 0.37, green: 0.82, blue: 0.41), // success green
        Color(red: 0.36, green: 0.75, blue: 0.67), // teal
        Color(red: 0.98, green: 0.65, blue: 0.15), // banner orange
        .white
    ]

    @State private var pieces: [ConfettiPiece] = []
    @State private var progress: CGFloat = 0

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ForEach(pieces) { piece in
                    pieceView(piece)
                        .position(
                            x: geo.size.width / 2 + cos(piece.angle) * piece.distance * progress,
                            y: geo.size.height / 2 + sin(piece.angle) * piece.distance * progress
                        )
                        .opacity(Double(1 - progress))
                        .rotationEffect(.degrees(piece.rotation * Double(progress)))
                }
            }
        }
        .allowsHitTesting(false)
        .onChange(of: trigger) { _, fired in
            if fired { burst() }
        }
    }

    private func burst() {
        if reduceMotion {
            pieces = []
            progress = 0
            return
        }
        pieces = (0..<26).map { _ in
            ConfettiPiece(
                angle: Double.random(in: 0..<(2 * .pi)),
                distance: CGFloat.random(in: 90...220),
                color: palette.randomElement()!,
                shape: [.star, .circle, .diamond].randomElement()!,
                rotation: Double.random(in: -180...180)
            )
        }
        progress = 0
        withAnimation(.easeOut(duration: 1.1)) { progress = 1 }
    }

    @ViewBuilder
    private func pieceView(_ piece: ConfettiPiece) -> some View {
        switch piece.shape {
        case .star:
            Image(systemName: "star.fill")
                .font(.system(size: 14))
                .foregroundColor(piece.color)
        case .circle:
            Circle().fill(piece.color).frame(width: 10, height: 10)
        case .diamond:
            Rectangle().fill(piece.color)
                .frame(width: 9, height: 9)
                .rotationEffect(.degrees(45))
        }
    }
}
