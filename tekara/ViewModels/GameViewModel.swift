//
//  GameViewModel.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    var gameState: GameState

    init(gameState: GameState = GameState()) {
        self.gameState = gameState
    }

    func navigateTo(_ screen: AppScreen) {
        gameState.currentScreen = screen
    }

    func navigateToStory(episodeId: Int) {
        gameState.currentScreen = .story(episodeId: episodeId)
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
