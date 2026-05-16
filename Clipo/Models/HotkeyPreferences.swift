import Foundation

/// User-configurable global hotkey modifiers.
/// In v1 the digit keys (1-9) and their key-codes remain fixed;
/// only the modifier masks and the open-panel key are customisable.
struct HotkeyPreferences: Codable, Equatable {
    /// Key-code for the "Open Panel" shortcut (default: Space → 49).
    var openPanelKeyCode: UInt32 = 49
    /// Modifier mask for the "Open Panel" shortcut (default: Option).
    var openPanelModifiers: UInt32 = 0x0800 // optionKey

    /// Modifier mask shared by all "Save to Slot" shortcuts (default: Cmd+Option).
    var saveSlotModifiers: UInt32 = 0x0900 // cmdKey | optionKey

    /// Modifier mask shared by all "Paste from Slot" shortcuts (default: Ctrl+Option).
    var pasteSlotModifiers: UInt32 = 0x1800 // controlKey | optionKey

    // MARK: - Preset helpers

    static let modifierPresets: [(label: String, mask: UInt32)] = [
        ("⌥ Option",       0x0800),
        ("⌘⌥ Cmd+Option",  0x0900),
        ("⌃⌥ Ctrl+Option", 0x1800),
        ("⌘⇧ Cmd+Shift",   0x0300),
        ("⌃⇧ Ctrl+Shift",  0x1200)
    ]

    static let openPanelKeyPresets: [(label: String, code: UInt32)] = [
        ("Space",   49),
        ("Return",  36),
        ("Tab",     48),
        ("` Grave", 50),
        ("Escape",  53)
    ]

    /// Human-readable string for a modifier mask (e.g. "⌘⌥").
    static func label(forModifiers mask: UInt32) -> String {
        modifierPresets.first { $0.mask == mask }?.label ?? "Custom"
    }

    /// Human-readable string for a key-code (e.g. "Space").
    static func label(forKeyCode code: UInt32) -> String {
        openPanelKeyPresets.first { $0.code == code }?.label ?? "Key \(code)"
    }
}
