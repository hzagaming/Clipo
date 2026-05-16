import SwiftUI
import AppKit

class PanelWindowService {
    static let shared = PanelWindowService()
    
    /// Internal read access for AppDelegate to distinguish managed windows.
    private(set) var panelWindow: NSPanel?
    private let panelDelegate = PanelWindowDelegate()
    private var keyboardMonitor: Any?
    private var isHiding = false
    
    func showPanel() {
        if panelWindow == nil {
            createPanel()
        }
        // Cancel any in-progress hide animation so the panel doesn't get
        // ordered out immediately after we show it.
        isHiding = false
        panelWindow?.alphaValue = 1
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
        guard let panel = panelWindow, panel.isVisible, !isHiding else { return }
        isHiding = true
        SoundService.shared.playClose()
        stopKeyboardMonitoring()
        
        // Fade out then orderOut. Capture the local panel reference so the
        // completion block never accesses a deallocated or replaced window.
        CATransaction.begin()
        CATransaction.setAnimationDuration(0.12)
        CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
        CATransaction.setCompletionBlock { [weak self] in
            panel.orderOut(nil)
            self?.isHiding = false
        }
        panel.animator().alphaValue = 0
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
    
    /// Full teardown used on app termination or when resetting UI state.
    func tearDown() {
        stopKeyboardMonitoring()
        if let panel = panelWindow {
            panel.delegate = nil
            panel.contentView = nil
            panel.close()
        }
        panelWindow = nil
        isHiding = false
    }
    
    // MARK: - Keyboard Monitoring
    
    private func startKeyboardMonitoring() {
        stopKeyboardMonitoring()
        keyboardMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak self] event in
            guard self?.panelWindow?.isVisible == true else { return event }
            NotificationCenter.default.post(name: .panelKeyboardEvent, object: event)
            // Consume navigation keys so they don't leak through to the search field.
            switch event.keyCode {
            case 126, 125, 36, 53: // Up, Down, Return, Escape
                return nil
            default:
                return event
            }
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
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSPanel else { return }
        // If the user closes the panel via the close button, break the delegate
        // link so no further callbacks arrive on a potentially deallocated path.
        window.delegate = nil
    }
}
