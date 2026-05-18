# Clipo v1.7.2 — Search That Thinks in Categories

**Search results, now organized by type.**

---

## What's New

### 🔍 Categorized Search Results
The Clipo panel search no longer dumps everything into a flat list. Results are now grouped by content type:

```
Search: "report"

Text (2)
├── report draft v2
└── weekly report summary

File (1)
└── report.pdf

URL (1)
└── https://example.com/report
```

Each type gets its own section header with a count badge. Keyboard navigation (↑↓) and scroll-to-selection work seamlessly across sections.

### 🔧 Search Reliability
- **Stable view identities** — typing no longer causes SwiftUI duplicate-ID warnings or view flashes.
- **Dedicated empty state** — when a query returns nothing, you see "No matching results" instead of the full onboarding tutorial.
- **Duplicate UUID guard** — history items now always receive a fresh UUID on insertion, preventing rare but possible ID collisions in long sessions.

### 🌍 Localization Polish
- **Type badges localized** — the small labels on history rows (URL, Code, Text, Image, File, Rich, Data) now translate into all 10 supported languages.
- **Cleaned orphaned keys** — removed unused `sectionFeedback`, `soundEffectsTitle`, and `soundEffectsSubtitle` entries from the localization table.

### ♿ Accessibility & Performance
- **SFX volume slider** no longer triggers a full JSON store write on every drag tick; it only persists when you release.
- **VoiceOver labels** added to the SFX volume slider and all 7 per-sound toggles.
- **Menu-bar empty-slot copy** now shows the same toast notification as the paste action.

---

## Download

**[⬇ Clipo-v1.7.2.dmg](https://github.com/hanazar/clipo/releases/download/v1.7.2/Clipo.dmg)**

Requires **macOS 13.0+**.

---

## Install

1. Download `Clipo.dmg`.
2. Drag **Clipo** into your **Applications** folder.
3. Launch and grant **Accessibility** permission when prompted.

---

## Full Changelog

- Group search results by `ClipType` with per-type section headers
- Fix `PanelListItem` duplicate-ID instability during search by moving from positional `.id(globalIndex)` to stable `.id(row.id)`
- Fix `scrollTo` to target row identity instead of raw index
- Fix `ClipStore.addToHistory` to generate fresh UUIDs for new history entries
- Add `searchEmptyView` with localized `searchNoResults` key (10 languages)
- Localize `HistoryRowView` type badges via `ClipType.displayName`
- Use local `@State` for SFX volume slider to avoid `didSet` → `save()` storm while dragging
- Add `.accessibilityLabel` to SFX volume slider and per-sound toggles
- Add missing empty-slot copy notification in menu-bar `slotCopyClicked`
- Guard `handleKeyEvent` against empty navigable lists
- Remove orphaned localization keys from deleted Feedback section

---

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
