//
//  ToolbarButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct ToolbarButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: iconName)
                .font(.system(size: 22, weight: .medium))
                .foregroundColor(.white)
                .shadow(color: .black.opacity(0.5), radius: 2, x: 1, y: 1)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
