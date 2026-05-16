import ServiceManagement
import Foundation

class LaunchAtLoginService {
    static let shared = LaunchAtLoginService()
    
    func setLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                print("[Clipo] Failed to set launch at login: \(error)")
                NotificationService.shared.showNotification(
                    title: "Launch at Login Failed",
                    body: "Please ensure the app is code-signed to use this feature."
                )
            }
        }
    }
    
    func isLaunchAtLoginEnabled() -> Bool {
        if #available(macOS 13, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }
}
