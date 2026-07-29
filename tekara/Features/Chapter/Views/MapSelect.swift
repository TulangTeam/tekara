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
                        .frame(width: 600)
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
                        .frame(width: 600)
                        .saturation(0)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(seagrassScale)
                .position(x: geometry.size.width * 0.36, y: geometry.size.height * 0.32)

                Button(action: {
                    audioManager?.playSFX(named: "bubblesound.mp3")
                    print("Mangrove map is locked!")
                }) {
                    Image("mangrove")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 700)
                        .saturation(0)
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
                        .frame(width: 800)
                        .saturation(0)
                }
                .buttonStyle(ScaleButtonStyle())
                .scaleEffect(deepoceanScale)
                .position(x: geometry.size.width * 0.80, y: geometry.size.height * 0.4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .onAppear {
            withAnimation(StaggeredAnimation.mapArrowSpring(delay: 0)) {
                arrow1Scale = 1
            }
            withAnimation(StaggeredAnimation.mapArrowSpring(delay: 1)) {
                arrow2Scale = 1
            }
            withAnimation(StaggeredAnimation.mapArrowSpring(delay: 2)) {
                arrow3Scale = 1
            }
            withAnimation(StaggeredAnimation.spring(delay: 0)) {
                seashoreScale = 1
            }
            withAnimation(StaggeredAnimation.spring(delay: 1)) {
                seagrassScale = 1
            }
            withAnimation(StaggeredAnimation.spring(delay: 2)) {
                mangroveScale = 1
            }
            withAnimation(StaggeredAnimation.spring(delay: 3)) {
                deepoceanScale = 1
            }
        }
    }
}

#Preview {
    MapSelect()
}
