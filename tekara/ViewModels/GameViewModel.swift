//
//  GameViewModel.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI
import Combine

@MainActor
final class GameViewModel: ObservableObject {
    @Published var gameState: GameState

    init(gameState: GameState = GameState()) {
        self.gameState = gameState
    }

    func toggleSound() {
        gameState.isSoundEnabled.toggle()
    }

    func navigateTo(_ screen: AppScreen) {
        gameState.currentScreen = screen
    }

    func navigateToStory(episodeId: Int) {
        gameState.currentScreen = .story(episodeId: episodeId)
    }

    func getStoryContent(for episodeId: Int) -> StoryContent {
        return StoryData.getContent(for: episodeId)
    }

    func navigateToNextScreen() {
        switch gameState.currentScreen {
        case .story(let episodeId):
            if episodeId < 6 {
                navigateToStory(episodeId: episodeId + 1)
            } else {
                navigateTo(.episodes)
            }
        default:
            break
        }
    }
}
