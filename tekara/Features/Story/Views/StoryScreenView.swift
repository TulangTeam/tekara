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

    @State private var storyViewModel: StoryViewModel

    init(viewModel: GameViewModel, content: StoryContent) {
        self.viewModel = viewModel
        self.content = content
        self._storyViewModel = State(wrappedValue: StoryViewModel(content: content))
    }

    var body: some View {
        ZStack {
            // Layer 1: Background
            Image(storyViewModel.currentBackgroundImage)
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            // Layer 2: Dialogue card
            VStack(spacing: 0) {
                Spacer()
                DialogueCard(
                    title: storyViewModel.currentStageName,
                    speaker: SpeakerRegistry.speaker(for: storyViewModel.currentDialogueItem.speakerId),
                    dialogueText: storyViewModel.currentDialogueItem.text,
                    dialogueIndex: storyViewModel.dialogueIndex,
                    buttonText: storyViewModel.buttonText,
                    onButtonTapped: {
                        storyViewModel.handleButtonTap { viewModel.navigateTo($0) }
                    },
                    onBackTapped: !storyViewModel.isFirstDialogue ? {
                        storyViewModel.previousDialogue()
                    } : nil,
                    onCardTapped: {
                        storyViewModel.handleButtonTap { viewModel.navigateTo($0) }
                    },
                    audioManager: audioManager
                )
            }

            // Layer 3: Back button (separate from dialogue VStack so safe area is consistent)
            if storyViewModel.isFirstDialogue {
                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.episodes)
                        }, audioManager: audioManager)
                        Spacer()
                    }
                    .padding(.leading, 36) 
                    .padding(.top, 50)
                    Spacer()
                }
                .ignoresSafeArea()
            }
        }
        .ignoresSafeArea()
        .onAppear {
            audioManager.pauseBackgroundMusic()
        }
        .onDisappear {
            audioManager.resumeBackgroundMusic()
            audioManager.stopDubbing()
        }
    }
}

#Preview {
    StoryScreenView(viewModel: GameViewModel(), content: StoryData.getContent(for: 1))
}
