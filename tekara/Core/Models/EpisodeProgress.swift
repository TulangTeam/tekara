//
//  EpisodeProgress.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import Foundation

struct EpisodeProgress: Codable, Equatable {
    let episodeId: Int
    var isCompleted: Bool
    var completedAt: Date?
}

typealias ChapterProgress = EpisodeProgress
