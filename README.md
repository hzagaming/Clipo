# Clipo

Clipo is a lightweight macOS multi-slot clipboard tool that lets users save selected text into shortcut slots and copy any saved slot back to the system clipboard using global hotkeys.

**Clipo** 是一个轻量级 macOS 多槽位剪贴板工具。用户可以用全局快捷键把不同内容保存到不同槽位，并在需要时快速复制指定 slot 到系统剪贴板。

---

## Features

- **Menu Bar App**: Runs entirely in the macOS menu bar with no Dock icon by default.
- **9 Fixed Slots**: Save text to Slot 1–9 with instant global shortcuts.
- **Quick Paste**: Copy any saved slot to the system clipboard with `Option + number`, then paste it with `Command + V`.
- **Clipboard History**: Automatically saves every slot item into a local history (up to 200 items).
- **Search Panel**: Spotlight-style panel to browse slots and history, searchable in real time.
- **Privacy First**:
  - No background clipboard monitoring.
  - Ignores sensitive apps (1Password, Bitwarden, Keychain Access, etc.) by default.
  - All data stored locally in JSON. No network, no cloud, no analytics.
- **Restore Clipboard**: Optionally restore your previous clipboard contents after saving or pasting.
- **Launch at Login**: Built-in support for starting with macOS (macOS 13+).

---

## Hotkeys

| Action | Shortcut |
|---|---|
| Save selected text to Slot 1 | `⌥⌘1` (Option + Command + 1) |
| Save selected text to Slot 2 | `⌥⌘2` |
| Save selected text to Slot 3 | `⌥⌘3` |
| Save selected text to Slot 4 | `⌥⌘4` |
| Save selected text to Slot 5 | `⌥⌘5` |
| Save selected text to Slot 6 | `⌥⌘6` |
| Save selected text to Slot 7 | `⌥⌘7` |
| Save selected text to Slot 8 | `⌥⌘8` |
| Save selected text to Slot 9 | `⌥⌘9` |
| Copy Slot 1 to clipboard | `⌥1` (Option + 1), then press `⌘V` to paste |
| Copy Slot 2 to clipboard | `⌥2` |
| Copy Slot 3 to clipboard | `⌥3` |
| Copy Slot 4 to clipboard | `⌥4` |
| Copy Slot 5 to clipboard | `⌥5` |
| Copy Slot 6 to clipboard | `⌥6` |
| Copy Slot 7 to clipboard | `⌥7` |
| Copy Slot 8 to clipboard | `⌥8` |
| Copy Slot 9 to clipboard | `⌥9` |
| Open Clipo Panel | `⌥Space` (Option + Space) |

> **Note:** Saving selected text requires Accessibility permission so Clipo can simulate `Command + C`. Copying an existing slot with `Option + number` only writes to the system clipboard.

---

## Installation

### Download (Recommended)
1. Go to the [Releases](https://github.com/hanazar/clipo/releases) page.
2. Download the latest `Clipo.dmg`.
3. Open the `.dmg` and drag **Clipo** into your **Applications** folder.
4. Launch Clipo from Applications.
5. Grant **Accessibility** permission when prompted (see below).

### Build from Source
Requires **macOS 13.0+** and **Xcode 14+**.

```bash
git clone https://github.com/hanazar/clipo.git
cd clipo/Clipo
open Clipo.xcodeproj
```

1. In Xcode, select the **Clipo** target.
2. Ensure **Signing & Capabilities** has a valid Team or is set to "Sign to Run Locally".
3. Add `Carbon.framework` and `ServiceManagement.framework` in **General > Frameworks**.
4. Set **Build Settings > LSUIElement** to `YES`.
5. Press `⌘R` to run.

---

## Permissions

Clipo requires **Accessibility** permission to send global copy (`⌘C`) and paste (`⌘V`) events on your behalf.

**How to enable:**
1. When Clipo first launches, click **"Open System Settings"** in the permission window.
2. Navigate to **Privacy & Security > Accessibility**.
3. Click the **+** button and add **Clipo**.
4. **Quit and restart** Clipo.

If you run Clipo directly from Xcode, you may need to add the specific build product path (inside `DerivedData`) to Accessibility. For convenience, you can find the built app by right-clicking the Clipo product in Xcode > Show in Finder.

---

## Privacy Policy

Clipo takes your privacy seriously:

- **Local Only**: All clipboard data is saved to a local JSON file (`~/Library/Application Support/Clipo/clips.json`).
- **No Upload**: Clipo does not upload, sync, or transmit any clipboard data.
- **No Analytics**: Clipo does not use analytics, telemetry, or crash reporters.
- **No Network**: Clipo does not connect to any remote server.
- **No Background Monitoring**: V1 does not observe the system pasteboard in the background. Data is only read when you press a Clipo hotkey.
- **Sensitive App Protection**: By default, Clipo refuses to save text from password managers and keychain utilities.

---

## Data Storage

Clipo stores everything locally:

```
~/Library/Application Support/Clipo/
├── clips.json                    # Main data file (slots, history, settings)
└── clips_corrupted_backup.json   # Auto-generated if clips.json is corrupted
```

You can open this folder directly from **Settings > Data > Open Data Folder**.

---

## Building a Release DMG

### Method 1: Manual with hdiutil

```bash
# 1. Build and archive
xcodebuild archive \
  -project Clipo.xcodeproj \
  -scheme Clipo \
  -archivePath build/Clipo.xcarchive

# 2. Extract the .app
cp -R build/Clipo.xcarchive/Products/Applications/Clipo.app ./Clipo.app

# 3. Prepare DMG contents
mkdir -p Clipo-DMG
cp -R Clipo.app Clipo-DMG/
ln -s /Applications Clipo-DMG/Applications

# 4. Create compressed DMG
hdiutil create -volname "Clipo" -srcfolder Clipo-DMG -ov -format UDZO Clipo.dmg
```

### Method 2: create-dmg (Better UX)

Install [create-dmg](https://github.com/create-dmg/create-dmg):

```bash
brew install create-dmg
```

Then run:

```bash
create-dmg \
  --volname "Clipo" \
  --window-size 800 400 \
  --icon-size 100 \
  --icon "Clipo.app" 200 185 \
  --app-drop-link 600 185 \
  "Clipo.dmg" \
  "Clipo.app"
```

This produces a draggable `.dmg` with a background window, app icon, and Applications folder alias.

### Code Signing & Notarization (For Distribution)

If you plan to distribute outside the Mac App Store:

1. Join the [Apple Developer Program](https://developer.apple.com/programs/) ($99/year).
2. Obtain a **Developer ID Application** certificate.
3. Sign the app:
   ```bash
   codesign --deep --force --verify --verbose \
     --sign "Developer ID Application: Your Name (TEAM_ID)" \
     Clipo.app
   ```
4. Notarize:
   ```bash
   xcrun notarytool submit Clipo.dmg \
     --apple-id "your@email.com" \
     --team-id "TEAM_ID" \
     --password "app-specific-password" \
     --wait
   ```
5. Staple the ticket:
   ```bash
   xcrun stapler staple Clipo.dmg
   ```

> If the app is **unsigned**, users must right-click the app and select **Open** the first time they run it.

---

## GitHub Release Workflow

1. **Create a GitHub repository** named `clipo` (or `clipo-mac`).
2. Push your code:
   ```bash
   git init
git add .
   git commit -m "Initial commit"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/clipo.git
   git push -u origin main
   ```
3. **Tag a version**:
   ```bash
   git tag -a v0.1.0 -m "First MVP release"
   git push origin v0.1.0
   ```
4. Go to **GitHub > Releases > Draft a new release**.
5. Choose the tag `v0.1.0`.
6. Upload `Clipo.dmg` as a release asset.
7. Publish the release.

### Suggested Versioning

| Version | Milestone |
|---|---|
| v0.1.0 | MVP: slots, hotkeys, history, panel |
| v0.2.0 | Customizable hotkeys, improved search |
| v0.3.0 | Import/export JSON, auto-cleanup policies |
| v0.4.0 | Rich text/images support, Dock icon toggle |
| v1.0.0 | Stable release, signed & notarized DMG |

---

## Roadmap

- [x] Menu bar integration
- [x] 9-slot save & paste with global hotkeys
- [x] Clipboard history with search
- [x] Accessibility permission handling
- [x] Local JSON persistence
- [x] Sensitive app blacklist
- [ ] Custom hotkey configuration
- [ ] Import / Export JSON
- [ ] Auto-delete old unpinned history
- [ ] Image & file support
- [ ] Apple Silicon & Intel universal binary

---

## License

MIT License. See [LICENSE](LICENSE) for details.

---

## What's New in v1.7.1

- **Granular Sound Effects Settings**: New dedicated Sound Effects tab in Settings with per-action toggles (Copy, Paste, Save, Open, Close, Error, Reset) plus a master switch and volume slider with live preview.
- **Sound Consistency Audit**: Added missing error sounds on permission-denied paths (save hotkey, panel paste, menu-bar paste, hotkey registration).
- **Destructive-action sounds**: Clear History, Reset Slots, and Reset All Data now play the Reset sound when confirmed.
- **Volume guard**: Sounds are now skipped when volume is set to 0 instead of playing silently.
- **Removed duplicate toggle**: The legacy Sound Effects toggle has been removed from General settings and consolidated into the new dedicated tab.
- **Critical UI fix**: Fixed the master sound toggle becoming permanently disabled when turned off in the SFX tab.

## Version History

### v1.7.1
- Granular Sound Effects settings tab with per-action toggles and volume control
- Add missing error sounds across permission-denied paths
- Play reset sound on destructive settings actions
- Skip sound playback when volume is zero
- Remove duplicate sound toggle from General tab
- Fix master toggle disabled trap in SFX tab

### v1.7.0
- 10-language i18n system (en, zh-Hans, zh-Hant, ja, ko, fr, de, es, ru, pt)
- Language picker in Settings with instant switching
- Localize all UI surfaces (panel, settings, menu bar, notifications, onboarding)

### v1.6.8
- Auto-hide panel on click-outside
- Fix Settings tab transition flicker
- Unify Copy behavior (context menu vs row click)
- Fix menu-bar re-auth feedback Toast
- Trigger native accessibility permission dialog
- Auto-show panel after first-launch permission grant

### v1.6.7
- Fix `finishLaunch` guard blocking menu-bar re-auth feedback
- Add `requestAccessibilityPermission()` to PermissionView

### v1.6.6
- Add unified `finishLaunch(showPanel:showReadyToast:)` method
- Auto-show ClipoPanel after permission grant on first launch
- Fix `windowWillClose` falsely treating programmatic close as user skip
- Fix `showPermissionWindowFromMenu()` to also start monitoring
- Remove dead `onPermissionGranted` parameter from PermissionView

### v1.6.5
- Fix Open Panel hotkey sound inconsistency (sound now tied to actual show/hide)
- Fix `showPanel()` fade-in animation (alpha 0→1)
- Fix Escape key double `playClose()`
- Remove `tearDown()` `contentView = nil` crash risk
- Cap Toast queue at 10
- Remove unused `ClipboardViewModel` dead code
- Fix `onSaveSlot` app-detection race condition

### v1.6.4
- Fix orphan permission window (don't nil delegate before `close()`)
- StorageService: notify on load/save failures
- Fix `\r\n` double-space in `StringPreviewUtility`
- `clearHistory` now calls `trimHistory()`

### v1.6.3
- Fix `hidePanel` completion block race (`guard self.isHiding`)
- `load()` calls `trimHistory()`
- Dock icon visible → click opens panel
- Import applies Dock policy immediately

### v1.6.2
- Paste permission check before sound
- Paste failure keeps panel open
- ToastWindow init failure clears queue
- `\n`/`-`/`\r\n` unified handling

### v1.6.1
- Permission window replacement (no false Skip)
- `windowWillClose` removes `contentView = nil`
- Panel close cleans `panelWindow` reference

### v1.6.0
- Paste permission check before sound
- Remove `contentView = nil` in `windowWillClose`
- Import JSON → `registerAllHotkeys()`

### v1.5.3
- Close button (X) on permission window = Skip
- Prevent duplicate permission windows
- Max History change triggers `trimHistory`

### v1.5.2
- PermissionView menu-bar guidance badge
- Skip Toast with menu-bar hint
- Menu "Request Accessibility Permission…" entry

### v1.5.1
- "Skip for now" button on permission window
- Delayed permission check

### v1.5.0
- Toast queue system (no overwriting)
- Error/success visual distinction (🟠/🟢)
- Multi-display Toast follows mouse
- Panel non-resizable
- Click row → Copy + close
- Dynamic empty-state hints
- Cmd+P pin (exact modifier detection)
- Paste updates `lastUsedAt`

### v1.4.2 and earlier
- 9-slot clipboard, global hotkeys, history, search panel
- Settings, pin/unpin, context menus
- Configurable hotkeys, live Dock toggle

## Acknowledgements

Built with Swift, SwiftUI, AppKit, and Carbon. No third-party dependencies.
