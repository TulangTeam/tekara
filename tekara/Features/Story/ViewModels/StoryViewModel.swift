//
//  StoryViewModel.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 23/07/26.
//

import Foundation

@Observable @MainActor
final class StoryViewModel {
    var dialogueIndex: Int = 0

    private let content: StoryContent

    init(content: StoryContent) {
        self.content = content
    }

    // MARK: - Computed Properties

    var totalDialogues: Int {
        content.stages.reduce(0) { $0 + $1.dialogues.count }
    }

    var safeStageIndex: Int {
        guard !content.stages.isEmpty else { return 0 }
        var count = 0
        for (index, stage) in content.stages.enumerated() {
            count += stage.dialogues.count
            if dialogueIndex < count {
                return index
            }
        }
        return content.stages.count - 1
    }

    var currentStage: StoryStage {
        guard !content.stages.isEmpty else {
            return StoryStage(stageName: "", backgroundImage: "", dialogues: [])
        }
        return content.stages[safeStageIndex]
    }

    var currentDialogueItem: DialogueItem {
        let total = totalDialogues
        guard total > 0 else { return DialogueItem(speakerId: "", text: "") }

        let safeIndex = max(0, min(dialogueIndex, total - 1))

        var remaining = safeIndex
        for stage in content.stages {
            if remaining < stage.dialogues.count {
                guard !stage.dialogues.isEmpty else {
                    return DialogueItem(speakerId: "", text: "")
                }
                return stage.dialogues[remaining]
            }
            remaining -= stage.dialogues.count
        }
        return DialogueItem(speakerId: "", text: "")
    }

    var currentStageName: String {
        currentStage.stageName
    }

    var currentBackgroundImage: String {
        currentStage.backgroundImage
    }

    var isFirstDialogue: Bool {
        dialogueIndex == 0
    }

    var isLastDialogue: Bool {
        let total = totalDialogues
        guard total > 0 else { return false }
        return dialogueIndex == total - 1
    }

    var isLastInStage: Bool {
        guard !content.stages.isEmpty else { return false }
        let stage = content.stages[safeStageIndex]
        return dialogueIndex == stage.dialogues.count - 1 && safeStageIndex == content.stages.count - 1
    }

    var buttonText: String {
        if isLastDialogue {
            return "Start Game"
        } else if isLastInStage {
            return "Next Stage"
        } else {
            return "Next"
        }
    }

    // MARK: - Actions

    func handleButtonTap(navigateTo: (AppScreen) -> Void) {
        if isLastDialogue {
            navigateTo(.gameplay(episodeId: content.episodeId))
        } else {
            nextDialogue()
        }
    }

    func nextDialogue() {
        guard dialogueIndex < totalDialogues - 1 else { return }
        dialogueIndex += 1
    }

    func previousDialogue() {
        guard dialogueIndex > 0 else { return }
        dialogueIndex -= 1
    }
}
