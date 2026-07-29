//
//  TutorialStep.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import Foundation

public enum TutorialStep: Int, CaseIterable {
    case joystick = 0
    case cameraSwipe
    case goToHut
    case selectTool
    case pickTrash
    case depositBin
    case cleanupRemaining
    case done

    public var title: String {
        switch self {
        case .joystick: return "Move Kai"
        case .cameraSwipe: return "Rotate Camera"
        case .goToHut: return "Visit the Hut"
        case .selectTool: return "Equip Hand Gloves"
        case .pickTrash: return "Collect Trash"
        case .depositBin: return "Dispose into Bin"
        case .cleanupRemaining: return "Protect Sea Life"
        case .done: return ""
        }
    }

    public var description: String {
        switch self {
        case .joystick: return "Use joystick to move Kai around the beach"
        case .cameraSwipe: return "Swipe anywhere on screen to adjust camera view"
        case .goToHut: return "Walk towards the Hut to collect your tools"
        case .selectTool: return "Choose Hand Gloves from the tools menu"
        case .pickTrash: return "Walk near a trash item and tap pickup"
        case .depositBin: return "Bring collected trash to the Bin to dump it"
        case .cleanupRemaining: return "Collect remaining trash and avoid sea creatures"
        case .done: return ""
        }
    }

    public var toriDialogue: String {
        switch self {
        case .joystick: return "Hi! Drag the joystick on the left to move around!"
        case .cameraSwipe: return "Swipe anywhere on the screen to look around!"
        case .goToHut: return "Follow the green arrow to the Hut to get your tools!"
        case .selectTool: return "Tap on Hand Gloves in the Tools menu to equip them!"
        case .pickTrash: return "Walk near a piece of trash to pick it up!"
        case .depositBin: return "Bring the trash to the Bin and throw it in!"
        case .cleanupRemaining: return "Great job! Clean up the remaining trash, but leave sea stars and shells alone!"
        case .done: return "Awesome job! Let's clean up the beach!"
        }
    }

    public var iconName: String {
        switch self {
        case .joystick: return "arrow.up.and.down.and.arrow.left.and.right"
        case .cameraSwipe: return "hand.draw"
        case .goToHut: return "house.fill"
        case .selectTool: return "hand.raised.fill"
        case .pickTrash: return "leaf.fill"
        case .depositBin: return "trash.fill"
        case .cleanupRemaining: return "star.fill"
        case .done: return "checkmark.circle.fill"
        }
    }
}
