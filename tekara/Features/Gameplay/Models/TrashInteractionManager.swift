//
//  TrashInteractionManager.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import Observation
import RealityKit

@Observable
public class TrashInteractionManager {
    public var nearbyTrashEntity: Entity? = nil
    public var nearbyShellEntity: Entity? = nil
    public var nearbySeaStarEntity: Entity? = nil
    
    public var kaiWorldPosition: SIMD3<Float>? = nil
    public var hutWorldPosition: SIMD3<Float>? = nil
    public var binWorldPosition: SIMD3<Float>? = nil
    public var closestTrashWorldPosition: SIMD3<Float>? = nil

    public var isHoldingTrash: Bool = false
    public var isNearDepositZone: Bool = false
    public var isNearHut: Bool = false
    public var selectedTool: CleanupTool? = nil
    public var totalTrashCount: Int = 0
    public var collectedTrashCount: Int = 0
    
    public var pickedShellCount: Int = 0
    public var pickedSeaStarCount: Int = 0
    
    public var heldShellEntity: Entity? = nil
    public var heldSeaStarEntity: Entity? = nil
    public var seaCreatureWarningType: SeaCreatureWarningType? = nil
    
    public var missionPhase: MissionCompletePhase = .none
    public var tutorialStep: TutorialStep = .joystick
    public var hasCompletedTutorial: Bool = false
    
    public var isMissionComplete: Bool {
        totalTrashCount > 0 && collectedTrashCount >= totalTrashCount
    }

    public init() {}
}
