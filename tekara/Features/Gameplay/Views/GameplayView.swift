//
//  GameplayView.swift
//  tekara
//
//  Created by DIMAS DAFFA ERNANDA on 18/07/26.
//

import SwiftUI

struct GameplayView: View {
    var episodeId: Int
    @Bindable var viewModel: GameViewModel

    var body: some View {
        switch episodeId {
        case 1:
            // Episode 1: Clean Up The Seashore
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        case 2:
            // Episode 2: Save The Turtles (Future episode view)
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        case 3:
            // Episode 3: Lost Little Fish (Future episode view)
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        case 4:
            // Episode 4: Save The Coral (Future episode view)
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        case 5:
            // Episode 5: Welcome Home (Future episode view)
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        case 6:
            // Episode 6: Be The Ocean Hero! (Future episode view)
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)

        default:
            Episode1GameplayView(episodeId: episodeId, viewModel: viewModel)
        }
    }
}

#Preview {
    GameplayView(episodeId: 1, viewModel: GameViewModel())
}
