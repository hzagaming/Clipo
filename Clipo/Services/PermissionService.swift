import Cocoa
import ApplicationServices

extension Notification.Name {
    static let accessibilityPermissionChanged = Notification.Name("accessibilityPermissionChanged")
}

class PermissionService {
    static let shared = PermissionService()

    private var lastKnownAccessibilityPermission = AXIsProcessTrusted()
    private var lastAccessibilityRequestAt: Date?
    private let grantWaitWindow: TimeInterval = 20

    private init() {}
    
    func hasAccessibilityPermission() -> Bool {
        refreshAccessibilityPermission()
    }

    @discardableResult
    func refreshAccessibilityPermission() -> Bool {
        let current = AXIsProcessTrusted()
        if current != lastKnownAccessibilityPermission {
            lastKnownAccessibilityPermission = current
            NotificationCenter.default.post(
                name: .accessibilityPermissionChanged,
                object: current
            )
        }
        return current
    }

    var isWaitingForAccessibilityGrant: Bool {
        guard !lastKnownAccessibilityPermission,
              let lastAccessibilityRequestAt else {
            return false
        }
        return Date().timeIntervalSince(lastAccessibilityRequestAt) < grantWaitWindow
    }
    
    func requestAccessibilityPermission() {
        lastAccessibilityRequestAt = Date()
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue() as String: true]
        AXIsProcessTrustedWithOptions(options as CFDictionary)
        schedulePermissionRefreshes()
    }
    
    func openAccessibilitySettings() {
        let prefpaneURL = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Accessibility")!
        NSWorkspace.shared.open(prefpaneURL)
    }

    func accessibilityRequiredMessage(action: String) -> String {
        if isWaitingForAccessibilityGrant {
            return L10n.string(.accessibilityWaitingMessage)
        }
        return L10n.string(.accessibilityRequiredTemplate, action)
    }

    private func schedulePermissionRefreshes() {
        [0.4, 1.0, 2.0, 4.0, 8.0, 12.0, 20.0].forEach { delay in
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
                self?.refreshAccessibilityPermission()
            }
        }
    }
}
