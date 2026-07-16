//
//  NavTitle.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 16/07/26.
//

import SwiftUI

struct NavTitle: View {
    
    var body: some View {
        ZStack {
            Image("label")
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 400)
            Text("OCEAN MAP")
                .font(.custom("Baloo 2", size: 32, relativeTo: .title))
                .bold()
                .foregroundColor(.white)
                .padding(.top,20)
        }
    }
}

#Preview {
    NavTitle()
}
