//
//  StoryScreenView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 17/07/26.
//

import SwiftUI

struct StoryScreenView: View {
    @Bindable var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    var content: StoryContent

    @State private var dialogueIndex: Int = 0
    @State private var textOpacity: Double = 0
    @State private var contentScale: CGFloat = 0
    @State private var bgOpacity: Double = 0
    @State private var isTransitioning: Bool = false

    private var totalDialogues: Int {
        content.stages.reduce(0) { $0 + $1.dialogues.count }
    }

    private var safeStageIndex: Int {
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

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background Artwork
                Image(currentBackgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(bgOpacity)

                // Top Back Button Layer
                VStack {
                    HStack {
                        if isFirstDialogue {
                            BackButton(action: {
                                viewModel.navigateTo(.episodes)
                            }, audioManager: audioManager)
                        }
                        Spacer()
                    }
                    .padding(.leading, 20)
                    .padding(.top, 50)
                    Spacer()
                }

                // Bottom Genshin Dialogue Overlay Layer
                VStack {
                    Spacer()

                    DialogueCard(
                        title: currentStageName,
                        speaker: SpeakerRegistry.speaker(for: currentDialogueItem.speakerId),
                        dialogueText: currentDialogueItem.text,
                        buttonText: buttonText,
                        onButtonTapped: {
                            handleButtonTap()
                        },
                        onBackTapped: !isFirstDialogue ? {
                            previousDialogue()
                        } : nil,
                        onCardTapped: {
                            handleButtonTap()
                        },
                        audioManager: audioManager
                    )
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            audioManager.playBackgroundMusic(named: "beachtrack.mp3")
            animateIn()
        }
    }

    private func handleButtonTap() {
        if isLastDialogue {
            viewModel.navigateTo(.gameplay(episodeId: content.episodeId))
        } else {
            nextDialogue()
        }
    }

    private func animateIn() {
        contentScale = 0
        textOpacity = 0
        bgOpacity = 1

        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
            contentScale = 1
        }
    }

    private func nextDialogue() {
        guard !isTransitioning else { return }
        guard dialogueIndex < totalDialogues - 1 else { return }

        isTransitioning = true
        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dialogueIndex += 1
            withAnimation(.easeIn(duration: 0.3)) {
                textOpacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isTransitioning = false
            }
        }
    }

    private func previousDialogue() {
        guard !isTransitioning else { return }
        guard dialogueIndex > 0 else { return }

        isTransitioning = true
        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dialogueIndex -= 1
            withAnimation(.easeIn(duration: 0.3)) {
                textOpacity = 1
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                isTransitioning = false
            }
        }
    }
}

#Preview {
    StoryScreenView(viewModel: GameViewModel(), content: StoryData.getContent(for: 1))
}
