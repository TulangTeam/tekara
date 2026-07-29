//
//  HapticManager.swift
//  tekara
//
//  Created by Shandika David Ardiansyah on 23/07/26.
//

import UIKit

public enum HapticManager {
    public static func playWarning() {
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(.warning)
    }

    public static func playHeavyImpact() {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.prepare()
        generator.impactOccurred()
    }
}
