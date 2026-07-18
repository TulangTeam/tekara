# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

### MVVM Pattern (App Interface)
The app uses **MVVM** for the menu/navigation interface:
- **Model**: `GameState` in `Models/GameState.swift`
- **ViewModel**: `GameViewModel` in `ViewModels/GameViewModel.swift`
- **View**: SwiftUI views in `Views/Screens/` and `Views/Components/`

Views observe `GameViewModel` via `@ObservedObject` and call methods to update state.

### Navigation Pattern
- **GameViewModel** (in `ViewModels/`) is the central state manager
- **AppScreen** enum (in `Models/Navigation/`) defines screens: `.welcome`, `.chapter`, `.episodes`
- **ContentView** switches between screens based on `viewModel.gameState.currentScreen`

### Screen Hierarchy
```
WelcomeView → ChapterView → EpisodesView
```

### GameState
Located in `Models/GameState.swift`:
- `currentScreen: AppScreen` - current navigation state
- `isSoundEnabled: Bool` - sound toggle state

### Animation Patterns

**Popup animations** (scaleEffect 0→1):
```swift
withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
    scale = 1
}
```

**Background switching** (for ocean wallpaper):
```swift
Timer.scheduledTimer(withTimeInterval: 0.7, repeats: true) { _ in
    currentBgIndex = currentBgIndex == 0 ? 1 : 0
}
```

**Button press animation**: Use `ScaleButtonStyle` modifier with `.buttonStyle(ScaleButtonStyle())`

## App Configuration

- **Orientation**: Landscape-only (locked in `AppDelegate` and `Info.plist`)
- **Custom Font**: "Baloo 2" (loaded via Info.plist)
- **Assets**: Use `TekaraAssets` package for image assets

## Key Components

- **EpisodeCard**: Reusable card with `EpisodeStatus` enum (`.begin`, `.completed`, `.locked`)
- **MapSelect**: Map selection with popup animations and arrow indicators
- **LeftToolbar**: Bottom toolbar with sound/help/settings buttons
