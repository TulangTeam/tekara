# Tekara design guidelines
### Chunky, tactile UI kit — for ages 4–8

This document defines the shared visual and interaction language used across
Tekara's UI components (buttons, cards, badges, dialogue). Its purpose is to
keep every screen speaking the same "squishy toy" language even as new
screens get built by different people, and to give new components a
checklist to follow instead of reinventing the mechanic each time.

---

## 1. Design principles

1. **Everything tappable looks pressable.** If a child can tap it, it must
   have visible depth at rest and visibly compress on tap. Depth is not
   decoration here — it's the primary signal for "this is a button," since
   pre-readers can't rely on labels alone.
2. **Depth comes from a solid base layer, never a blurred shadow.**
   `.shadow()` reads soft and floaty. A flat-colored duplicate shape sitting
   directly behind/under the front face reads like a real 3D object sitting
   on a table. This is the single most important rule in this kit — see
   [Section 3](#3-the-squish-mechanic).
3. **Color encodes state, not decoration.** Gold = next/begin, green =
   available/complete, gray = locked. Colors should never be reassigned
   arbitrarily per-screen — see [Section 4](#4-color-tokens).
4. **Big, forgiving touch targets.** Minimum 48×48pt hit area, even when the
   visual element is smaller — small thumbs miss small targets.
5. **Motion confirms, it doesn't decorate.** Every animation should answer
   "did my tap register?" (press-and-release) or "what's next?" (entrance
   sequencing). Avoid animation that exists only for flourish.
6. **Respect Reduce Motion.** Every spring/bounce entrance must have a static
   fallback. This is a real accessibility requirement, not optional polish.

---

## 2. Typography

| Role | Font | Notes |
|---|---|---|
| Display / headings / buttons / titles | **Baloo 2**, bold | Rounded terminals, reads as friendly and toy-like. Used for anything a child reads as a "label" — button text, card titles, pill/badge text. |
| Body / dialogue text | **Baloo 2**, bold (currently) | Used for in-story dialogue; kept bold throughout for legibility at a distance and for early readers. |
| Never use system default (San Francisco) for player-facing text | — | Breaks the toy-like tone immediately. |

**Sizes in use:**

| Context | Size |
|---|---|
| Primary CTA (Play) | 28pt |
| Secondary capsule button (Next/Back/Begin) | 16–18pt |
| Episode card title | 14pt |
| Dialogue text | 18–20pt |
| Floating title pill (e.g. "Prologue") | 22pt |
| Speaker tag (if used) | 14pt |

---

## 3. The squish mechanic

This is the core interaction pattern. Every tappable shape in Tekara —
capsule buttons, icon buttons, episode-card buttons, whole cards — is built
from the same two-layer structure.

### Structure

```
ZStack(alignment: .bottom) {
    // 1. BASE — a solid-fill duplicate of the shape, same size, sits still.
    //    This is the "edge" — a darker/muted version of the front color.
    Shape().fill(edgeColor)

    // 2. FACE — the visible front layer: color, border, label/icon.
    //    At rest it's offset UP by `pressDepth`, exposing the base as a lip.
    //    On press it animates DOWN to offset 0, flush with the base.
    Shape()
        .fill(topColor)
        .overlay(content)
        .offset(y: isPressed ? 0 : -pressDepth)
}
.frame(height: baseHeight + pressDepth)   // extra height so the lip isn't clipped
.onTapGesture {
    withAnimation(.easeOut(duration: 0.06)) { isPressed = true }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.08) {
        withAnimation(.easeOut(duration: 0.08)) { isPressed = false }
        action()
    }
}
```

### Rules

- **Never use `ScaleButtonStyle` or `.shadow()` for tappable elements.**
  Scaling reads as a bounce, not a press. Blur reads as ambient lighting,
  not a physical edge. Only the offset technique above communicates "this
  object has a bottom edge and I just pushed it into that edge."
- **`pressDepth` scales with the button's importance/size**, not a fixed
  global constant:
  | Component | pressDepth |
  |---|---|
  | Primary CTA (Play) | 6pt |
  | Toolbar icon button | 5pt |
  | Dialogue Back/Next capsule | 5pt |
  | Episode card status button | 4pt |
  | Episode card itself (static, non-interactive depth) | 6pt |
  | Dialogue card itself (static, non-interactive depth) | 8pt |
- **Cards get the same base/face structure even though they're not tappable
  as a whole.** This keeps every surface in the kit visually consistent —
  a card without a lip looks flat and out of place next to buttons that have
  one. Apply the base as a `.background()` on the face (sized automatically
  to match), never as a separate `ZStack` sibling with its own frame — a
  sibling with no explicit size will expand to fill available space, which
  is the most common bug when adding this pattern to a new component.
- **Edge color is not just "the top color darkened."** It should sit in the
  same hue family but be tuned so it reads as a distinct physical layer, not
  a gradient. Use the [color pairs](#4-color-tokens) below directly rather
  than computing edge = top × 0.7 programmatically — hand-tuned pairs read
  better than formulaic darkening, especially for yellow/gold where
  naive darkening turns muddy brown instead of a rich amber edge.
- **Press timing:** press-in `0.06s easeOut`, hold, release `0.08s easeOut`,
  action fires on release. Don't fire the action on press-down — the visual
  squish needs to be visible before the screen transitions away.

---

## 4. Color tokens

Each semantic color is a **pair**: a face color and an edge color. Always
use both together — never apply a face color without its matching edge.

| Token | Face (top) | Edge (base/lip) | Used for |
|---|---|---|---|
| `success` (green) | `rgb(0.37, 0.82, 0.41)` | `rgb(0.16, 0.55, 0.19)` | Play, completed episodes, "Next" dialogue action |
| `attention` (gold) | `rgb(0.90, 0.82, 0.15)` | `rgb(0.62, 0.51, 0.00)` | "Begin" — the next episode to play |
| `neutral` (gray) | `Color.gray` | `rgb(0.35, 0.35, 0.35)` | Locked state, "Back" action |
| `info` (blue) | `rgb(0.11, 0.44, 0.55)` avatar / `rgb(0.20, 0.44, 0.76)` title pill | — (flat, non-interactive) | Character avatars (narrator/system), floating title pills |
| `accent-teal` | `rgb(0.36, 0.75, 0.67)` | — | Speaker identity (e.g. Tori), used as ring/tag color per character |

**Card / background tones:**

| Token | Value | Used for |
|---|---|---|
| Dialogue card face | `Color.white` | Readable text surface |
| Dialogue card edge/border | `rgb(0.95, 0.87, 0.68)` | Lip + border, warm cream |
| Episode card face | `PopupStyle.cardBackground` | Card interior |
| Body text on light cards | `rgb(0.20, 0.30, 0.36)` | Dialogue/body copy — a soft near-black, never pure black |

**Rule:** locked elements use `saturation(0)` **in addition to** reduced
opacity (~0.75), not opacity alone. Opacity-only dimming still shows
saturated color underneath and reads as "dim" rather than "unavailable" —
important for kids who tend to repeatedly tap things that don't respond.

---

## 5. Component inventory

| Component | Shape | Depth? | Notes |
|---|---|---|---|
| **Primary CTA** (Play) | Capsule, white 4pt stroke | Yes, 6pt | One per screen max. Largest button in the kit. |
| **Capsule action button** (Next/Back/Begin/Play-episode) | Capsule, white 3pt stroke | Yes, 4–5pt | Shared `SquishCapsuleButton` component — one implementation, colors/text passed in. |
| **Icon/toolbar button** | Circle, white face, pale rim | Yes, 5pt | 52pt diameter face; rim color is a *light* neutral (not dark) since these sit on saturated backgrounds. |
| **Episode card** | Rounded rect, 24pt corner, colored border matching status | Yes, 6pt (card) + 4pt (its button) | Border color = status color. The currently-playable card gets a pulsing sticker badge in the corner, not just a border color change — color alone is not a strong enough signal at this age. |
| **Dialogue card** | Rounded rect, 24pt corner, cream border | Yes, 8pt | Floating title pill (flat, no depth — it's not tappable) + avatar identity ring + body text. |
| **Speaker identity** | Avatar circle + colored ring | No (not tappable) | Ring color = character's assigned tag color. Characters without art (e.g. Narrator) fall back to a generic icon avatar with a distinct neutral ring — never leave a ring color unset, or a missing-asset bug becomes indistinguishable from an intentional narrator style. |
| **Star rating** | Row of 3 star icons in a faint pill | No | Filled = gold token, empty = neutral gray. |
| **Progress dots** | Row of filled/outline circles | No | Filled = success green, current = gold with soft halo, upcoming = neutral. |

---

## 6. Motion

| Interaction | Animation | Duration |
|---|---|---|
| Button press-in | `.easeOut` | 0.06s |
| Button release | `.easeOut` | 0.08s |
| Screen entrance (title/hero art) | `.spring(response: 0.7, dampingFraction: 0.6)` | — |
| Screen entrance (secondary element, e.g. dialogue bubble) | `.spring(response: 0.8, dampingFraction: 0.6)`, staggered ~0.2s after hero | — |
| "Next episode" pulse badge | `.easeInOut(duration: 0.9).repeatForever(autoreverses: true)`, scale 0.95 → 1.12 | continuous |
| Mute/unmute icon wiggle | `.spring(response: 0.3, dampingFraction: 0.6)`, offset ±3pt | — |

**Always gate spring/bounce entrances behind
`@Environment(\.accessibilityReduceMotion)`.** When enabled, set all
animated values to their final state immediately — no fade, no delay.

---

## 7. Sizing & spacing

| Token | Value |
|---|---|
| Card corner radius | 24pt |
| Button corner style | Capsule (fully rounded) or Circle |
| Border stroke, buttons | 3pt white |
| Border stroke, cards | 4pt (color-coded by status) |
| Minimum tappable area | 48×48pt, even if the visual is smaller |
| Toolbar icon button diameter | 52pt |
| Avatar diameter (dialogue) | 56–60pt |
| Episode card | 160×340pt |

---

## 8. Do / don't

| Do | Don't |
|---|---|
| Build every tappable shape from the base + face two-layer pattern | Use `.shadow()` or `ScaleButtonStyle` for anything tappable |
| Pair every face color with a hand-tuned edge color | Compute edge color as a flat opacity/brightness multiplier |
| Give the "next" episode card a distinct animated cue (badge), not just a border color | Rely on border color alone to signal "this one's next" |
| Desaturate **and** dim locked elements | Dim locked elements with opacity only |
| Reuse `SquishCapsuleButton` / a shared icon-button base across screens | Hand-roll a new button implementation per screen |
| Gate all entrance animation behind Reduce Motion | Force spring/bounce on every user regardless of accessibility settings |
| Keep card depth static (no press offset) since cards aren't the tap target — only their internal button is | Add a press offset to a whole card when only one button inside it is actually tappable |

---

## 9. Open items to formalize

- [ ] Extract `SquishCapsuleButton` and a circular `SquishIconButton` into one
      shared component file, imported everywhere, instead of private copies
      per screen.
- [ ] Decide whether locked/narrator/no-avatar states need an explicit
      "missing asset" fallback distinct from an intentional neutral style.
- [ ] Confirm whether avatar-only speaker identity (no name pill) provides
      enough accessibility support for the 4–8 range, or whether a bare
      caption-style name should sit above dialogue text as a middle ground.