//
//  FactVideo.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 20/07/26.
//

import Foundation

struct FactVideo {
    var episodeId: Int
    var videoName: String
    var sourceCredit: String
}

struct FactVideoData {
    // ponytail: add new episodes here
    private static let videos: [Int: FactVideo] = [
        1: FactVideo(
            episodeId: 1,
            videoName: "av-oceanep1",
            sourceCredit: "Source: National Geographic YouTube Channel"
        )
    ]
    private static let fallback = FactVideo(
        episodeId: 0,
        videoName: "av-oceanep1",
        sourceCredit: "Source: YouTube Channel"
    )

    static func getVideo(for episodeId: Int) -> FactVideo {
        videos[episodeId] ?? fallback
    }
}
