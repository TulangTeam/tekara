//
//  SettingsRow.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct SettingsRow: View {
    let icon: String
    let title: String
    let isOn: Bool
    let onToggle: () -> Void

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(.white)
                .frame(width: 40)

            Text(title)
                .font(.system(size: 20, weight: .medium))
                .foregroundColor(.white)

            Spacer()

            Toggle("", isOn: .constant(isOn))
                .labelsHidden()
                .tint(.orange)
                .onTapGesture {
                    onToggle()
                }
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial))
    }
}
