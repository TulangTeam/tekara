//
//  StoryScreenView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 17/07/26.
//

import SwiftUI

struct StoryScreenView: View {
    @ObservedObject var viewModel: GameViewModel
    var content: StoryContent

    @State private var stageIndex: Int = 0
    @State private var dialogueIndex: Int = 0
    @State private var textOpacity: Double = 0
    @State private var contentScale: CGFloat = 0
    @State private var bgOpacity: Double = 0

    var currentStage: StoryStage {
        content.stages[stageIndex]
    }

    var currentDialogue: DialogueItem {
        currentStage.dialogues[dialogueIndex]
    }

    var isFirstDialogue: Bool {
        dialogueIndex == 0 && stageIndex == 0
    }

    var isLastDialogue: Bool {
        dialogueIndex == currentStage.dialogues.count - 1 && stageIndex == content.stages.count - 1
    }

    var isLastInStage: Bool {
        dialogueIndex == currentStage.dialogues.count - 1
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(currentStage.backgroundImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .opacity(bgOpacity)

                VStack {
                    HStack {
                        BackButton(action: {
                            viewModel.navigateTo(.episodes)
                        })
                        Spacer()

                        Text(currentStage.stageName)
                            .font(.custom("Baloo 2", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                            .background(
                                Capsule()
                                    .fill(Color.black.opacity(0.5))
                            )
                    }
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.top, 50)
                    Spacer()
                }

                VStack {
                    Spacer()

                    VStack(spacing: 16) {
                        Text(currentDialogue.speaker)
                            .font(.custom("Baloo 2", size: 18))
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 2, x: 0, y: 1)

                        Text(currentDialogue.text)
                            .font(.custom("Baloo 2", size: 20))
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.black.opacity(0.6))
                            )
                            .opacity(textOpacity)
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, geometry.size.height * 0.15)

                    HStack(spacing: 20) {
                        if !isFirstDialogue {
                            Button(action: {
                                previousDialogue()
                            }) {
                                Text("Back")
                                    .font(.custom("Baloo 2", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(Color.gray.opacity(0.8))
                                    )
                            }
                        }

                        if isLastDialogue {
                            Button(action: {
                                viewModel.navigateTo(.episodes)
                            }) {
                                Text("Start Game")
                                    .font(.custom("Baloo 2", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 0.18, green: 0.73, blue: 0.16))
                                    )
                            }
                        } else {
                            Button(action: {
                                nextDialogue()
                            }) {
                                Text(isLastInStage ? "Next Stage" : "Next")
                                    .font(.custom("Baloo 2", size: 18))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 24)
                                    .padding(.vertical, 12)
                                    .background(
                                        Capsule()
                                            .fill(Color(red: 0.20, green: 0.44, blue: 0.72))
                                    )
                            }
                        }
                    }
                    .scaleEffect(contentScale)
                    .padding(.bottom, geometry.size.height * 0.1)
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            animateIn()
        }
    }

    private func animateIn() {
        contentScale = 0
        textOpacity = 0
        bgOpacity = 1

        withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
            contentScale = 1
        }
        withAnimation(.easeInOut(duration: 0.4).delay(0.3)) {
            textOpacity = 1
        }
    }

    private func nextDialogue() {
        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if isLastInStage {
                stageIndex += 1
                dialogueIndex = 0
            } else {
                dialogueIndex += 1
            }

            withAnimation(.easeInOut(duration: 0.3)) {
                textOpacity = 1
            }
        }
    }

    private func previousDialogue() {
        withAnimation(.easeOut(duration: 0.2)) {
            textOpacity = 0
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            if dialogueIndex > 0 {
                dialogueIndex -= 1
            } else if stageIndex > 0 {
                stageIndex -= 1
                dialogueIndex = content.stages[stageIndex].dialogues.count - 1
            }

            withAnimation(.easeIn(duration: 0.3)) {
                textOpacity = 1
            }
        }
    }
}

#Preview {
    StoryScreenView(viewModel: GameViewModel(), content: StoryData.getContent(for: 1))
}
