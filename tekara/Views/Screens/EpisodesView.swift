//
//  EpisodesView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct EpisodesView: View {
    @ObservedObject var viewModel: GameViewModel

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("bgocean")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .blur(radius: 4)

                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.chapter)
                        })
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    Spacer()
                }

                Text("Episodes View")
                    .font(.largeTitle)
                    .foregroundColor(.white)
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    EpisodesView(viewModel: GameViewModel())
}
