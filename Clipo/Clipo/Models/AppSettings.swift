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
    var showDockIcon: Bool = false
}
