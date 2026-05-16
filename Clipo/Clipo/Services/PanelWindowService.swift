import SwiftUI
import AppKit

class PanelWindowService {
    static let shared = PanelWindowService()
    
    /// Internal read access for AppDelegate to distinguish managed windows.
    private(set) var panelWindow: NSPanel?
    private let panelDelegate = PanelWindowDelegate()
    
    func showPanel() {
        if panelWindow == nil {
            createPanel()
        }
        panelWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func hidePanel() {
        guard panelWindow?.isVisible == true else { return }
        panelWindow?.orderOut(nil)
    }
    
    func togglePanel() {
        // isVisible is more reliable than isKeyWindow for NSPanel across Spaces.
        if panelWindow?.isVisible == true {
            hidePanel()
        } else {
            showPanel()
        }
    }
    
    private func createPanel() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 600, height: 500),
            styleMask: [.nonactivatingPanel, .titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        panel.title = "Clipo"
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isReleasedWhenClosed = false
        panel.delegate = panelDelegate
        panel.contentView = NSHostingView(rootView: ClipoPanelView())
        panel.center()
        panelWindow = panel
    }
}

// MARK: - Panel Window Delegate

/// Automatically hides the panel when it loses key status (e.g. user clicks outside).
class PanelWindowDelegate: NSObject, NSWindowDelegate {
    func windowDidResignKey(_ notification: Notification) {
        guard let window = notification.object as? NSPanel else { return }
        // Only hide if this is our panel and it's currently visible.
        if window.isVisible {
            PanelWindowService.shared.hidePanel()
        }
    }
}
