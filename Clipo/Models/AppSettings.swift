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
    
    // MARK: - Deep Customization (v1.8.0+)
    var searchCaseSensitive: Bool = false
    var notificationDuration: Double = 2.5
    var pasteDelay: Double = 0.0
    var showSourceApp: Bool = true
    var panelAnimationSpeed: Double = 1.0
    
    // MARK: - Deep Customization (v1.8.1+)
    var panelOpacity: Double = 1.0
    var autoClearOnScreenLock: Bool = false
    var searchFuzzyMatching: Bool = false
    var rowHeightCompact: Bool = false
    
    // MARK: - Deep Customization (v1.8.2+)
    var keyboardWrapAround: Bool = true
    var showTimestamp: Bool = true
    var showTypeBadge: Bool = true
    var showFooterShortcuts: Bool = true
    var clickOutsideClosesPanel: Bool = true
    var confirmBeforeDelete: Bool = false
    var showMenuBarIcon: Bool = true
    var escapeClosesPanel: Bool = true
    var showSlotSection: Bool = true
    var autoHideDelay: Double = 0.0
    
    // MARK: - Backward Compatibility
    
    /// Custom decoder that provides default values for missing fields,
    /// ensuring old data files load gracefully after adding new settings.
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.launchAtLogin = try container.decodeIfPresent(Bool.self, forKey: .launchAtLogin) ?? false
        self.restoreClipboardAfterPaste = try container.decodeIfPresent(Bool.self, forKey: .restoreClipboardAfterPaste) ?? true
        self.restoreClipboardAfterSave = try container.decodeIfPresent(Bool.self, forKey: .restoreClipboardAfterSave) ?? true
        self.maxHistoryItems = max(0, try container.decodeIfPresent(Int.self, forKey: .maxHistoryItems) ?? 200)
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
        self.searchCaseSensitive = try container.decodeIfPresent(Bool.self, forKey: .searchCaseSensitive) ?? false
        self.notificationDuration = try container.decodeIfPresent(Double.self, forKey: .notificationDuration) ?? 2.5
        self.pasteDelay = max(0, try container.decodeIfPresent(Double.self, forKey: .pasteDelay) ?? 0.0)
        self.showSourceApp = try container.decodeIfPresent(Bool.self, forKey: .showSourceApp) ?? true
        self.panelAnimationSpeed = max(0.5, min(2.0, try container.decodeIfPresent(Double.self, forKey: .panelAnimationSpeed) ?? 1.0))
        self.panelOpacity = max(0.5, min(1.0, try container.decodeIfPresent(Double.self, forKey: .panelOpacity) ?? 1.0))
        self.autoClearOnScreenLock = try container.decodeIfPresent(Bool.self, forKey: .autoClearOnScreenLock) ?? false
        self.searchFuzzyMatching = try container.decodeIfPresent(Bool.self, forKey: .searchFuzzyMatching) ?? false
        self.rowHeightCompact = try container.decodeIfPresent(Bool.self, forKey: .rowHeightCompact) ?? false
        self.keyboardWrapAround = try container.decodeIfPresent(Bool.self, forKey: .keyboardWrapAround) ?? true
        self.showTimestamp = try container.decodeIfPresent(Bool.self, forKey: .showTimestamp) ?? true
        self.showTypeBadge = try container.decodeIfPresent(Bool.self, forKey: .showTypeBadge) ?? true
        self.showFooterShortcuts = try container.decodeIfPresent(Bool.self, forKey: .showFooterShortcuts) ?? true
        self.clickOutsideClosesPanel = try container.decodeIfPresent(Bool.self, forKey: .clickOutsideClosesPanel) ?? true
        self.confirmBeforeDelete = try container.decodeIfPresent(Bool.self, forKey: .confirmBeforeDelete) ?? false
        self.showMenuBarIcon = try container.decodeIfPresent(Bool.self, forKey: .showMenuBarIcon) ?? true
        self.escapeClosesPanel = try container.decodeIfPresent(Bool.self, forKey: .escapeClosesPanel) ?? true
        self.showSlotSection = try container.decodeIfPresent(Bool.self, forKey: .showSlotSection) ?? true
        self.autoHideDelay = max(0, try container.decodeIfPresent(Double.self, forKey: .autoHideDelay) ?? 0.0)
    }
    
    init() {}
}
