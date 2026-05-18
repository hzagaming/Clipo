# Clipo v1.7.1 — Sound You Can Control

**Every beep, click, and chime — now fully customizable.**

---

## What's New

### 🔊 Granular Sound Effects Settings
A brand-new **Sound Effects** tab in Settings gives you complete control over Clipo's audio feedback.

| Control | Description |
|---|---|
| **Master Switch** | Enable or disable all sounds globally |
| **Volume Slider** | 0–100 % with live preview on release |
| **Copy** | Tink — when copying an item |
| **Paste** | Purr — when pasting into the frontmost app |
| **Save to Slot** | Pop — when saving to a numbered slot |
| **Open Panel** | Glass — when the Clipo panel appears |
| **Close Panel** | Funk — when the panel hides |
| **Error** | Sosumi — on permission denied or failure |
| **Reset** | Submarine — when clearing history or resetting slots |

Turn off the master switch and every sub-toggle dims instantly. Drag the volume slider and hear the preview to find your perfect level.

### 🔧 Sound Consistency & Reliability
- **Missing error sounds fixed** — permission-denied paths (save hotkey, panel paste, menu-bar paste, hotkey registration) now consistently play the Error sound.
- **Destructive-action feedback** — Clear History, Reset Slots, and Reset All Data play the Reset sound on confirmation.
- **Zero-volume skip** — When the slider is at 0 %, sounds are skipped entirely instead of playing silently.
- **No more disabled trap** — The master toggle in the SFX tab can no longer get stuck in the off position.

### 🧹 UI Polish
- Removed the legacy Sound Effects toggle from **General** settings; all sound controls now live in their dedicated tab.

---

## Download

**[⬇ Clipo-v1.7.1.dmg](https://github.com/hanazar/clipo/releases/download/v1.7.1/Clipo.dmg)**

Requires **macOS 13.0+**.

---

## Install

1. Download `Clipo.dmg`.
2. Drag **Clipo** into your **Applications** folder.
3. Launch and grant **Accessibility** permission when prompted.

---

## Full Changelog

- Add dedicated Sound Effects settings tab with master toggle, volume slider, and 7 per-action toggles
- Add `playPreview()` to SoundService for volume-slider feedback
- Guard SoundService against zero-volume playback
- Add missing `playError()` calls in permission-denied paths (HotkeyService, ClipoPanelView, PasteService)
- Add `playReset()` to destructive settings actions (clear history, reset slots, reset all data)
- Fix SFX tab master toggle disabled trap
- Remove redundant Feedback section from General settings tab

---

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
