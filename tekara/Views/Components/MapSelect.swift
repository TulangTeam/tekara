//
//  MapSelect.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct MapSelect: View {
    var onMapSelected: (() -> Void)? = nil
    var audioManager: AudioManager?

    @State private var arrow1Scale: CGFloat = 0
    @State private var arrow2Scale: CGFloat = 0
    @State private var arrow3Scale: CGFloat = 0
    @State private var seashoreScale: CGFloat = 0
    @State private var seagrassScale: CGFloat = 0
    @State private var mangroveScale: CGFloat = 0
    @State private var deepoceanScale: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("arrow1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.45)
                    .scaleEffect(arrow1Scale)

                Image("arrow2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210)
                    .position(x: geometry.size.width * 0.52, y: geometry.size.height * 0.5)
                    .scaleEffect(arrow2Scale)

                Image("arrow3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .position(x: geometry.size.width * 0.80, y: geometry.size.height * 0.65)
                    .scaleEffect(arrow3Scale)

                Button(action: {
                    audioManager?.playSFX(named: "bubblesound.mp3")
                    print("Seashore map selected!")
                    onMapSelected?()
                }) {
                    Image("seashore")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(seashoreScale)
                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.6)

                Button(action: {
                    audioManager?.playSFX(named: "bubblesound.mp3")
                    print("Seagrass map is locked!")
                }) {
                    Image("seagrass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(seagrassScale)
                .position(x: geometry.size.width * 0.4, y: geometry.size.height * 0.33)

                Button(action: {
                    audioManager?.playSFX(named: "bubblesound.mp3")
                    print("Mangrove map is locked!")
                }) {
                    Image("mangrove")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 330)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(mangroveScale)
                .position(x: geometry.size.width * 0.63, y: geometry.size.height * 0.7)

                Button(action: {
                    audioManager?.playSFX(named: "bubblesound.mp3")
                    print("Deep Ocean map is locked!")
                }) {
                    Image("deepocean")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(deepoceanScale)
                .position(x: geometry.size.width * 0.80, y: geometry.size.height * 0.4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                arrow1Scale = 1
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1)) {
                arrow2Scale = 1
            }
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.15)) {
                arrow3Scale = 1
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                seashoreScale = 1
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.3)) {
                seagrassScale = 1
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.4)) {
                mangroveScale = 1
            }
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.5)) {
                deepoceanScale = 1
            }
        }
    }
}

#Preview {
    MapSelect()
}
