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
        tagColor: Color(red: 0.55, green: 0.55, blue: 0.55)
    )

    static let kai = Speaker(
        id: "kai",
        displayName: "Kai",
        avatarImage: "avatar_kai",
        tagColor: Color(red: 0.20, green: 0.44, blue: 0.76)
    )

    static let tori = Speaker(
        id: "tori",
        displayName: "Tori",
        avatarImage: "avatar_tori",
        tagColor: Color(red: 0.36, green: 0.75, blue: 0.67)
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
