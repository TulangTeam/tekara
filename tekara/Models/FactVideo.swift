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
    static func getVideo(for episodeId: Int) -> FactVideo {
        switch episodeId {
        case 1:
            return FactVideo(
                episodeId: 1,
                videoName: "av-oceanep1",
                sourceCredit: "Source: National Geographic YouTube Channel"
            )
        default:
            return FactVideo(
                episodeId: episodeId,
                videoName: "av-oceanep1",
                sourceCredit: "Source: YouTube Channel"
            )
        }
    }
}
