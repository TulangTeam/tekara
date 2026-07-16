//
//  ContentView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = GameViewModel()

    var body: some View {
        ZStack {
            switch viewModel.gameState.currentScreen {
            case .welcome:
                WelcomeView(viewModel: viewModel)

            case .chapterSelect:
                ChapterSelectView(viewModel: viewModel)

            case .playing(let chapterId):
                PlayingView(viewModel: viewModel, chapterId: chapterId)

            case .settings:
                SettingsView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ContentView()
}
