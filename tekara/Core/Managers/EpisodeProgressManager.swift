//
//  EpisodeProgressManager.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import Foundation
import Observation

@Observable
@MainActor
final class EpisodeProgressManager {

    static let shared = EpisodeProgressManager()

    private let storageKey = "tekara_episode_progress"
    private(set) var completedEpisodes: [Int: EpisodeProgress] = [:]

    private init() {
        loadFromStorage()
    }

    func markCompleted(episodeId: Int) {
        let progress = EpisodeProgress(
            episodeId: episodeId,
            isCompleted: true,
            completedAt: Date()
        )
        completedEpisodes[episodeId] = progress
        saveToStorage()
    }

    func isCompleted(episodeId: Int) -> Bool {
        completedEpisodes[episodeId]?.isCompleted ?? false
    }

    func episodeStatus(for episodeId: Int) -> EpisodeStatus {
        if isCompleted(episodeId: episodeId) {
            return .completed
        }

        // Episode 1 is always available
        if episodeId == 1 {
            return .begin
        }

        // Subsequent episodes unlock when the previous episode is completed
        if isCompleted(episodeId: episodeId - 1) {
            return .begin
        }

        return .locked
    }

    func nextAvailableEpisode(totalEpisodes: Int = 6) -> Int? {
        for id in 1...totalEpisodes {
            if !isCompleted(episodeId: id) {
                return id
            }
        }
        return nil
    }

    func resetAllProgress() {
        completedEpisodes.removeAll()
        saveToStorage()
    }

    private func loadFromStorage() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
            let decoded = try? JSONDecoder().decode(
                [Int: EpisodeProgress].self,
                from: data
            )
        else { return }
        completedEpisodes = decoded
    }

    private func saveToStorage() {
        guard let data = try? JSONEncoder().encode(completedEpisodes)
        else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }
}

typealias ChapterProgressManager = EpisodeProgressManager
