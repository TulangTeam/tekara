//
//  MovementConfiguration.swift
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

    private enum Distance {
        static let trashRadius: Float = 0.8
        static let bigHutRadius: Float = 0.8
        static let binRadius: Float = 1.2
        static let hutRadius: Float = 0.6
        static let wallBuffer: Float = 0.15
        static let raycastHeight: Float = 2.0
        static let raycastLength: Float = 5.0
        static let groundingBaseAngle: Float = 270.0
    }

    public static var interactionManager: TrashInteractionManager?

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
            let kaiWorldPos = kai.position(relativeTo: nil)

            if let camera = cameraAnchor {
                camera.transform.translation = kaiWorldPos
            }

            if let manager = Self.interactionManager {
                var closestTrash: Entity? = nil
                var nearDeposit = false
                var nearHut = false
                var trashCount = 0

                if let island = kai.parent {
                    for entity in island.children {
                        let entityPos = entity.position(relativeTo: nil)
                        let distance = simd_distance(kaiWorldPos, entityPos)

                        if entity.name.lowercased().contains("trash") {
                            trashCount += 1
                            if distance < Distance.trashRadius {
                                closestTrash = entity
                            }
                        }

                        if entity.name.lowercased().contains("big_hut") {
                            if distance < Distance.bigHutRadius {
                                nearHut = true
                            }
                        }
                    }
                }

                if let rootEntity = kai.anchor ?? cameraAnchor?.parent {
                    if let hutEntity = rootEntity.findEntity(named: "bin") {
                        let hutPos = hutEntity.position(relativeTo: nil)
                        let distanceToHut = simd_distance(kaiWorldPos, hutPos)

                        if distanceToHut < Distance.binRadius {
                            nearDeposit = true
                        }
                    }
                }

                if !nearHut {
                    if let rootEntity = kai.anchor ?? cameraAnchor?.parent {
                        if let hutEntity = rootEntity.findEntity(named: "hut") {
                            let hutPos = hutEntity.position(relativeTo: nil)
                            let distanceToHut = simd_distance(
                                kaiWorldPos,
                                hutPos
                            )
                            if distanceToHut < Distance.hutRadius {
                                nearHut = true
                            }
                        }
                    }
                }

                // ponytail: debounce main-thread writes to state changes only
                let totalTrashCount = trashCount + manager.collectedTrashCount
                let didChange = closestTrash !== manager.nearbyTrashEntity
                    || manager.isNearDepositZone != nearDeposit
                    || manager.isNearHut != nearHut
                    || manager.totalTrashCount != totalTrashCount

                if didChange {
                    Task { @MainActor in
                        manager.nearbyTrashEntity = closestTrash
                        manager.isNearDepositZone = nearDeposit
                        manager.isNearHut = nearHut
                        manager.totalTrashCount = totalTrashCount
                    }
                }
            }

            // Controlling Analog and Collision Detection
            if joystick != .zero {
                let inputX = joystick.x
                let inputZ = joystick.y

                let isometricAngleY: Float = 45.0
                let radiansY = isometricAngleY * (.pi / 180.0)
                let forwardX = sin(radiansY)
                let forwardZ = cos(radiansY)
                let rightX = cos(radiansY)
                let rightZ = -sin(radiansY)

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

                // RAYCAST A: Cek If any ground
                let groundRayOrigin = SIMD3<Float>(
                    targetWorldPos.x,
                    targetWorldPos.y + Distance.raycastHeight,
                    targetWorldPos.z
                )
                let groundHits = scene.raycast(
                    origin: groundRayOrigin,
                    direction: SIMD3<Float>(0, -1, 0),
                    length: Distance.raycastLength
                )
                let isOnSand = groundHits.contains(where: {
                    $0.entity.name == "sand_layer2"
                })

                // RAYCAST B: Cek if any wall collisions
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
                    let wallRayLength = distance + Distance.wallBuffer

                    let wallHits = scene.raycast(
                        origin: wallRayOrigin,
                        direction: wallRayDirection,
                        length: wallRayLength
                    )
                    hitsObstacle = wallHits.contains { hit in
                        let isNotKai = hit.entity != kai
                        let isNotSand = hit.entity.name != "sand_layer2"
                        let hasCollision = hit.entity.components.has(
                            CollisionComponent.self
                        )
                        return isNotKai && isNotSand && hasCollision
                    }
                }

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

                let angle = atan2(moveDirectionX, moveDirectionZ)
                let movementRotation = simd_quatf(
                    angle: angle,
                    axis: SIMD3<Float>(0, 1, 0)
                )
                let baseAngleX = Distance.groundingBaseAngle * (Float.pi / 180.0)
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

            // BACKGROUND GROUNDING SYSTEM
            let worldPos = kai.position(relativeTo: nil)
            let currentGroundRayOrigin = SIMD3<Float>(
                worldPos.x,
                worldPos.y + Distance.raycastHeight,
                worldPos.z
            )
            let hits = scene.raycast(
                origin: currentGroundRayOrigin,
                direction: SIMD3<Float>(0, -1, 0),
                length: Distance.raycastLength
            )

            if let sandHit = hits.first(where: {
                $0.entity.name == "sand_layer2"
            }) {
                let localHitPos =
                    kai.parent?.convert(position: sandHit.position, from: nil)
                    ?? sandHit.position
                kai.position.y = localHitPos.y + groundComp.capsuleOffset
            }
        }
    }
}
