//
//  ChapterView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var showEpisodes = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)
                MapSelect(onMapSelected: {
                    showEpisodes = true
                })

                VStack() {
                    NavTitle()
                        .scaleEffect(1.4)
                        .offset(y: -110)
                    Spacer()
                }

                VStack() {
                    Spacer()
                    HStack{
                        Spacer()
                        Image("chapterbubble")
                            .padding(.bottom, 20)
                        Spacer()
                    }
                }

            }
        }
        .ignoresSafeArea()
        .fullScreenCover(isPresented: $showEpisodes) {
            EpisodesView()
        }
    }
}

#Preview {
    ChapterView(viewModel: GameViewModel())
}
