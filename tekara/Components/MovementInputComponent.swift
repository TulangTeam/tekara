//
//  MovementComponents.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import Foundation
import Observation
import RealityKit
import SwiftUI

public struct MovementInputComponent: Component {
    public var joystickValue: SIMD2<Float> = .zero
    public var moveSpeed: Float = 0.0020  // Character move speed
    public var isWalking: Bool = false

    public init() {}
}

public struct CharacterGroundingComponent: Component {
    public var capsuleOffset: Float = 0.0

    public init() {}
}

public enum CleanupTool: String, CaseIterable, Identifiable {
    case gloves = "Gloves"
    case netScissor = "Net Scissor"
    case coralCleaner = "Coral Cleaner"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .gloves: return "hand.raised.fill"
        case .netScissor: return "scissors"
        case .coralCleaner: return "bubbles.and.sparkles"
        }
    }

    public var color: Color {
        switch self {
        case .gloves: return Color(hex: "F59E0B")
        case .netScissor: return Color(hex: "EF4444")
        case .coralCleaner: return Color(hex: "10B981")
        }
    }

    public var emoji: String {
        switch self {
        case .gloves: return "🧤"
        case .netScissor: return "✂️"
        case .coralCleaner: return "🧽"
        }
    }

    public var toolDescription: String {
        switch self {
        case .gloves:
            return "Use to pick up trash"
        case .netScissor:
            return "Use to cut ghost fishing nets and remove them"
        case .coralCleaner:
            return "Use to clean dirty corals and help them recover"
        }
    }
}

public enum MissionCompletePhase {
    case none
    case oceanFact
    case factVideo
    case congratulations
}

public enum TutorialStep: Int, CaseIterable {
    case joystick = 0
    case cameraSwipe
    case goToHut
    case selectTool
    case pickTrash
    case depositBin
    case done

    public var title: String {
        switch self {
        case .joystick: return "Move Your Character"
        case .cameraSwipe: return "Rotate the Camera"
        case .goToHut: return "Go to the Hut"
        case .selectTool: return "Select a Tool"
        case .pickTrash: return "Pick Up Trash"
        case .depositBin: return "Dispose Trash"
        case .done: return ""
        }
    }

    public var description: String {
        switch self {
        case .joystick: return "Use the joystick to move Kai around the island"
        case .cameraSwipe: return "Swipe the screen to rotate the camera view"
        case .goToHut: return "Walk to the Hut to get your cleanup tools"
        case .selectTool: return "Choose Hand Gloves to pick up trash"
        case .pickTrash: return "Walk near trash and tap the pickup button"
        case .depositBin: return "Bring the trash to the Bin and dispose it"
        case .done: return ""
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
        case .done: return "checkmark.circle.fill"
        }
    }
}

@Observable
public class TrashInteractionManager {
    public var nearbyTrashEntity: Entity? = nil
    public var nearbyShellEntity: Entity? = nil
    public var nearbySeaStarEntity: Entity? = nil
    
    public var isHoldingTrash: Bool = false
    public var isNearDepositZone: Bool = false
    public var isNearHut: Bool = false
    public var selectedTool: CleanupTool? = nil
    public var totalTrashCount: Int = 0
    public var collectedTrashCount: Int = 0
    
    public var pickedShellCount: Int = 0
    public var pickedSeaStarCount: Int = 0
    
    public var missionPhase: MissionCompletePhase = .none
    public var tutorialStep: TutorialStep = .joystick
    public var hasCompletedTutorial: Bool = false
    
    public var isMissionComplete: Bool {
        totalTrashCount > 0 && collectedTrashCount >= totalTrashCount
    }

    public init() {}
}
