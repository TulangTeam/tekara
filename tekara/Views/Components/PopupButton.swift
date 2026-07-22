//
//  PopupButton.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 21/07/26.
//

import SwiftUI

private struct ButtonSizeKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

struct PopupButton: View {
    let title: String
    var face: Color = PopupStyle.successFace
    var edge: Color = PopupStyle.successEdge
    var isEnabled: Bool = true
    let action: () -> Void

    @State private var isPressed = false
    @State private var size: CGSize = CGSize(width: 140, height: 40)
    private let pressDepth: CGFloat = 5

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(isEnabled ? edge : PopupStyle.neutralEdge)
                .frame(width: size.width, height: size.height)

            Capsule()
                .fill(isEnabled ? face : PopupStyle.neutralFace)
                .frame(width: size.width, height: size.height)
                .overlay(
                    Text(title)
                        .font(.custom("Baloo 2", size: 17).bold())
                        .foregroundColor(.white)
                        .lineLimit(1)
                )
                .offset(y: isPressed ? 0 : -pressDepth)
        }
        .frame(width: size.width, height: size.height + pressDepth)
        .background(
            Text(title)
                .font(.custom("Baloo 2", size: 17).bold())
                .padding(.horizontal, 32)
                .padding(.vertical, 10)
                .fixedSize()
                .background(
                    GeometryReader { proxy in
                        Color.clear.preference(key: ButtonSizeKey.self, value: proxy.size)
                    }
                )
                .hidden()
        )
        .onPreferenceChange(ButtonSizeKey.self) { size = $0 }
        .saturation(isEnabled ? 1 : 0)
        .opacity(isEnabled ? 1 : 0.75)
        .contentShape(Rectangle())
        .onTapGesture {
            guard isEnabled else { return }
            withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
                withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
                action()
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PopupButton(title: "Next", action: {})
        PopupButton(title: "Back", face: Color.gray, edge: PopupStyle.neutralEdge, action: {})
        PopupButton(title: "Leave", face: PopupStyle.themeRed, edge: PopupStyle.themeRedEdge, action: {})
        PopupButton(title: "Disabled", isEnabled: false, action: {})
    }
    .padding()
    .background(PopupStyle.cardBackground)
}
