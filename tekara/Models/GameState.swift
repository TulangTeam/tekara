//
//  GameState.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import Foundation

enum AppScreen: Equatable {
    case welcome
    case chapterSelect
    case playing(chapterId: String)
    case settings
}

struct GameState {
    var currentScreen: AppScreen = .welcome
    var isSoundEnabled: Bool = true
    var unlockedChapters: Set<String> = ["seashore"]
}
