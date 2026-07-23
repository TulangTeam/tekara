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
    var onCardTapped: (() -> Void)? = nil
    var audioManager: AudioManager?
    
    // Dark semi-transparent gradient at the bottom so white text
    // stays 100% readable over bright sand or light blue water.
    private let scrimGradient = LinearGradient(
        colors: [
            Color.black.opacity(0.0),
            Color(red: 0.05, green: 0.12, blue: 0.20).opacity(0.70), // Deep ocean shadow
            Color(red: 0.05, green: 0.12, blue: 0.20).opacity(0.90)
        ],
        startPoint: .top,
        endPoint: .bottom
    )
    
    private let buttonGreen = Color(red: 0.12, green: 0.69, blue: 0.18)
    private let buttonGreenEdge = Color(red: 0.06, green: 0.48, blue: 0.11)
    private let buttonGray = Color.gray
    private let buttonGrayEdge = Color(red: 0.35, green: 0.35, blue: 0.35)
    
    var body: some View {
        VStack {
            Spacer() // Pushes the dialogue strip to the bottom of the screen
            
            VStack(alignment: .leading, spacing: 8) {
                
                // 1. Genshin-Style Speaker Name Identifier (No avatar needed)
                Text(speaker.displayName.uppercased())
                    .font(.custom("Baloo 2", size: 22).bold())
                    .foregroundColor(speaker.tagColor) // Uses speaker's accent color (e.g. Gold/Orange)
                    .shadow(color: .black.opacity(0.8), radius: 2, x: 0, y: 1)
                
                // Subtle glowing line under speaker name
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [speaker.tagColor.opacity(0.9), Color.white.opacity(0.2), Color.clear],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(height: 2)
                    .padding(.bottom, 6)
                
                // 2. Dialogue Content
                Text(dialogueText)
                    .font(.custom("Baloo 2", size: 20).bold())
                    .foregroundColor(.white)
                    .lineSpacing(6)
                    .multilineTextAlignment(.leading)
                    .shadow(color: .black.opacity(0.9), radius: 3, x: 0, y: 2)
                
                // 3. Bottom Action Buttons
//                HStack {
//                    if onBackTapped != nil {
//                        SquishCapsuleButton(
//                            text: "Back",
//                            top: buttonGray,
//                            edge: buttonGrayEdge,
//                            audioManager: audioManager,
//                            action: { onBackTapped?() }
//                        )
//                    }
//                    
//                    Spacer()
//                    
//                    SquishCapsuleButton(
//                        text: buttonText,
//                        top: buttonGreen,
//                        edge: buttonGreenEdge,
//                        horizontalPadding: 36,
//                        audioManager: audioManager,
//                        action: onButtonTapped
//                    )
//                }
//                .padding(.top, 12)
            }
            .padding(.horizontal, 50)
            .padding(.top, 40)
            .padding(.bottom, 40)
            .frame(maxWidth: .infinity)
            .background(
                scrimGradient
                    .ignoresSafeArea(edges: .bottom)
            )
            .contentShape(Rectangle())
            .onTapGesture {
                audioManager?.playSFX(named: "bubblesound.mp3")
                onCardTapped?()
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }
}

#Preview {
    ZStack {
        // Sample background illustration
        Image("bgocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
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
