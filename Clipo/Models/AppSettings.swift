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
    var language: AppLanguage = .english
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
        self.language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .english
        self.hotkeyPreferences = try container.decodeIfPresent(HotkeyPreferences.self, forKey: .hotkeyPreferences) ?? HotkeyPreferences()
    }
    
    init() {}
}
