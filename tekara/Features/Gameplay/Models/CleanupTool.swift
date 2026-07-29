//
//  CleanupTool.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import SwiftUI

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
