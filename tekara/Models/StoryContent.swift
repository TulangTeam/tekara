//
//  StoryContent.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 17/07/26.
//

import Foundation

struct DialogueItem {
    var speakerId: String   // CHANGED — was `speaker: String`, now a key into SpeakerRegistry
    var text: String
}

struct StoryStage {
    var stageName: String
    var backgroundImage: String
    var dialogues: [DialogueItem]
}

struct StoryContent {
    var episodeId: Int
    var episodeTitle: String
    var stages: [StoryStage]
}

// ponytail: add new episodes here
private let episode1Content = StoryContent(
    episodeId: 1,
    episodeTitle: "SEASHORE & CORAL REEF",
    stages: [
        StoryStage(
            stageName: "Prologue",
            backgroundImage: "prologue1",
            dialogues: [
                DialogueItem(
                    speakerId: "narrator",
                    text: "One sunny morning, Kai visits the beach, hoping to enjoy the fresh sea breeze and the sound of the waves. But something feels different. Plastic bottles, food wrappers, and old fishing lines are scattered across the sand. Every wave carries more trash toward the ocean. The sand is messy, and the water doesn't look as blue as it should."
                )
            ]
        ),
        StoryStage(
            stageName: "Prologue",
            backgroundImage: "prologue2",
            dialogues: [
                DialogueItem(
                    speakerId: "narrator",
                    text: "Suddenly, a tiny sea turtle named Tori appears. Tori explains that the nearby coral reef is becoming polluted, and many sea creatures are losing their home."
                )
            ]
        ),
        StoryStage(
            stageName: "Story",
            backgroundImage: "story1",
            dialogues: [
                DialogueItem(
                    speakerId: "tori",
                    text: "Hi! I'm Tori! \u{1F44B}. Our beach used to be clean and beautiful. But now, trash keeps washing into the ocean."
                )
            ]
        ),
        StoryStage(
            stageName: "Story",
            backgroundImage: "story2",
            dialogues: [
                DialogueItem(speakerId: "narrator", text: "A wave pushes trash toward the water."),
                DialogueItem(speakerId: "kai", text: "Oh no! It's floating away!"),
                DialogueItem(speakerId: "tori", text: "Let's pick it up before the waves carry it into the sea!"),
                DialogueItem(speakerId: "kai", text: "Let's do it together!")
            ]
        )
    ]
)

private let fallbackContent = StoryContent(
    episodeId: 0,
    episodeTitle: "Episode",
    stages: []
)

struct StoryData {
    private static let content: [Int: StoryContent] = [
        1: episode1Content
    ]

    static func getContent(for episodeId: Int) -> StoryContent {
        content[episodeId] ?? StoryContent(
            episodeId: episodeId,
            episodeTitle: "Episode \(episodeId)",
            stages: fallbackContent.stages
        )
    }
}
