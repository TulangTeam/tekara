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

    var currentStageIndex: Int {
        safeStageIndex
    }

    var currentDialogueItem: DialogueItem {
        let total = totalDialogues
        guard total > 0 else { return DialogueItem(speakerId: "", text: "") }

        // Clamp into range so a stale or out-of-bounds index can't crash.
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
        // Unreachable given the clamp above, but kept as a defensive fallback.
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

    var buttonColor: Color {
        if isLastDialogue {
            return Color(red: 0.12, green: 0.69, blue: 0.18) // Green
        } else {
            return Color(red: 0.20, green: 0.44, blue: 0.76) // Blue
        }
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(currentBackgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(bgOpacity)

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
                    .padding(.bottom,44)
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
