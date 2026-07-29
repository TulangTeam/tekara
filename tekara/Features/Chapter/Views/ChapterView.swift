//
//  ChapterView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterView: View {
    @Bindable var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    @State private var bannerScale: CGFloat = 0
    @State private var bubbleOffset: CGFloat = 200
    
    var body: some View {
        ZStack {
            Image("bgocean")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            //                .blur(radius: 4)
            
            MapSelect(onMapSelected: {
                viewModel.navigateTo(.episodes)
            }, audioManager: audioManager)
            .scaleEffect(0.87, anchor: UnitPoint.center)
            
            VStack(spacing: 0) {
                HStack {
                    BackButton(action: {
                        viewModel.navigateTo(.welcome)
                    }, audioManager: audioManager)
                    Spacer()
                }
                .padding(.leading, 20)
                .padding(.top, 50)
                
                SectionTitleBanner(
                    title: "OCEAN MAP",
                    leadingDecoration: "coral_red",
                    trailingDecoration: "coral_purple"
                )
                .offset(y: -40)
                .scaleEffect(bannerScale)
                .frame(width: 400)
                
                Spacer()
                
                ChapterHintBubble(message: "Finish all episodes to unlock the next map!")
                    .offset(y: bubbleOffset)
                    .scaleEffect(1.05)
                
            }
            .padding(.horizontal)
        }
        .ignoresSafeArea()
        .onAppear {
            audioManager.playBackgroundMusic(named: "beachtrack.mp3")
            withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
                bannerScale = 1
            }
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0).delay(0.2)) {
                bubbleOffset = 35
            }
        }
    }
}

#Preview {
    ChapterView(viewModel: GameViewModel())
}
