//
//  ProximityDetectionSystem.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 21/07/26.
//

import Foundation
import RealityKit

public class ProximityDetectionSystem: RealityKit.System {
    private static let query = EntityQuery(
        where: .has(MovementInputComponent.self)
            && .has(CharacterGroundingComponent.self)
    )

    private enum Radius {
        static let trash: Float = 1.8
        static let hut: Float = 2.5
        static let bin: Float = 1.8
    }

    public static var interactionManager: TrashInteractionManager?

    required public init(scene: RealityKit.Scene) {}

    public func update(context: SceneUpdateContext) {
        guard let manager = Self.interactionManager else { return }
        let cameraAnchor = context.scene.findEntity(named: "camera_anchor")

        context.scene.performQuery(Self.query).forEach { kai in
            let kaiWorldPos = kai.position(relativeTo: nil)

            var closestTrash: Entity? = nil
            var closestShell: Entity? = nil
            var closestSeaStar: Entity? = nil
            var hutWorldPos: SIMD3<Float>? = nil
            var binWorldPos: SIMD3<Float>? = nil
            var minTrashDistance: Float = .greatestFiniteMagnitude
            var closestTrashWorldPos: SIMD3<Float>? = nil
            var nearDeposit = false
            var nearHut = false
            var trashCount = 0

            if let island = kai.parent {
                for entity in island.children {
                    let entityPos = entity.position(relativeTo: nil)
                    let distance = simd_distance(kaiWorldPos, entityPos)
                    let lowerName = entity.name.lowercased()

                    if lowerName.contains("trash") {
                        trashCount += 1
                        if distance < minTrashDistance {
                            minTrashDistance = distance
                            closestTrashWorldPos = entityPos
                        }
                        if distance < Radius.trash {
                            closestTrash = entity
                        }
                    }

                    if lowerName.contains("shell") {
                        if distance < Radius.trash {
                            closestShell = entity
                        }
                    }

                    if lowerName.contains("seastar")
                        || lowerName.contains("starfish")
                        || lowerName.contains("sea_star")
                    {
                        if distance < Radius.trash {
                            closestSeaStar = entity
                        }
                    }

                    if lowerName == "hut" || lowerName == "bighut" || lowerName == "house" {
                        hutWorldPos = entityPos
                        if distance < Radius.hut {
                            nearHut = true
                        }
                    } else if lowerName.contains("hut") && hutWorldPos == nil {
                        hutWorldPos = entityPos
                        if distance < Radius.hut {
                            nearHut = true
                        }
                    }

                    if lowerName.contains("bin") || lowerName.contains("dump") {
                        binWorldPos = entityPos
                        if distance < Radius.bin {
                            nearDeposit = true
                        }
                    }
                }
            }

            if binWorldPos == nil {
                if let rootEntity = kai.anchor ?? cameraAnchor?.parent {
                    if let binEntity = rootEntity.findEntity(named: "bin_dump")
                        ?? rootEntity.findEntity(named: "bin")
                    {
                        let binPos = binEntity.position(relativeTo: nil)
                        binWorldPos = binPos
                        let distanceToBin = simd_distance(kaiWorldPos, binPos)

                        if distanceToBin < Radius.bin {
                            nearDeposit = true
                        }
                    }
                }
            }

            if hutWorldPos == nil {
                if let rootEntity = kai.anchor ?? cameraAnchor?.parent {
                    if let hutEntity = rootEntity.findEntity(named: "hut") ?? rootEntity.findEntity(named: "bighut") {
                        let hutPos = hutEntity.position(relativeTo: nil)
                        hutWorldPos = hutPos
                        let distanceToHut = simd_distance(kaiWorldPos, hutPos)
                        if distanceToHut < Radius.hut {
                            nearHut = true
                        }
                    }
                }
            }

            let currentActiveTotal =
                trashCount + manager.collectedTrashCount
                + (manager.isHoldingTrash ? 1 : 0)
            let totalTrashCount = max(
                manager.totalTrashCount,
                currentActiveTotal
            )

            let didChange =
                closestTrash !== manager.nearbyTrashEntity
                || closestShell !== manager.nearbyShellEntity
                || closestSeaStar !== manager.nearbySeaStarEntity
                || manager.isNearDepositZone != nearDeposit
                || manager.isNearHut != nearHut
                || manager.totalTrashCount != totalTrashCount
                || manager.kaiWorldPosition != kaiWorldPos
                || manager.hutWorldPosition != hutWorldPos
                || manager.binWorldPosition != binWorldPos
                || manager.closestTrashWorldPosition != closestTrashWorldPos

            if didChange {
                Task { @MainActor in
                    manager.nearbyTrashEntity = closestTrash
                    manager.nearbyShellEntity = closestShell
                    manager.nearbySeaStarEntity = closestSeaStar
                    manager.isNearDepositZone = nearDeposit
                    manager.isNearHut = nearHut
                    manager.totalTrashCount = totalTrashCount
                    manager.kaiWorldPosition = kaiWorldPos
                    manager.hutWorldPosition = hutWorldPos
                    manager.binWorldPosition = binWorldPos
                    manager.closestTrashWorldPosition = closestTrashWorldPos
                }
            }
        }
    }
}
