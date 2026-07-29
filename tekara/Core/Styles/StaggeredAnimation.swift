//
//  StaggeredAnimation.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

enum StaggeredAnimation {
    /// Card/item pop-in (used by EpisodeList and MapSelect map buttons)
    static func spring(delay baseIndex: Int) -> Animation {
        .spring(response: 0.7, dampingFraction: 0.6).delay(0.2 + Double(baseIndex) * 0.1)
    }

    /// Arrow entrance animation (used by MapSelect arrows)
    static func mapArrowSpring(delay baseIndex: Int) -> Animation {
        switch baseIndex {
        case 0: return .spring(response: 0.6, dampingFraction: 0.7)
        case 1: return .spring(response: 0.6, dampingFraction: 0.7).delay(0.1)
        default: return .spring(response: 0.6, dampingFraction: 0.7).delay(0.15)
        }
    }
}
