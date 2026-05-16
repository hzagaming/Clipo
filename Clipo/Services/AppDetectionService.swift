import AppKit

class AppDetectionService {
    static let shared = AppDetectionService()
    
    func currentFrontmostAppName() -> String? {
        return NSWorkspace.shared.frontmostApplication?.localizedName
    }
    
    func currentFrontmostBundleIdentifier() -> String? {
        return NSWorkspace.shared.frontmostApplication?.bundleIdentifier
    }
    
    func isSensitiveApp(bundleIdentifier: String?) -> Bool {
        guard let bid = bundleIdentifier else { return false }
        let sensitive = ClipStore.shared.settings.sensitiveAppBundleIdentifiers
        return sensitive.contains(bid)
    }
    
    func isCurrentAppSensitive() -> Bool {
        return isSensitiveApp(bundleIdentifier: currentFrontmostBundleIdentifier())
    }
}
