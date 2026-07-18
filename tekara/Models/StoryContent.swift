//
//  StoryContent.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 17/07/26.
//

import Foundation

struct DialogueItem {
    var speaker: String
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

struct StoryData {
    static func getContent(for episodeId: Int) -> StoryContent {
        switch episodeId {
        case 1:
            return StoryContent(
                episodeId: 1,
                episodeTitle: "SEASHORE & CORAL REEF",
                stages: [
                    StoryStage(
                        stageName: "Prologue",
                        backgroundImage: "bgocean",
                        dialogues: [
                            DialogueItem(speaker: "Narrator", text: "One sunny morning, Kai visits the beach with their class for a field trip. While everyone is excited to play, Kai notices something unusual. The beach is covered with plastic bottles, food wrappers, and fishing lines. The waves gently carry more trash toward the sea.")
                        ]
                    ),
                    StoryStage(
                        stageName: "Prologue",
                        backgroundImage: "bgocean2",
                        dialogues: [
                            DialogueItem(speaker: "Narrator", text: "Suddenly, a tiny sea turtle named Tori appears. Tori explains that the nearby coral reef is becoming polluted, and many sea creatures are losing their home.")
                        ]
                    ),
                    StoryStage(
                        stageName: "Story",
                        backgroundImage: "bgocean",
                        dialogues: [
                            DialogueItem(speaker: "Narrator", text: "Kai arrives at the beach, excited to play by the sea. But something feels... strange. Plastic bottles are floating near the shore. The sand is messy, and the water doesn't look as blue as it should. Just then, a tiny sea turtle waddles over.")
                        ]
                    ),
                    StoryStage(
                        stageName: "Story",
                        backgroundImage: "bgocean2",
                        dialogues: [
                            DialogueItem(speaker: "Tori", text: "Hi there! I'm Tori, a sea turtle. I'm so glad you're here! This beach used to be so clean and beautiful... Now, every day, more and more trash washes up on shore. My friends and I are losing our home because of all this pollution."),
                            DialogueItem(speaker: "Kai", text: "Don't worry, Tori! I'm here to help! Together, we'll clean up the beach and protect the ocean!"),
                            DialogueItem(speaker: "Tori", text: "Thank you, Ocean Hero! But be careful - there's so much trash everywhere! We'll need to work together to make a difference!")
                        ]
                    )
                ]
            )
        default:
            return StoryContent(
                episodeId: episodeId,
                episodeTitle: "Episode \(episodeId)",
                stages: []
            )
        }
    }
}
