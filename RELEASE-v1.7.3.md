# Clipo v1.7.3 — Reliability & Polish

**Search grouping hardened, edge cases eliminated, accessibility improved.**

---

## What's New

### 🔍 Search Grouping Hardened
The categorized search introduced in v1.7.2 has been refined for correctness:
- **Precise offsets**: Replaced the dictionary-based `historySectionIndexMap` with pre-computed `groupedHistoryOffsets`, eliminating any chance of a fallback-to-zero selection mismatch.
- **History mutation safety**: Keyboard selection now auto-clamps when the clipboard history changes underneath an active search (new copy, trim, import).
- **Trim on reorder**: The duplicate-history reordering path now correctly invokes `trimHistory()`, keeping pinned items properly sorted.

### 🔊 SFX Polish
- **Volume rounding**: The percentage label now rounds correctly — 0.999 shows **100%** instead of 99%.
- **External sync**: The volume slider automatically syncs if the volume is changed externally (e.g., via JSON import).
- **Master toggle VoiceOver**: The "Enable Sound Effects" master switch now has a proper accessibility label.

### 🛡️ Crash & Edge-Case Fixes
- **Headless Mac safety**: Removed the `NSScreen.screens.first!` force-unwrap in toast positioning. On headless or remote-desktop setups, the toast now falls back to a default frame instead of crashing.
- **Filter pill contrast**: Selected filter pills use adaptive `.primary` text instead of hardcoded white, improving visibility with light accent colors.
- **History limit safety**: `maxHistoryItems` is now clamped to ≥0 when decoding settings from disk.
- **Dead code removed**: Deleted the unused `MenuBarView.swift` placeholder.

---

## Download

**[⬇ Clipo-v1.7.3.dmg](https://github.com/hanazar/clipo/releases/download/v1.7.3/Clipo.dmg)**

Requires **macOS 13.0+**.

---

## Install

1. Download `Clipo.dmg`.
2. Drag **Clipo** into your **Applications** folder.
3. Launch and grant **Accessibility** permission when prompted.

---

## Full Changelog

- Replace `historySectionIndexMap` with `groupedHistoryOffsets` for exact selection indexing
- Fix `addToHistory` duplicate path skipping `trimHistory()`
- Auto-clamp `selectedIndex` on `store.$history` mutations
- Fix volume percentage truncation → rounding (`Int((value * 100).rounded())`)
- Sync `volumeSliderValue` via `.onChange(of: store.settings.soundVolume)`
- Add `.accessibilityLabel(title)` to `ToggleRow` master switch
- Remove `NSScreen.screens.first!` crash risk with safe fallback frame
- Delete unused `MenuBarView.swift`
- Use `Color.primary` for selected `FilterPill` text
- Clamp `maxHistoryItems` to non-negative in `AppSettings` decoder

---

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
