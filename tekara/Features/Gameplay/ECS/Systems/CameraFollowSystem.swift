//
//  CameraFollowSystem.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import Foundation
import RealityKit

public class CameraFollowSystem: RealityKit.System {
    private static let query = EntityQuery(
        where: .has(MovementInputComponent.self)
            && .has(CharacterGroundingComponent.self)
    )

    required public init(scene: RealityKit.Scene) {}

    public func update(context: SceneUpdateContext) {
        let cameraAnchor = context.scene.findEntity(named: "camera_anchor")

        context.scene.performQuery(Self.query).forEach { kai in
            let kaiWorldPos = kai.position(relativeTo: nil)

            if let camera = cameraAnchor {
                camera.setPosition(kaiWorldPos, relativeTo: nil)
            }
        }
    }
}
