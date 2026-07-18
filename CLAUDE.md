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
- **AppScreen** enum (in `Models/Navigation/`) defines screens: `.welcome`, `.chapter`, `.episodes`, `.story(episodeId:)`, `.gameplay(episodeId:)`
- **ContentView** switches between screens based on `viewModel.gameState.currentScreen`

### Screen Hierarchy
```
WelcomeView → ChapterView → EpisodesView → StoryScreenView → GameplayView (3D)
```

### AppScreen Enum
Located in `Models/Navigation/AppScreen.swift`:
```swift
case welcome
case chapter
case episodes
case story(episodeId: Int)
case gameplay(episodeId: Int)
```

### GameState
Located in `Models/GameState.swift`:
- `currentScreen: AppScreen` - current navigation state
- `currentEpisodeId: Int` - current episode being played
- `isSoundEnabled: Bool` - sound toggle state

### StoryContent Model
Located in `Models/StoryContent.swift`:
- `DialogueItem` - speaker name and dialogue text
- `StoryStage` - stage name, background image, dialogues array
- `StoryContent` - episode info with array of stages
- `StoryData.getContent(for:)` - returns story content per episode

## Animation Patterns

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
- **StoryScreenView**: Story/dialogue screen with stages and navigation
- **GameplayView**: 3D RealityKit gameplay view

## File Structure

```
tekara/
├── Models/
│   ├── GameState.swift
│   ├── StoryContent.swift
│   └── Navigation/
│       └── AppScreen.swift
├── ViewModels/
│   └── GameViewModel.swift
├── Views/
│   ├── ContentView.swift
│   ├── Screens/
│   │   ├── WelcomeView.swift
│   │   ├── ChapterView.swift
│   │   ├── EpisodesView.swift
│   │   ├── StoryScreenView.swift
│   │   └── GameplayView.swift
│   └── Components/
│       ├── EpisodeCard.swift
│       ├── EpisodeList.swift
│       ├── MapSelect.swift
│       ├── PlayButton.swift
│       ├── LeftToolbar.swift
│       └── BackButton.swift
└── Extensions/
    ├── ScaleButtonStyle.swift
    └── Color+Hex.swift
├── Managers/
│   └── AudioManager.swift
└── Resources/
    └── Audio/ (soundtrack files)
```

## Audio & Soundtrack

The game features a **tropical beach / under-the-sea** theme with playful, cheerful music for children. Audio is managed by `AudioManager.swift`.

### Soundtrack Prompts

**Main Theme**
```
"[Instrumental] [Sound Effects: Ocean waves and seagulls]  Cheerful Caribbean Calypso instrumental for a children's game. Bouncy, syncopated percussion featuring steel drums, bright marimbas, congas, bongos, and a guiro. Joyful, bustling beach celebration. Rhythmic ocean surf and playful seagulls blending perfectly into the tropical beat.
BPM: 105 (The exact sweet spot for that bouncy Calypso groove)
Tonality: C Major or Bb Major
Chord Progression: C, F, G, C"
```


## Testing

**For full app navigation:**
```swift
// in tekaraApp.swift
WindowGroup {
    ContentView()
}
```

**For testing 3D gameplay only:**
```swift
// in tekaraApp.swift
WindowGroup {
    GameplayView(episodeId: 1)
}
```
