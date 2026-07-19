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
    public var moveSpeed: Float = 0.0008  // Character move speed
    public var isWalking: Bool = false

    public init() {}
}

public struct CharacterGroundingComponent: Component {
    public var capsuleOffset: Float = 0.0

    public init() {}
}

public enum CleanupTool: String, CaseIterable, Identifiable {
    case gloves = "Gloves"
    case scissors = "Scissors"
    case trashBag = "Trash Bag"

    public var id: String { rawValue }

    public var iconName: String {
        switch self {
        case .gloves: return "hand.raised.fill"
        case .scissors: return "scissors"
        case .trashBag: return "trash.fill"
        }
    }

    public var color: Color {
        switch self {
        case .gloves: return Color(hex: "F59E0B")
        case .scissors: return Color(hex: "EF4444")
        case .trashBag: return Color(hex: "10B981")
        }
    }

    public var emoji: String {
        switch self {
        case .gloves: return "🧤"
        case .scissors: return "✂️"
        case .trashBag: return "🗑️"
        }
    }
}

public enum MissionCompletePhase {
    case none
    case oceanFact
    case congratulations
}

@Observable
public class TrashInteractionManager {
    public var nearbyTrashEntity: Entity? = nil
    public var isHoldingTrash: Bool = false
    public var isNearDepositZone: Bool = false
    public var isNearHut: Bool = false
    public var selectedTool: CleanupTool? = nil
    public var totalTrashCount: Int = 0
    public var collectedTrashCount: Int = 0
    public var missionPhase: MissionCompletePhase = .none
    public var isMissionComplete: Bool {
        totalTrashCount > 0 && collectedTrashCount >= totalTrashCount
    }

    public init() {}
}
