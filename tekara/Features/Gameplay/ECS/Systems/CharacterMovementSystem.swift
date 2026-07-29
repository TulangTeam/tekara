//
//  CharacterMovementConfiguration.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import Foundation
import RealityKit

public class CharacterMovementConfiguration: RealityKit.System {
    private static let query = EntityQuery(
        where: .has(MovementInputComponent.self)
            && .has(CharacterGroundingComponent.self)
    )

    private enum Config {
        static let wallBuffer: Float = 0.15
        static let raycastHeight: Float = 2.0
        static let raycastLength: Float = 5.0
        static let groundingBaseAngle: Float = 270.0
    }

    required public init(scene: RealityKit.Scene) {}

    public func update(context: SceneUpdateContext) {
        let cameraAnchor = context.scene.findEntity(named: "camera_anchor")

        context.scene.performQuery(Self.query).forEach { kai in
            guard var inputComp = kai.components[MovementInputComponent.self],
                let groundComp = kai.components[
                    CharacterGroundingComponent.self
                ],
                let scene = kai.scene
            else { return }

            let joystick = inputComp.joystickValue

            if joystick != .zero {
                let inputX = joystick.x
                let inputZ = joystick.y

                // Extract Forward & Right vectors from camera transform matrix
                var forwardX: Float = 0
                var forwardZ: Float = 1
                var rightX: Float = 1
                var rightZ: Float = 0

                if let camera = cameraAnchor {
                    let matrix = camera.transform.matrix

                    let camRight = SIMD3<Float>(
                        matrix.columns.0.x,
                        0,
                        matrix.columns.0.z
                    )
                    let camForward = SIMD3<Float>(
                        matrix.columns.2.x,
                        0,
                        matrix.columns.2.z
                    )

                    if simd_length(camRight) > 0.001,
                        simd_length(camForward) > 0.001
                    {
                        let normRight = simd_normalize(camRight)
                        let normForward = simd_normalize(camForward)

                        rightX = normRight.x
                        rightZ = normRight.z
                        forwardX = normForward.x
                        forwardZ = normForward.z
                    }
                }

                let moveDirectionX = (rightX * inputX) + (forwardX * inputZ)
                let moveDirectionZ = (rightZ * inputX) + (forwardZ * inputZ)

                let targetLocalX =
                    kai.position.x + (moveDirectionX * inputComp.moveSpeed)
                let targetLocalZ =
                    kai.position.z + (moveDirectionZ * inputComp.moveSpeed)

                let targetLocalPos = SIMD3<Float>(
                    targetLocalX,
                    kai.position.y,
                    targetLocalZ
                )
                let targetWorldPos =
                    kai.parent?.convert(position: targetLocalPos, to: nil)
                    ?? targetLocalPos

                // RAYCAST A: Ground detection
                let groundRayOrigin = SIMD3<Float>(
                    targetWorldPos.x,
                    targetWorldPos.y + Config.raycastHeight,
                    targetWorldPos.z
                )
                let groundHits = scene.raycast(
                    origin: groundRayOrigin,
                    direction: SIMD3<Float>(0, -1, 0),
                    length: Config.raycastLength
                )
                let isOnSand = groundHits.contains(where: {
                    $0.entity.name == "sand_ground_2"
                })

                // RAYCAST B: Wall/obstacle collision
                let currentWorldPos = kai.position(relativeTo: nil)
                let wallRayOrigin = SIMD3<Float>(
                    currentWorldPos.x,
                    currentWorldPos.y + 0.5,
                    currentWorldPos.z
                )
                let targetDirection = targetWorldPos - currentWorldPos
                let distance = simd_length(targetDirection)

                var hitsObstacle = false
                if distance > 0.001 {
                    let wallRayDirection = simd_normalize(targetDirection)
                    let wallRayLength = distance + Config.wallBuffer

                    let wallHits = scene.raycast(
                        origin: wallRayOrigin,
                        direction: wallRayDirection,
                        length: wallRayLength
                    )
                    hitsObstacle = wallHits.contains { hit in
                        let isNotKai = hit.entity != kai
                        let isNotSand = hit.entity.name != "sand_ground_2"
                        let hasCollision = hit.entity.components.has(
                            CollisionComponent.self
                        )
                        return isNotKai && isNotSand && hasCollision
                    }
                }

                // Apply movement if valid
                if isOnSand && !hitsObstacle {
                    kai.position.x = targetLocalX
                    kai.position.z = targetLocalZ

                    if let animationResource = kai.availableAnimations.first {
                        if !inputComp.isWalking {
                            kai.playAnimation(animationResource.repeat())
                            inputComp.isWalking = true
                            kai.components.set(inputComp)
                        }
                    }
                }

                // Rotate character to face movement direction
                let angle = atan2(moveDirectionX, moveDirectionZ)
                let movementRotation = simd_quatf(
                    angle: angle,
                    axis: SIMD3<Float>(0, 1, 0)
                )
                let baseAngleX = Config.groundingBaseAngle * (Float.pi / 180.0)
                let baseFixRotation = simd_quatf(
                    angle: baseAngleX,
                    axis: SIMD3<Float>(1, 0, 0)
                )
                kai.transform.rotation = movementRotation * baseFixRotation

            } else {
                if inputComp.isWalking {
                    kai.stopAllAnimations()
                    inputComp.isWalking = false
                    kai.components.set(inputComp)
                }
            }

            let worldPos = kai.position(relativeTo: nil)
            let currentGroundRayOrigin = SIMD3<Float>(
                worldPos.x,
                worldPos.y + Config.raycastHeight,
                worldPos.z
            )
            let hits = scene.raycast(
                origin: currentGroundRayOrigin,
                direction: SIMD3<Float>(0, -1, 0),
                length: Config.raycastLength
            )

            if let sandHit = hits.first(where: {
                $0.entity.name == "sand_ground_2"
            }) {
                let localHitPos =
                    kai.parent?.convert(position: sandHit.position, from: nil)
                    ?? sandHit.position
                kai.position.y = localHitPos.y + groundComp.capsuleOffset
            }
        }
    }
}
