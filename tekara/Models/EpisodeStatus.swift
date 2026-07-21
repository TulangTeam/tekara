//
//  EpisodeStatus.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

enum EpisodeStatus {
    case begin
    case completed
    case locked

    var text: String {
        switch self {
        case .begin: return "Begin"
        case .completed: return "Play"
        case .locked: return "Locked"
        }
    }

    var buttonTop: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return .gray
        }
    }

    var buttonEdge: Color {
        switch self {
        case .begin: return Color(red: 0.62, green: 0.51, blue: 0.0)
        case .completed: return Color(red: 0.16, green: 0.55, blue: 0.19)
        case .locked: return Color(red: 0.35, green: 0.35, blue: 0.35)
        }
    }

    var badgeColor: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return .gray
        }
    }

    var borderColor: Color {
        switch self {
        case .begin: return Color(red: 229 / 255, green: 208 / 255, blue: 39 / 255)
        case .completed: return Color(red: 0.37, green: 0.82, blue: 0.41)
        case .locked: return Color(red: 0.72, green: 0.72, blue: 0.72)
        }
    }

    var cardEdge: Color {
        switch self {
        case .begin: return Color(red: 0.75, green: 0.66, blue: 0.02)
        case .completed: return Color(red: 0.22, green: 0.6, blue: 0.26)
        case .locked: return Color(red: 0.58, green: 0.58, blue: 0.58)
        }
    }
}
