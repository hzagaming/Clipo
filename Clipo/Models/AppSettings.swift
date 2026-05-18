struct AppSettings: Codable, Equatable {
    var launchAtLogin: Bool = false
    var restoreClipboardAfterPaste: Bool = true
    var restoreClipboardAfterSave: Bool = true
    var maxHistoryItems: Int = 200
    var ignoreSensitiveApps: Bool = true
    var sensitiveAppBundleIdentifiers: [String] = [
        "com.1password.1password",
        "com.bitwarden.desktop",
        "com.apple.keychainaccess",
        "com.dashlane.dashlanemac",
        "org.keepassx.keepassxc"
    ]
    var autoDeletePolicy: AutoDeletePolicy = .never
    var showDockIcon: Bool = true
    var soundEnabled: Bool = true
    var soundVolume: Double = 0.7
    var soundSaveEnabled: Bool = true
    var soundCopyEnabled: Bool = true
    var soundPasteEnabled: Bool = true
    var soundOpenEnabled: Bool = true
    var soundCloseEnabled: Bool = true
    var soundErrorEnabled: Bool = true
    var soundResetEnabled: Bool = true
    var language: AppLanguage = .english
    var showNotifications: Bool = true
    var reduceAnimations: Bool = false
    var showEmptySlots: Bool = true
    var ignoreDuplicateHistory: Bool = false
    var pasteOnSelection: Bool = false
    var hotkeyPreferences: HotkeyPreferences = HotkeyPreferences()
    
    // MARK: - Backward Compatibility
    
    /// Custom decoder that provides default values for missing fields,
    /// ensuring old data files load gracefully after adding new settings.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.launchAtLogin = try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false
        self.restoreClipboardAfterPaste = try container.decodeIfPresent(Bool.self, forKey: .restoreClipboardAfterPaste) ?? true
        self.restoreClipboardAfterSave = try container.decodeIfPresent(Bool.self, forKey: .restoreClipboardAfterSave) ?? true
        self.maxHistoryItems = try container.decodeIfPresent(Int.self, forKey: .maxHistoryItems) ?? 200
        self.ignoreSensitiveApps = try container.decodeIfPresent(Bool.self, forKey: .ignoreSensitiveApps) ?? true
        self.sensitiveAppBundleIdentifiers = try container.decodeIfPresent([String].self, forKey: .sensitiveAppBundleIdentifiers) ?? [
            "com.1password.1password",
            "com.bitwarden.desktop",
            "com.apple.keychainaccess",
            "com.dashlane.dashlanemac",
            "org.keepassx.keepassxc"
        ]
        self.autoDeletePolicy = try container.decodeIfPresent(AutoDeletePolicy.self, forKey: .autoDeletePolicy) ?? .never
        self.showDockIcon = try container.decodeIfPresent(Bool.self, forKey: .showDockIcon) ?? true
        self.soundEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundEnabled) ?? true
        self.soundVolume = try container.decodeIfPresent(Double.self, forKey: .soundVolume) ?? 0.7
        self.soundSaveEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundSaveEnabled) ?? true
        self.soundCopyEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundCopyEnabled) ?? true
        self.soundPasteEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundPasteEnabled) ?? true
        self.soundOpenEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundOpenEnabled) ?? true
        self.soundCloseEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundCloseEnabled) ?? true
        self.soundErrorEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundErrorEnabled) ?? true
        self.soundResetEnabled = try container.decodeIfPresent(Bool.self, forKey: .soundResetEnabled) ?? true
        self.language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .english
        self.showNotifications = try container.decodeIfPresent(Bool.self, forKey: .showNotifications) ?? true
        self.reduceAnimations = try container.decodeIfPresent(Bool.self, forKey: .reduceAnimations) ?? false
        self.showEmptySlots = try container.decodeIfPresent(Bool.self, forKey: .showEmptySlots) ?? true
        self.ignoreDuplicateHistory = try container.decodeIfPresent(Bool.self, forKey: .ignoreDuplicateHistory) ?? false
        self.pasteOnSelection = try container.decodeIfPresent(Bool.self, forKey: .pasteOnSelection) ?? false
        self.hotkeyPreferences = try container.decodeIfPresent(HotkeyPreferences.self, forKey: .hotkeyPreferences) ?? HotkeyPreferences()
    }
    
    init() {}
}
