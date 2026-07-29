//
//  Speaker.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

struct Speaker {
    let id: String
    let displayName: String
    let avatarImage: String?   // asset catalog name, nil = use fallback icon
    let tagColor: Color        // color of the "{name} says" pill
}

// ponytail: add new characters here as they're introduced
enum SpeakerRegistry {
    static let narrator = Speaker(
        id: "narrator",
        displayName: "Narrator",
        avatarImage: nil,
        tagColor: Color(hex: "B4B4B4")
    )

    static let kai = Speaker(
        id: "kai",
        displayName: "Kai",
        avatarImage: "avatar_kai",
        tagColor: Color(hex: "CEC576")
    )

    static let tori = Speaker(
        id: "tori",
        displayName: "Tori",
        avatarImage: "avatar_tori",
        tagColor: Color(hex: "ADDFA2")
    )

    private static let all: [String: Speaker] = [
        narrator.id: narrator,
        kai.id: kai,
        tori.id: tori
    ]

    static func speaker(for id: String) -> Speaker {
        all[id] ?? narrator
    }
}
