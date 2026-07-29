//
//  MovementInputComponent.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 19/07/26.
//

import Foundation
import RealityKit

public struct MovementInputComponent: Component {
    public var joystickValue: SIMD2<Float> = .zero
    public var moveSpeed: Float = 0.0020  // Character move speed
    public var isWalking: Bool = false

    public init() {}
}
