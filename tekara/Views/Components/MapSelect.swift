//
//  MapSelect.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct MapSelect: View {
    var onMapSelected: (() -> Void)? = nil

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image("arrow1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200)
                    .position(x: geometry.size.width * 0.25, y: geometry.size.height * 0.45)

                Image("arrow2")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210)
                    .position(x: geometry.size.width * 0.52, y: geometry.size.height * 0.5)

                Image("arrow3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .position(x: geometry.size.width * 0.80, y: geometry.size.height * 0.65)

                Button(action: {
                    print("Seashore map selected!")
                    onMapSelected?()
                }) {
                    Image("seashore")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300)
                }
                .buttonStyle(PlainButtonStyle())
                .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.6)
                Image("seagrass")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .position(x: geometry.size.width * 0.4, y: geometry.size.height * 0.33)
                
                Image("mangrove")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 330)
                    .position(x: geometry.size.width * 0.63, y: geometry.size.height * 0.7)
                
                Image("deepocean")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .position(x: geometry.size.width * 0.80, y: geometry.size.height * 0.4)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    MapSelect()
}
