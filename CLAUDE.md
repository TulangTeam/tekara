# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

### MVVM Pattern (App Interface)
The app uses **MVVM** for the menu/navigation interface:
- **Model**: `GameState` in `Models/GameState.swift`, plus data models (`StoryContent`, `FactVideo`, `AppScreen`)
- **ViewModel**: `GameViewModel` in `ViewModels/GameViewModel.swift`
- **View**: SwiftUI views in `Views/Screens/` and `Views/Components/`

Views observe `GameViewModel` via `@Bindable` (all screen views) or `@State` (ContentView). `GameViewModel` uses `@Observable @MainActor` — the modern iOS 17+ pattern (no `ObservableObject`/`@Published`).

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

### StoryContent Model
Located in `Models/StoryContent.swift`:
- `DialogueItem` - speaker name and dialogue text
- `StoryStage` - stage name, background image, dialogues array
- `StoryContent` - episode info with array of stages
- `StoryData.getContent(for:)` - O(1) dictionary lookup; episode data is a top-level private constant

### FactVideo Model
Located in `Models/FactVideo.swift`:
- `FactVideo` - video name (bundle filename, no extension), source credit text
- `FactVideoData.getVideo(for:)` - O(1) dictionary lookup; add new episodes to the `videos` dictionary with a `// ponytail: add new episodes here` marker

## 3D Gameplay (RealityKit)

`GameplayView` renders the 3D scene (`_WORLD1_CHAP1` from `TekaraAssets`) with a fixed isometric camera and a SwiftUI UI overlay (mission card, exit button, joystick, contextual action buttons, tools menu, popups).

### ECS Components & Systems
- **MovementInputComponent** (`Components/MovementInputComponent.swift`) - holds joystick input (`SIMD2<Float>`), move speed, walking state. The same file also defines:
  - `CleanupTool` enum (`.gloves`, `.scissors`, `.trashBag`) with icon/color/emoji
  - `MissionCompletePhase` enum (`.none`, `.oceanFact`, `.factVideo`, `.congratulations`)
  - `TrashInteractionManager` (`@Observable`) - gameplay state: nearby trash, holding trash, deposit zone / hut proximity, selected tool, trash counts, mission phase
- **CharacterMovementConfiguration** (`Configuration/CharacterMovementConfiguration.swift`) - RealityKit `System` that moves the character (`kai_chara` entity inside `Island`); receives the shared `TrashInteractionManager` via a static property. Proximity thresholds (`trashRadius`, `binRadius`, `hutRadius`, etc.) are named constants in a private `Distance` enum. Main-thread writes are debounced — only dispatched when values actually change.
- Components/systems are registered in `GameplayView.init`

### Gameplay Flow (Episode 1)
Joystick (ThumbStickView package) moves the character → near hut opens `ToolsMenuCard` → select gloves → near trash shows pick-up button → carry trash to deposit zone → dispose. When all trash is collected:
`OceanFactPopup` → `DidYouKnowPopup` (AVKit video) → `CongratulationsPopup` (back to episodes / next episode). Exit button (red, door icon, top-left under MissionCard) shows `ExitConfirmationPopup` before navigating back to episodes.

`GameplayView` uses `private enum Layout` for frame sizes/padding and `private enum Animation` for spring presets — no magic numbers in the view body.

### Popup Components
All gameplay popups live in `Views/Popups/` and share the `PopupCard` shell (dimmed background, spring scale-in, fixed 520pt card width, capsule header, Baloo 2 font). Customize look in one place:
- `PopupStyle` (`Views/Components/PopupStyle.swift`) - shared design tokens: theme colors, card dimensions
- `PopupCard<Content>` (`Views/Popups/PopupCard.swift`) - reusable popup shell
- `PopupButton` (`Views/Components/PopupButton.swift`) - shared capsule action button with auto-sizing

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

**Staggered pop-in** (cards/maps appear left to right, e.g. `EpisodeListView`, `MapSelect`):
Use `StaggeredAnimation.spring(delay:)` and `StaggeredAnimation.mapArrowSpring(delay:)` from `Views/Components/StaggeredAnimation.swift`.

**Button press animation**: Use `ScaleButtonStyle` modifier with `.buttonStyle(ScaleButtonStyle())`

**Popup cards** (`PopupCard` + `PopupStyle`): dimmed background + spring scale-in, capsule header, Baloo 2 font, shared cream card background `Color(red: 0.92, green: 0.91, blue: 0.87)`.

**UI icon consistency**: toolbar icons use a fixed `.frame` so swapping SF Symbols (e.g. speaker ↔ speaker.slash) doesn't shift the layout.

## App Configuration

- **Orientation**: Landscape-only (locked in `AppDelegate` and `Info.plist`)
- **Custom Font**: "Baloo 2" (loaded via `Info.plist` `UIAppFonts`; font lives in `Resources/Fonts/`)
- **Assets**: Use `TekaraAssets` package for image assets

## Audio & Soundtrack

The game features a **tropical beach / under-the-sea** theme with playful, cheerful music for children. Audio is managed by `AudioManager` (`Managers/AudioManager.swift`):
- Singleton: `AudioManager.shared`, marked `@Observable`
- Background music: `playBackgroundMusic(named:)` (e.g. `"beachtrack.mp3"`), plus pause/resume/stop
- SFX: `playSFX(named:)` (e.g. `"bubblesound.mp3"` on button taps)
- Separate mute toggles: `isMusicMuted` / `isSFXMuted` via `toggleMusicMute()` / `toggleSFXMute()`
- Audio files live in `Resources/Audio/` (`beachtrack.mp3`, `bubblesound.mp3`)
- Video files live in `Resources/Video/` (`av-oceanep1.mp4`)
- `print()` calls are wrapped in `#if DEBUG` — safe to leave in production builds

### Soundtrack Prompts

**Main Theme**
```
"[Instrumental] [Sound Effects: Ocean waves and seagulls]  Cheerful Caribbean Calypso instrumental for a children's game. Bouncy, syncopated percussion featuring steel drums, bright marimbas, congas, bongos, and a guiro. Joyful, bustling beach celebration. Rhythmic ocean surf and playful seagulls blending perfectly into the tropical beat.
BPM: 105 (The exact sweet spot for that bouncy Calypso groove)
Tonality: C Major or Bb Major
Chord Progression: C, F, G, C"
```

## Key Components

### Views/Components/ (non-popup helpers)
- **BackButton** (`Views/Components/BackButton.swift`): Circular chevron back button with SFX
- **DialogueCard**: Story dialogue with speaker name and back/next navigation
- **EpisodeCard**: Reusable card with `EpisodeStatus` enum (`.begin`, `.completed`, `.locked`); `ScaleButtonStyle` press animation + SFX, only `.begin` navigates
- **EpisodeList**: Data-driven `ForEach` of episode cards with staggered left-to-right pop-in
- **LeftToolbar** / **LeftToolbarButton**: Toolbar with settings/music/SFX/help buttons
- **MapSelect**: Map selection with popup animations and arrow indicators
- **MissionCard**: Mission objectives overlay in gameplay
- **PlayButton**: Green "PLAY" button on label image
- **ScaleButtonStyle** (`Views/Components/ScaleButtonStyle.swift`): Press-scale button animation
- **ToolsMenuCard**: Tool selection card (gloves/scissors/trash bag), shown near the hut
- **PopupStyle** (`Views/Components/PopupStyle.swift`): Shared design token enum — theme colors, card dimensions
- **PopupButton** (`Views/Components/PopupButton.swift`): Shared capsule action button with auto-sizing, press animation
- **StarRating** (`Views/Components/StarRating.swift`): N-of-M star rating display
- **MissionRow** (`Views/Components/MissionRow.swift`): Icon + text checklist row
- **ToolGridItem** (`Views/Components/ToolGridItem.swift`): Tool selection grid cell
- **IconCircleButton** (`Views/Components/IconCircleButton.swift`): Unified 3D circular icon button (BackButton, LeftToolbarButton)
- **SpeakerButton** (`Views/Components/SpeakerButton.swift`): SFX mute toggle with wiggle animation
- **StaggeredAnimation** (`Views/Components/StaggeredAnimation.swift`): Shared animation factory methods
- **CardHeaderPill** (`Views/Components/CardHeaderPill.swift`): Floating card header label
- **SquishCapsuleButton** (`Views/Components/SquishButton.swift`): Generic 3D capsule button

### Views/Popups/ (gameplay popup views)
- **PopupCard** (`Views/Popups/PopupCard.swift`): Reusable popup shell
- **OceanFactPopup**: "Ocean Fact" text popup
- **DidYouKnowPopup**: AVKit `VideoPlayer` popup for educational clips
- **CongratulationsPopup**: Mission-complete popup (back to episodes / next episode)
- **ExitConfirmationPopup**: "Leave Game?" confirmation with red header

### Views/Screens/
- **StoryScreenView**: Story/dialogue screen with stages and navigation
- **GameplayView**: 3D RealityKit gameplay view

## File Structure

```
tekara/
├── tekaraApp.swift
├── Info.plist                      (UIAppFonts, landscape orientation)
├── Assets.xcassets/                (AccentColor, AppIcon, Elements/, Image/)
├── Models/
│   ├── EpisodeStatus.swift       (EpisodeStatus enum with status-driven colors)
│   ├── FactVideo.swift          (FactVideo + FactVideoData)
│   ├── GameState.swift
│   ├── Speaker.swift            (Speaker + SpeakerRegistry)
│   ├── StoryContent.swift       (DialogueItem, StoryStage, StoryData)
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
│   ├── Components/               (non-popup UI helpers)
│   │   ├── BackButton.swift
│   │   ├── CardHeaderPill.swift
│   │   ├── DialogueCard.swift
│   │   ├── EpisodeCard.swift
│   │   ├── EpisodeList.swift
│   │   ├── IconCircleButton.swift
│   │   ├── LeftToolbar.swift
│   │   ├── LeftToolbarButton.swift
│   │   ├── MapSelect.swift
│   │   ├── MissionCard.swift
│   │   ├── MissionRow.swift
│   │   ├── PlayButton.swift
│   │   ├── PopupButton.swift
│   │   ├── PopupStyle.swift
│   │   ├── ScaleButtonStyle.swift
│   │   ├── SpeakerButton.swift
│   │   ├── SquishButton.swift
│   │   ├── StaggeredAnimation.swift
│   │   ├── StarRating.swift
│   │   ├── ToolGridItem.swift
│   │   └── ToolsMenuCard.swift
│   └── Popups/                    (gameplay popup views)
│       ├── PopupCard.swift        (reusable shell only — style tokens in PopupStyle.swift)
│       ├── OceanFactPopup.swift
│       ├── DidYouKnowPopup.swift
│       ├── CongratulationsPopup.swift
│       └── ExitConfirmationPopup.swift
├── Components/                    (RealityKit ECS — do not mix with SwiftUI)
│   └── MovementInputComponent.swift
├── Configuration/                 (RealityKit Systems)
│   └── CharacterMovementConfiguration.swift
├── Managers/
│   └── AudioManager.swift         (singleton)
├── Extensions/
│   └── Color+Hex.swift
└── Resources/                    (bundled assets)
    ├── Audio/
    │   ├── beachtrack.mp3
    │   └── bubblesound.mp3
    ├── Fonts/
    │   └── Baloo2-VariableFont_wght.ttf
    └── Video/
        └── av-oceanep1.mp4
Packages/
├── TekaraAssets/                  (TekaraAssets.rkassets/, tekaraAssetsBundle)
├── ThumbStickView/                (on-screen joystick)
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
