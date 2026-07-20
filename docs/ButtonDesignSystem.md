# Tekara Button Design System

## Overview

Chunky, tactile components designed for little thumbs (ages 4–8). Every button communicates "press me" through physical metaphor — depth, shadow, press response — not just color.

---

## Core Philosophy

**3D Pill / 3D Circle** — buttons look like physical objects you can press, not flat UI elements. A raised top face drops down when pressed, exposing the edge/rim beneath. This mimics real buttons, doorknobs, and game controllers familiar to young children.

**Why it works for ages 4–8:**
- **Depth = affordance.** Kids don't read tooltips. A button that looks raised says "press" without words.
- **Big targets.** 52pt circles. No pixel-perfect tap accuracy needed.
- **Satisfying feedback.** Press-drop animation + SFX confirms the action happened — critical for pre-readers who can't read "Success!"
- **Consistent across all buttons.** One visual language everywhere.

---

## Anatomy

### 3D Circle Button

```
┌─────────────────────┐
│    white circle     │  ← Top face (raised at rest)
│   stroke (yellow)   │
│      SF Symbol       │
└─────────────────────┘
 ┌───────────────────┐
 │  edgeColor rim    │  ← Base layer (fixed, peeks out below)
 └───────────────────┘
        ↓ press
     flush (edge fully hidden)
```

**Parts:**
- **Base layer** — `edgeColor` fill, fixed position at bottom of the ZStack. This is what peeks out below the top face, creating the 3D rim.
- **Top face** — white circle with a colored stroke (yellow) and SF Symbol. Offset up by `pressDepth` at rest, drops to `y: 0` on press.
- **Frame** — height = `size + pressDepth` to accommodate both layers.
- **Press animation** — `easeOut(duration: 0.06)` down, `easeOut(duration: 0.08)` up. Fast and snappy.

### 3D Capsule Button (PlayButton)

Same principle, capsule shape instead of circle. Used for the main CTA ("PLAY").

**Parts:**
- **Base layer** — `buttonGreenDark` capsule, fixed.
- **Top face** — `buttonGreen` capsule, offset up by `pressDepth` at rest.
- **Content** — Baloo 2 font, bold white text.

---

## Color Tokens

| Token | Hex | Usage |
|-------|-----|-------|
| `iconColor` | `#1C807F` | SF Symbol fill |
| `edgeColor` | `#D0E0E6` | Base rim |
| `buttonGreen` | `#5ED169` | Play button top face |
| `buttonGreenDark` | `#298C30` | Play button base edge |
| `stroke` | `Color.yellow` | Top face border |

All colors are defined as private constants inside each view, not a shared theme — keeping components self-contained.

---

## Animation Specs

| Property | Rest | Press | Release |
|----------|------|-------|---------|
| Top face offset | `-pressDepth` | `0` | `-pressDepth` |
| Down duration | — | `0.06s` | — |
| Down curve | — | `easeOut` | — |
| Up duration | — | — | `0.08s` |
| Up curve | — | — | `easeOut` |

The press-down is intentionally faster than release — feels snappy, not limp.

---

## Sound Feedback

Every button tap plays `bubblesound.mp3` via `AudioManager`. For pre-readers, the sound IS the confirmation that the action worked.

```swift
audioManager?.playSFX(named: "bubblesound.mp3")
```

---

## Component Checklist

- [ ] Base layer (`edgeColor`) always rendered first in ZStack
- [ ] Top face offset by `pressDepth` at rest
- [ ] `.contentShape(Rectangle())` for full tap target (not just the icon)
- [ ] SFX on tap via `audioManager?.playSFX`
- [ ] Press animation before action, release animation after short delay
- [ ] `.frame(height: size + pressDepth)` to avoid clipping
- [ ] SF Symbol sized with `.font(.system(size:, weight:))` for crisp rendering

---

## File Reference

| Component | Shape | Usage |
|-----------|-------|-------|
| `LeftToolbarButton.swift` | Circle | Settings, music, help toolbar |
| `SpeakerButton.swift` | Circle | SFX mute toggle |
| `BackButton.swift` | Circle | Navigation back |
| `PlayButton.swift` | Capsule | Main CTA |
