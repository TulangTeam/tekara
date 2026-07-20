//
//  DialogueCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import SwiftUI

struct DialogueCard: View {
    var title: String
    var dialogueText: String
    var buttonText: String = "Next"
    var onButtonTapped: () -> Void
    var onBackTapped: (() -> Void)? = nil
    var audioManager: AudioManager?

    let cardBackground = Color(red: 0.93, green: 0.89, blue: 0.80)
    let textBrown = Color(red: 0.35, green: 0.24, blue: 0.16)
    let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.76)
    let buttonGreen = Color(red: 0.12, green: 0.69, blue: 0.18)

    var body: some View {
        ZStack(alignment: .top) {

            VStack(alignment: .leading, spacing: 20) {

                Text(dialogueText)
                    .font(.custom("Baloo 2", size: 20).bold())
                    .foregroundColor(textBrown)
                    .lineSpacing(8)

                HStack {
                    if onBackTapped != nil {
                        Button(action: {
                            audioManager?.playSFX(named: "bubblesound.mp3")
                            onBackTapped?()
                        }) {
                            Text("Back")
                                .font(.custom("Baloo 2", size: 18).bold())
                                .foregroundColor(.white)
                                .padding(.horizontal, 30)
                                .padding(.vertical, 12)
                                .background(Capsule().fill(Color.gray))
                                .overlay(
                                    Capsule().stroke(Color.white, lineWidth: 3)
                                )
                                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                        }
                        .buttonStyle(ScaleButtonStyle())
                    }

                    Spacer()

                    Button(action: {
                        audioManager?.playSFX(named: "bubblesound.mp3")
                        onButtonTapped()
                    }) {
                        Text(buttonText)
                            .font(.custom("Baloo 2", size: 18).bold())
                            .foregroundColor(.white)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(buttonGreen))
                            .overlay(
                                Capsule().stroke(Color.white, lineWidth: 3)
                            )
                            .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                    }
                    .buttonStyle(ScaleButtonStyle())
                }
            }
            .padding(.top, 50)
            .padding(.horizontal, 30)
            .padding(.bottom, 20)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(cardBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.white, lineWidth: 4)
            )
            .shadow(color: .black.opacity(0.25), radius: 8, x: 0, y: 5)

            Text(title)
                .font(.custom("Baloo 2", size: 22).bold())
                .foregroundColor(.white)
                .padding(.horizontal, 60)
                .padding(.vertical, 12)
                .background(Capsule().fill(themeBlue))
                .overlay(
                    Capsule().stroke(Color.white, lineWidth: 3)
                )
                .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 3)
                .offset(y: -24)
        }
        .padding(.top, 24)
        .padding(.horizontal, 40)
    }
}

#Preview {
    ZStack {
        Image("bgocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
            .blur(radius: 4)

        DialogueCard(
            title: "Prologue",
            dialogueText: "One sunny morning, Kai visits the beach with their class for a field trip.\nWhile everyone is excited to play, Kai notices something unusual.\nThe beach is covered with plastic bottles, food wrappers, and fishing lines.\nThe waves gently carry more trash toward the sea.",
            buttonText: "Next",
            onButtonTapped: {
                #if DEBUG
                print("Proceed to next dialogue")
                #endif
            }
        )
    }
}
