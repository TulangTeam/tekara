//
//  DialogueCard.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import SwiftUI

struct DialogueCard: View {
    var title: String
    var speaker: Speaker
    var dialogueText: String
    var buttonText: String = "Next"
    var onButtonTapped: () -> Void
    var onBackTapped: (() -> Void)? = nil
    var audioManager: AudioManager?

    private let cardBackground = Color.white
    private let cardEdge = Color(red: 0.95, green: 0.87, blue: 0.68)
    private let textBrown = Color(red: 0.20, green: 0.30, blue: 0.36)
    private let themeBlue = Color(red: 0.20, green: 0.44, blue: 0.76)
    private let buttonGreen = Color(red: 0.12, green: 0.69, blue: 0.18)
    private let buttonGreenEdge = Color(red: 0.06, green: 0.48, blue: 0.11)
    private let buttonGray = Color.gray
    private let buttonGrayEdge = Color(red: 0.35, green: 0.35, blue: 0.35)

    private let cardPressDepth: CGFloat = 8

    var body: some View {
        ZStack(alignment: .top) {
            cardFace
                .background(
                    RoundedRectangle(cornerRadius: 24)
                        .fill(cardEdge)
                        .offset(y: cardPressDepth)
                )
                .padding(.bottom, cardPressDepth)

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

    // NEW — avatar carries identity on its own via a colored ring,
    // so it still reads clearly even with the text pill gone.
    private var avatarView: some View {
        Circle()
            .fill(speaker.avatarImage == nil ? Color(red: 0.55, green: 0.55, blue: 0.55) : Color.clear)
            .frame(width: 60, height: 60)
            .overlay {
                if let imageName = speaker.avatarImage {
                    Image(imageName)
                        .resizable()
                        .scaledToFill()
                        .clipShape(Circle())
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 26))
                        .foregroundColor(.white)
                }
            }
            .clipShape(Circle())
            .overlay(
                Circle().stroke(speaker.tagColor, lineWidth: 4)   // NEW — identity ring
            )
    }

    private var cardFace: some View {
        VStack(alignment: .leading, spacing: 0) {

            // CHANGED — pill removed, avatar + ring now do the identification work.
            // Dialogue sits vertically centered against the avatar instead of stacked below a tag.
            HStack(alignment: .center, spacing: 16) {
                avatarView

                Text(dialogueText)
                    .font(.custom("Baloo 2", size: 19).bold())
                    .foregroundColor(textBrown)
                    .lineSpacing(7)
            }

            HStack {
                if onBackTapped != nil {
                    SquishCapsuleButton(
                        text: "Back",
                        top: buttonGray,
                        edge: buttonGrayEdge,
                        audioManager: audioManager,
                        action: { onBackTapped?() }
                    )
                }

                Spacer()

                SquishCapsuleButton(
                    text: buttonText,
                    top: buttonGreen,
                    edge: buttonGreenEdge,
                    horizontalPadding: 40,
                    audioManager: audioManager,
                    action: onButtonTapped
                )
            }
            .padding(.top, 24)
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
                .stroke(cardEdge, lineWidth: 4)
        )
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
            speaker: SpeakerRegistry.kai,
            dialogueText: "Whoa, this beach is covered in trash! Let's clean it up together so the animals have a safe home again.",
            buttonText: "Next",
            onButtonTapped: {
                #if DEBUG
                print("Proceed to next dialogue")
                #endif
            }
        )
    }
}
