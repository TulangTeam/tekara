//
//  StoryScreenView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 17/07/26.
//

import SwiftUI

struct StoryScreenView: View {
    @ObservedObject var viewModel: GameViewModel
    private let audioManager = AudioManager.shared
    var content: StoryContent

    @State private var dialogueIndex: Int = 0
    @State private var textOpacity: Double = 0
    @State private var contentScale: CGFloat = 0
    @State private var bgOpacity: Double = 0

    var currentStage: StoryStage {
        content.stages[currentStageIndex]
    }

    var isFirstDialogue: Bool {
        dialogueIndex == 0
    }

    var isLastDialogue: Bool {
        let totalDialogues = content.stages.reduce(0) { $0 + $1.dialogues.count }
        return dialogueIndex == totalDialogues - 1
    }

    var isLastInStage: Bool {
        let stage = content.stages[currentStageIndex]
        return dialogueIndex == stage.dialogues.count - 1 && currentStageIndex == content.stages.count - 1
    }

    var currentStageIndex: Int {
        var count = 0
        for (index, stage) in content.stages.enumerated() {
            count += stage.dialogues.count
            if dialogueIndex < count {
                return index
            }
        }
        return 0
    }

    var currentDialogueItem: DialogueItem {
        guard !content.stages.isEmpty,
              !content.stages[0].dialogues.isEmpty else {
            return DialogueItem(speaker: "", text: "")
        }

        var remaining = dialogueIndex
        for stage in content.stages {
            if remaining < stage.dialogues.count {
                return stage.dialogues[remaining]
            }
            remaining -= stage.dialogues.count
        }
        return content.stages[0].dialogues[0]
    }

    var currentStageName: String {
        content.stages[currentStageIndex].stageName
    }

    var currentBackgroundImage: String {
        content.stages[currentStageIndex].backgroundImage
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
                            })
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
                        dialogueText: currentDialogueItem.text,
                        buttonText: buttonText,
                        onButtonTapped: {
                            handleButtonTap()
                        },
                        onBackTapped: !isFirstDialogue ? {
                            previousDialogue()
                        } : nil
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
        let totalDialogues = content.stages.reduce(0) { $0 + $1.dialogues.count }
        guard dialogueIndex < totalDialogues - 1 else { return }

        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dialogueIndex += 1
            withAnimation(.easeIn(duration: 0.3)) {
                textOpacity = 1
            }
        }
    }

    private func previousDialogue() {
        guard dialogueIndex > 0 else { return }

        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            dialogueIndex -= 1
            withAnimation(.easeIn(duration: 0.3)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    StoryScreenView(viewModel: GameViewModel(), content: StoryData.getContent(for: 1))
}
