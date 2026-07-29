//
//  ContentView.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 17/07/26.
//

import SwiftUI

struct ContentView: View {
    @State private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            switch viewModel.gameState.currentScreen {
            case .welcome:
                WelcomeView(viewModel: viewModel)
            case .chapter:
                ChapterView(viewModel: viewModel)
            case .episodes:
                EpisodesView(viewModel: viewModel)
            case .story(let episodeId):
                StoryScreenView(
                    viewModel: viewModel,
                    content: StoryData.getContent(for: episodeId)
                )
            case .gameplay(let episodeId):
                GameplayView(episodeId: episodeId, viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
