# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Architecture Overview

### MVVM Pattern (App Interface)
The app uses **MVVM** for the menu/navigation interface:
- **Model**: `GameState` in `Core/Models/GameState.swift`, plus data models (`StoryContent`, `FactVideo`, `AppScreen`)
- **ViewModel**: `GameViewModel` in `Features/Episodes/ViewModels/GameViewModel.swift`
- **View**: SwiftUI views organized by feature in `Features/*/Views/`

Views observe `GameViewModel` via `@Bindable` (all screen views) or `@State` (ContentView). `GameViewModel` uses `@Observable @MainActor` — the modern iOS 17+ pattern (no `ObservableObject`/`@Published`).

### Navigation Pattern
- **GameViewModel** (in `Features/Episodes/ViewModels/`) is the central state manager
- **AppScreen** enum (in `App/Navigation/`) defines screens: `.welcome`, `.chapter`, `.episodes`, `.story(episodeId:)`, `.gameplay(episodeId:)`
- **ContentView** (in `App/`) switches between screens based on `viewModel.gameState.currentScreen`

### Screen Hierarchy
```
WelcomeView → ChapterView → EpisodesView → StoryScreenView → GameplayView (3D)
```

### AppScreen Enum
Located in `App/Navigation/AppScreen.swift`:
```swift
case welcome
case chapter
case episodes
case story(episodeId: Int)
case gameplay(episodeId: Int)
```

### GameState
Located in `Core/Models/GameState.swift`:
- `currentScreen: AppScreen` - current navigation state
- `currentEpisodeId: Int` - current episode being played

### StoryContent Model
Located in `Core/Models/StoryContent.swift`:
- `DialogueItem` - speaker name and dialogue text
- `StoryStage` - stage name, background image, dialogues array
- `StoryContent` - episode info with array of stages
- `StoryData.getContent(for:)` - O(1) dictionary lookup; episode data is a top-level private constant

### FactVideo Model
Located in `Core/Models/FactVideo.swift`:
- `FactVideo` - video name (bundle filename, no extension), source credit text
- `FactVideoData.getVideo(for:)` - O(1) dictionary lookup; add new episodes to the `videos` dictionary with a `// ponytail: add new episodes here` marker

## 3D Gameplay (RealityKit)

`GameplayView` renders the 3D scene (`_WORLD1_CHAP1` from `TekaraAssets`) with a fixed isometric camera and a SwiftUI UI overlay (mission card, exit button, joystick, contextual action buttons, tools menu, popups).

### ECS Components & Systems

All ECS code lives in `Features/Gameplay/ECS/`:

**Components** (`Features/Gameplay/ECS/Components/`):
- **MovementInputComponent** - holds joystick input (`SIMD2<Float>`), move speed, walking state
- **CharacterGroundingComponent** - capsule offset for terrain snapping

**Systems** (`Features/Gameplay/ECS/Systems/`):
- **CharacterMovementSystem** (formerly `CharacterMovementConfiguration`) - RealityKit `System` that moves the character; uses raycasts for ground detection and wall collision
- **CameraFollowSystem** - follows the player character with the camera anchor
- **ProximityDetectionSystem** - detects proximity to trash, hut, deposit zone, sea creatures; updates `TrashInteractionManager` on main thread only when values change

**Gameplay Models** (`Features/Gameplay/Models/`):
- **CleanupTool** - enum (`.gloves`, `.netScissor`, `.coralCleaner`) with icon/color/emoji/description
- **MissionCompletePhase** - enum (`.none`, `.oceanFact`, `.factVideo`, `.congratulations`)
- **TutorialStep** - enum with title, description, toriDialogue, iconName for each step
- **SeaCreatureWarningType** - enum (`.seaStar`, `.shell`)
- **TrashInteractionManager** (`@Observable`) - gameplay state: nearby entities, holding trash, proximity flags, selected tool, trash counts, mission phase, tutorial state

Components/systems are registered in `Episode1GameplayView.init`

### Gameplay Flow (Episode 1)
Joystick (ThumbStickView package) moves the character → near hut opens `ToolsMenuCard` → select gloves → near trash shows pick-up button → carry trash to deposit zone → dispose. When all trash is collected:
`OceanFactPopup` → `DidYouKnowPopup` (AVKit video) → `CongratulationsPopup` (back to episodes / next episode). Exit button (red, door icon, top-left under MissionCard) shows `ExitConfirmationPopup` before navigating back to episodes.

`Episode1GameplayView` uses `private enum Layout` for frame sizes/padding and `private enum Animation` for spring presets — no magic numbers in the view body.

### Gameplay Effects
- **OceanBloomEffect** (`Features/Gameplay/Effects/`) - Metal post-process bloom effect for tropical atmosphere

### Popup Components
All gameplay popups live in `Features/Gameplay/Views/Popups/` and share the `PopupCard` shell (dimmed background, spring scale-in, fixed 520pt card width, capsule header, Baloo 2 font). Customize look in one place:
- `PopupStyle` (`Core/Styles/PopupStyle.swift`) - shared design tokens: theme colors, card dimensions
- `PopupCard<Content>` (`Features/Gameplay/Views/Popups/PopupCard.swift`) - reusable popup shell
- `PopupButton` (`SharedUI/Buttons/PopupButton.swift`) - shared capsule action button with auto-sizing

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
Use `StaggeredAnimation.spring(delay:)` and `StaggeredAnimation.mapArrowSpring(delay:)` from `Core/Styles/StaggeredAnimation.swift`.

**Button press animation**: Use `ScaleButtonStyle` modifier with `.buttonStyle(ScaleButtonStyle())`

**Popup cards** (`PopupCard` + `PopupStyle`): dimmed background + spring scale-in, capsule header, Baloo 2 font, shared cream card background `Color(red: 0.92, green: 0.91, blue: 0.87)`.

**UI icon consistency**: toolbar icons use a fixed `.frame` so swapping SF Symbols (e.g. speaker ↔ speaker.slash) doesn't shift the layout.

## App Configuration

- **Orientation**: Landscape-only (locked in `AppDelegate` and `Info.plist`)
- **Custom Font**: "Baloo 2" (loaded via `Info.plist` `UIAppFonts`; font lives in `Resources/Fonts/`)
- **Assets**: Use `TekaraAssets` package for image assets

## Audio & Soundtrack

The game features a **tropical beach / under-the-sea** theme with playful, cheerful music for children. Audio is managed by `AudioManager` (`Core/Managers/AudioManager.swift`):
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

### SharedUI/Buttons/ (reusable buttons used across features)
- **BackButton**: Circular chevron back button with SFX
- **IconCircleButton**: Unified 3D circular icon button (used by BackButton, LeftToolbarButton)
- **PopupButton**: Shared capsule action button with auto-sizing, press animation
- **SpeakerButton**: SFX mute toggle with wiggle animation
- **LeftToolbarButton**: Individual toolbar button

### SharedUI/Cards/
- **CardHeaderPill**: Floating card header label
- **ChapterHintBubble**: Chapter hint bubble overlay

### SharedUI/Toolbars/
- **LeftToolbar**: Toolbar with settings/music/SFX/help buttons

### SharedUI/Effects/
- **CelebrationBurst**: Particle celebration effect

### Core/Styles/ (shared animation & design tokens)
- **PopupStyle**: Shared design token enum — theme colors, card dimensions
- **ScaleButtonStyle**: Press-scale button animation
- **StaggeredAnimation**: Shared animation factory methods

### Features/Welcome/Views/
- **WelcomeView**: Landing screen
- **PlayButton**: Green "PLAY" button on label image

### Features/Chapter/Views/
- **ChapterView**: Chapter/world selection screen
- **MapSelect**: Map selection with popup animations and arrow indicators

### Features/Episodes/Views/
- **EpisodesView**: Episode listing screen
- **EpisodeCard**: Reusable card with `EpisodeStatus` enum (`.begin`, `.completed`, `.locked`)
- **EpisodeList**: Data-driven `ForEach` of episode cards with staggered pop-in
- **SectionTitleBanner**: Section title banner

### Features/Story/Views/
- **StoryScreenView**: Story/dialogue screen with stages and navigation
- **DialogueCard**: Story dialogue with speaker name and back/next navigation

### Features/Gameplay/Views/
- **GameplayView**: Router view dispatching to episode-specific gameplay views
- **Episode1GameplayView**: Full 3D RealityKit gameplay for Episode 1

### Features/Gameplay/Views/HUD/ (gameplay overlay)
- **MissionCard**: Mission objectives overlay
- **MissionRow**: Icon + text checklist row
- **ToolsMenuCard**: Tool selection card, shown near the hut
- **ToolGridItem**: Tool selection grid cell
- **TutorialGuideView**: Tutorial step-by-step guide overlay

### Features/Gameplay/Views/Popups/ (gameplay popup views)
- **PopupCard**: Reusable popup shell
- **OceanFactPopup**: "Ocean Fact" text popup
- **DidYouKnowPopup**: AVKit `VideoPlayer` popup for educational clips
- **CongratulationsPopup**: Mission-complete popup (back to episodes / next episode)
- **ExitConfirmationPopup**: "Leave Game?" confirmation with red header
- **SeaCreatureWarningPopup**: Warning when picking up sea creatures
- **ToolInfoPopup**: Tool information popup

## File Structure

```
tekara/
├── tekaraApp.swift
├── Info.plist                                  (UIAppFonts, landscape orientation)
├── Assets.xcassets/                            (AccentColor, AppIcon, Elements/, Image/)
│
├── App/                                        (App-level navigation & entry)
│   ├── ContentView.swift
│   └── Navigation/
│       └── AppScreen.swift
│
├── Core/                                       (Shared utilities, no feature dependency)
│   ├── Extensions/
│   │   └── Color+Hex.swift
│   ├── Managers/
│   │   ├── AudioManager.swift                  (singleton)
│   │   ├── HapticManager.swift
│   │   └── EpisodeProgressManager.swift
│   ├── Models/
│   │   ├── EpisodeProgress.swift
│   │   ├── EpisodeStatus.swift
│   │   ├── FactVideo.swift
│   │   ├── GameState.swift
│   │   ├── Speaker.swift
│   │   └── StoryContent.swift
│   └── Styles/
│       ├── PopupStyle.swift
│       ├── ScaleButtonStyle.swift
│       └── StaggeredAnimation.swift
│
├── Features/
│   ├── Welcome/Views/
│   │   ├── WelcomeView.swift
│   │   └── PlayButton.swift
│   ├── Chapter/Views/
│   │   ├── ChapterView.swift
│   │   └── MapSelect.swift
│   ├── Episodes/
│   │   ├── ViewModels/
│   │   │   └── GameViewModel.swift
│   │   └── Views/
│   │       ├── EpisodesView.swift
│   │       ├── EpisodeCard.swift
│   │       ├── EpisodeList.swift
│   │       └── SectionTitleBanner.swift
│   ├── Story/
│   │   ├── ViewModels/
│   │   │   └── StoryViewModel.swift
│   │   └── Views/
│   │       ├── StoryScreenView.swift
│   │       └── DialogueCard.swift
│   └── Gameplay/
│       ├── ECS/
│       │   ├── Components/
│       │   │   ├── MovementInputComponent.swift
│       │   │   └── CharacterGroundingComponent.swift
│       │   └── Systems/
│       │       ├── CharacterMovementSystem.swift
│       │       ├── CameraFollowSystem.swift
│       │       └── ProximityDetectionSystem.swift
│       ├── Models/
│       │   ├── CleanupTool.swift
│       │   ├── MissionCompletePhase.swift
│       │   ├── TutorialStep.swift
│       │   ├── SeaCreatureWarningType.swift
│       │   └── TrashInteractionManager.swift
│       ├── Effects/
│       │   └── OceanBloomEffect.swift
│       └── Views/
│           ├── GameplayView.swift              (router)
│           ├── Episode1GameplayView.swift
│           ├── HUD/
│           │   ├── MissionCard.swift
│           │   ├── MissionRow.swift
│           │   ├── ToolsMenuCard.swift
│           │   ├── ToolGridItem.swift
│           │   └── TutorialGuideView.swift
│           └── Popups/
│               ├── PopupCard.swift
│               ├── CongratulationsPopup.swift
│               ├── DidYouKnowPopup.swift
│               ├── ExitConfirmationPopup.swift
│               ├── OceanFactPopup.swift
│               ├── SeaCreatureWarningPopup.swift
│               └── ToolInfoPopup.swift
│
├── SharedUI/                                   (Reusable UI components across features)
│   ├── Buttons/
│   │   ├── BackButton.swift
│   │   ├── IconCircleButton.swift
│   │   ├── PopupButton.swift
│   │   ├── SpeakerButton.swift
│   │   └── LeftToolbarButton.swift
│   ├── Cards/
│   │   ├── CardHeaderPill.swift
│   │   └── ChapterHintBubble.swift
│   ├── Toolbars/
│   │   └── LeftToolbar.swift
│   └── Effects/
│       └── CelebrationBurst.swift
│
└── Resources/                                  (bundled assets)
    ├── Audio/
    │   ├── beachtrack.mp3
    │   └── bubblesound.mp3
    ├── Fonts/
    │   └── Baloo2-VariableFont_wght.ttf
    └── Video/
        └── av-oceanep1.mp4
Packages/
├── TekaraAssets/                                (TekaraAssets.rkassets/, tekaraAssetsBundle)
├── ThumbStickView/                              (on-screen joystick)
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
