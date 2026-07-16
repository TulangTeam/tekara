//
//  ChapterView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterView: View {
    @ObservedObject var viewModel: GameViewModel
    @State private var bubbleOffset: CGFloat = 200

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)
                MapSelect(onMapSelected: {
                    viewModel.navigateTo(.episodes)
                })
                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.welcome)
                        })
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    Spacer()
                }
                VStack {

                    NavTitle()
                        .scaleEffect(1.4)
                        .offset(y: -110)
                    Spacer()
                }

                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image("chapterbubble")
                            .padding(.bottom, 20)
                            .offset(y: bubbleOffset)
                        Spacer()
                    }
                }

            }
        }
        .ignoresSafeArea()
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.6, blendDuration: 0)) {
                bubbleOffset = 0
            }
        }
    }
}

#Preview {
    ChapterView(viewModel: GameViewModel())
}
