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
    var dialogueIndex: Int
    var buttonText: String = "Next"
    var onButtonTapped: () -> Void
    var onBackTapped: (() -> Void)? = nil
    var onCardTapped: (() -> Void)? = nil
    var audioManager: AudioManager?
    
    // Typewriter state tracking
    @State private var displayedText: String = ""
    @State private var isTyping: Bool = false
    
    // Dark semi-transparent gradient at the bottom
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
                
                // Only show speaker name & line if it's NOT the Narrator
                if speaker.id != "narrator" {
                    Text(speaker.displayName.uppercased())
                        .font(.custom("Baloo 2", size: 22).bold())
                        .foregroundColor(speaker.tagColor)
                    
                    // Glowing line under speaker name
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
                }
                
                // 2. Dialogue Content with Typewriter & Height Reservation
                ZStack(alignment: .topLeading) {
                    // Hidden template text reserves full frame height to prevent layout jumps
                    Text(dialogueText)
                        .font(.custom("Baloo 2", size: 20).bold())
                        .lineSpacing(6)
                        .opacity(0)
                    
                    // Visible animated typewriter text
                    Text(displayedText)
                        .font(.custom("Baloo 2", size: 20).bold())
                        .foregroundColor(.white)
                        .lineSpacing(6)
                        .multilineTextAlignment(.leading)
                }
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
                
                if isTyping {
                    // Tap 1: Instantly reveal full text if currently typing
                    isTyping = false
                    displayedText = dialogueText
                } else {
                    // Tap 2: Proceed to next dialogue once typing is finished
                    onCardTapped?()
                }
            }
        }
        .ignoresSafeArea(edges: .bottom)
        .task(id: dialogueText) {
            displayedText = ""
            isTyping = true
            audioManager?.playDubbing(index: dialogueIndex)

            for char in dialogueText {
                guard isTyping, !Task.isCancelled else { break }
                displayedText.append(char)
                // 25ms delay per character (~40 chars/sec)
                try? await Task.sleep(nanoseconds: 25_000_000)
            }

            if isTyping {
                isTyping = false
            }
        }
    }
}

#Preview {
    ZStack {
        Image("bgocean")
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()
        
        DialogueCard(
            title: "Prologue",
            speaker: SpeakerRegistry.narrator,
            dialogueText: "One sunny morning, Kai visits the beach, hoping to enjoy the fresh sea breeze and the sound of the waves.",
            dialogueIndex: 0,
            buttonText: "Next",
            onButtonTapped: {
#if DEBUG
                print("Proceed to next dialogue")
#endif
            }
        )
    }
}
