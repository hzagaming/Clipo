import SwiftUI
import AppKit

class PanelWindowService {
    static let shared = PanelWindowService()
    
    /// Internal read access for AppDelegate to distinguish managed windows.
    private(set) var panelWindow: NSPanel?
    private let panelDelegate = PanelWindowDelegate()
    private var keyboardMonitor: Any?
    
    func showPanel() {
        if panelWindow == nil {
            createPanel()
        }
        panelWindow?.alphaValue = 0
        panelWindow?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
        startKeyboardMonitoring()
        
        // Fade in with subtle scale
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.15)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
        panelWindow?.animator().alphaValue = 1
        CATransaction.commit()
    }
    
    func hidePanel() {
        guard panelWindow?.isVisible == true else { return }
        SoundService.shared.playClose()
        stopKeyboardMonitoring()
        
        // Fade out then orderOut
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.12)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        CATransaction.setCompletionBlock { [weak self] in
            self?.panelWindow?.orderOut(nil)
        }
        panelWindow?.animator().alphaValue = 0
        CATransaction.commit()
    }
    
    func togglePanel() {
        // isVisible is more reliable than isKeyWindow for NSPanel across Spaces.
        if panelWindow?.isVisible == true {
            hidePanel()
        } else {
            showPanel()
        }
    }
    
    // MARK: - Keyboard Monitoring
    
    private func startKeyboardMonitoring() {
        stopKeyboardMonitoring()
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard self?.panelWindow?.isVisible == true else { return event }
            NotificationCenter.default.post(name: .panelKeyboardEvent, object: event)
            return event
        }
    }
    
    private func stopKeyboardMonitoring() {
        if let monitor = keyboardMonitor {
            NSEvent.removeMonitor(monitor)
            keyboardMonitor = nil
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
