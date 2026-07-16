//
//  ChapterView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ChapterView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)
                MapSelect()
                
                VStack() {
                    NavTitle()
                        .scaleEffect(1.4)
                        .offset(y: -110)
                    Spacer()
                }
                
                VStack() {
                    Spacer()
                    HStack{
                        Image("chapterbubble")
                            .padding(.leading, 30)
                            .padding(.bottom, 30)
                        Spacer()
                    }
                }
                
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    ChapterView(viewModel: GameViewModel())
}
