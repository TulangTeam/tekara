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

## 3D Gameplay (RealityKit)

`GameplayView` renders the 3D scene (`_WORLD1_CHAP1` from `TekaraAssets`) with a fixed isometric camera and a SwiftUI UI overlay (mission card, exit button, joystick, contextual action buttons, tools menu, popups).

### ECS Components & Systems
- **MovementInputComponent** (`Components/MovementInputComponent.swift`) - holds joystick input (`SIMD2<Float>`), move speed, walking state. The same file also defines:
  - `CleanupTool` enum (`.gloves`, `.scissors`, `.trashBag`) with icon/color/emoji
  - `MissionCompletePhase` enum (`.none`, `.oceanFact`, `.congratulations`)
  - `TrashInteractionManager` (`@Observable`) - gameplay state: nearby trash, holding trash, deposit zone / hut proximity, selected tool, trash counts, mission phase
- **CharacterMovementConfiguration** (`Configuration/CharacterMovementConfiguration.swift`) - RealityKit `System` that moves the character (`kai_chara` entity inside `Island`); receives the shared `TrashInteractionManager` via a static property
- Components/systems are registered in `GameplayView.init`

### Gameplay Flow (Episode 1)
Joystick (ThumbStickView package) moves the character → near hut opens `ToolsMenuCard` → select gloves → near trash shows pick-up button → carry trash to deposit zone → dispose. When all trash is collected: `OceanFactPopup` → `CongratulationsPopup` (back to episodes / next episode). Exit button (red, door icon, top-left under MissionCard) shows `ExitConfirmationPopup` before navigating back to episodes.

## Local Packages

Located in `Packages/`:
- **TekaraAssets** - image and 3D scene assets (`tekaraAssetsBundle`)
- **ThumbStickView** - on-screen joystick control
- **ControllerInput**, **WASDInput** - alternative input methods

## Animation Patterns

**Popup animations** (scaleEffect 0→1):
```swift
withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2)) {
    scale = 1
}
```

**Staggered pop-in** (items appear left to right, e.g. `EpisodeListView`, `MapSelect`):
```swift
for index in items.indices {
    withAnimation(.spring(response: 0.7, dampingFraction: 0.6).delay(0.2 + Double(index) * 0.1)) {
        cardScales[index] = 1
    }
}
```

**Button press animation**: Use `ScaleButtonStyle` modifier with `.buttonStyle(ScaleButtonStyle())`

**Popup cards** (`CongratulationsPopup`, `ExitConfirmationPopup`, `OceanFactPopup`): dimmed background + spring scale-in, capsule header, Baloo 2 font, shared cream card background `Color(red: 0.92, green: 0.91, blue: 0.87)`.

**UI icon consistency**: toolbar icons use a fixed `.frame` so swapping SF Symbols (e.g. speaker ↔ speaker.slash) doesn't shift the layout.

## App Configuration

- **Orientation**: Landscape-only (locked in `AppDelegate` and `Info.plist`)
- **Custom Font**: "Baloo 2" (loaded via Info.plist)
- **Assets**: Use `TekaraAssets` package for image assets

## Audio & Soundtrack

The game features a **tropical beach / under-the-sea** theme with playful, cheerful music for children. Audio is managed by `AudioManager` (`Managers/AudioManager.swift`):
- Singleton: `AudioManager.shared`, marked `@Observable`
- Background music: `playBackgroundMusic(named:)` (e.g. `"beachtrack.mp3"`), plus pause/resume/stop
- SFX: `playSFX(named:)` (e.g. `"bubblesound.mp3"` on button taps)
- Separate mute toggles: `isMusicMuted` / `isSFXMuted` via `toggleMusicMute()` / `toggleSFXMute()`
- Audio files currently live in `Extensions/` (`beachtrack.mp3`, `bubblesound.mp3`)

### Soundtrack Prompts

**Main Theme**
```
"[Instrumental] [Sound Effects: Ocean waves and seagulls]  Cheerful Caribbean Calypso instrumental for a children's game. Bouncy, syncopated percussion featuring steel drums, bright marimbas, congas, bongos, and a guiro. Joyful, bustling beach celebration. Rhythmic ocean surf and playful seagulls blending perfectly into the tropical beat.
BPM: 105 (The exact sweet spot for that bouncy Calypso groove)
Tonality: C Major or Bb Major
Chord Progression: C, F, G, C"
```

## Key Components

- **EpisodeCard**: Reusable card with `EpisodeStatus` enum (`.begin`, `.completed`, `.locked`); `ScaleButtonStyle` press animation + SFX, only `.begin` navigates
- **EpisodeList**: Data-driven `ForEach` of episode cards with staggered left-to-right pop-in
- **MapSelect**: Map selection with popup animations and arrow indicators
- **LeftToolbar** / **LeftToolbarButton**: Toolbar with settings/music/SFX/help buttons
- **MissionCard**: Mission objectives overlay in gameplay
- **ToolsMenuCard**: Tool selection card (gloves/scissors/trash bag), shown near the hut
- **DialogueCard**: Story dialogue with speaker name and back/next navigation
- **OceanFactPopup** / **CongratulationsPopup** / **ExitConfirmationPopup**: Gameplay popups
- **BackButton** (`Extensions/BackButton.swift`): Circular chevron back button with SFX
- **StoryScreenView**: Story/dialogue screen with stages and navigation
- **GameplayView**: 3D RealityKit gameplay view

## File Structure

```
tekara/
├── tekaraApp.swift
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
│       ├── CongratulationsPopup.swift
│       ├── DialogueCard.swift
│       ├── EpisodeCard.swift
│       ├── EpisodeList.swift
│       ├── ExitConfirmationPopup.swift
│       ├── LeftToolbar.swift
│       ├── LeftToolbarButton.swift
│       ├── MapSelect.swift
│       ├── MissionCard.swift
│       ├── OceanFactPopup.swift
│       ├── PlayButton.swift
│       └── ToolsMenuCard.swift
├── Components/
│   └── MovementInputComponent.swift   (ECS components + TrashInteractionManager)
├── Configuration/
│   └── CharacterMovementConfiguration.swift   (RealityKit movement System)
├── Managers/
│   └── AudioManager.swift
└── Extensions/
    ├── BackButton.swift
    ├── Color+Hex.swift
    ├── ScaleButtonStyle.swift
    ├── beachtrack.mp3
    └── bubblesound.mp3
Packages/
├── TekaraAssets/      (images + 3D scenes)
├── ThumbStickView/    (joystick)
├── ControllerInput/
└── WASDInput/
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
    GameplayView(episodeId: 1, viewModel: GameViewModel())
}
```
