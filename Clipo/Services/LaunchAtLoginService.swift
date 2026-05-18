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
                    title: L10n.string(.alertLaunchAtLoginTitle),
                    body: L10n.string(.launchAtLoginFailedBody),
                    isError: true
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
