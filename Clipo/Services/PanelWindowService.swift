import SwiftUI
import AppKit

class PanelWindowService {
    static let shared = PanelWindowService()
    
    /// Internal read access for AppDelegate to distinguish managed windows.
    private(set) var panelWindow: NSPanel?
    private let panelDelegate = PanelWindowDelegate()
    
    func panelDidClose() {
        panelWindow = nil
        isHiding = false
    }
    private var keyboardMonitor: Any?
    private var clickOutsideMonitor: Any?
    private var isHiding = false
    private var ignoreOutsideClicksUntil = Date.distantPast
    
    func showPanel() {
        if panelWindow == nil {
            createPanel()
        }
        guard let panel = panelWindow else { return }
        
        // If the panel is already fully visible and not in the middle of hiding,
        // just bring it forward.
        if panel.isVisible && !isHiding {
            NSApp.activate(ignoringOtherApps: true)
            panel.makeKeyAndOrderFront(nil)
            return
        }
        
        // Cancel any in-progress hide animation so the panel doesn't get
        // ordered out immediately after we show it.
        isHiding = false
        panel.alphaValue = 0
        
        let reduceAnimations = ClipStore.shared.settings.reduceAnimations
        
        // Slightly offset downward for entrance animation.
        let finalOrigin = panel.frame.origin
        if !reduceAnimations {
            panel.setFrameOrigin(NSPoint(x: finalOrigin.x, y: finalOrigin.y - 10))
        }
        
        // Activate the app first, then force the panel to the front.
        NSApp.activate(ignoringOtherApps: true)
        panel.makeKeyAndOrderFront(nil)
        
        startKeyboardMonitoring()
        // Delay starting click-outside monitoring so that the very click
        // that opened the panel (e.g. a menu-bar icon click or hotkey) does
        // not immediately trigger a hide.
        ignoreOutsideClicksUntil = Date().addingTimeInterval(0.75)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.startClickOutsideMonitoring()
        }
        
        SoundService.shared.playOpen()
        
        // Fade + slide in
        if reduceAnimations {
            panel.alphaValue = 1
            panel.setFrameOrigin(finalOrigin)
        } else {
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.2)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeOut))
            panel.animator().alphaValue = 1
            panel.animator().setFrameOrigin(finalOrigin)
            CATransaction.commit()
        }
    }
    
    func hidePanel() {
        guard let panel = panelWindow, panel.isVisible, !isHiding else { return }
        isHiding = true
        
        SoundService.shared.playClose()
        stopKeyboardMonitoring()
        stopClickOutsideMonitoring()
        
        // Fade + slide out then orderOut. Capture the local panel reference so the
        // completion block never accesses a deallocated or replaced window.
        let reduceAnimations = ClipStore.shared.settings.reduceAnimations
        let currentOrigin = panel.frame.origin
        if reduceAnimations {
            panel.alphaValue = 0
            panel.orderOut(nil)
            isHiding = false
        } else {
            let exitOrigin = NSPoint(x: currentOrigin.x, y: currentOrigin.y - 6)
            CATransaction.begin()
            CATransaction.setAnimationDuration(0.18)
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction(name: .easeIn))
            CATransaction.setCompletionBlock { [weak self] in
                // If showPanel() cancelled the hide in the meantime, don't orderOut.
                guard let self = self, self.isHiding else { return }
                panel.setFrameOrigin(currentOrigin)
                panel.orderOut(nil)
                self.isHiding = false
            }
            panel.animator().alphaValue = 0
            panel.animator().setFrameOrigin(exitOrigin)
            CATransaction.commit()
        }
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
        stopClickOutsideMonitoring()
        if let panel = panelWindow {
            panel.delegate = nil
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
            // Consume navigation and action keys so they don't leak through
            // to the search field.
            switch event.keyCode {
            case 126, 125, 36, 53: // Up, Down, Return, Escape
                return nil
            case 35 where event.modifierFlags.contains(.command): // Cmd+P
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
    
    // MARK: - Click-Outside Monitoring
    
    /// Watches for mouse clicks outside the panel so it auto-hides when the
    /// user clicks elsewhere. Because the panel uses `.nonactivatingPanel` it
    /// never becomes key, so `windowDidResignKey` never fires.
    private func startClickOutsideMonitoring() {
        stopClickOutsideMonitoring()
        clickOutsideMonitor = NSEvent.addGlobalMonitorForEvents(matching: [.leftMouseDown, .rightMouseDown]) { [weak self] _ in
            DispatchQueue.main.async {
                self?.handleOutsideClick()
            }
        }
    }
    
    private func stopClickOutsideMonitoring() {
        if let monitor = clickOutsideMonitor {
            NSEvent.removeMonitor(monitor)
            clickOutsideMonitor = nil
        }
    }
    
    private func handleOutsideClick() {
        guard Date() >= ignoreOutsideClicksUntil else { return }
        guard let panel = panelWindow, panel.isVisible, !isHiding else { return }
        let mouse = NSEvent.mouseLocation
        let inside = panel.frame.contains(mouse)
        guard !inside else { return }
        hidePanel()
    }
    
    private func createPanel() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 620, height: 640),
            styleMask: [.nonactivatingPanel, .titled, .closable],
            backing: .buffered,
            defer: false
        )
        panel.title = L10n.string(.panelTitle)
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

/// Handles close-button clicks on the panel.
class PanelWindowDelegate: NSObject, NSWindowDelegate {
    /// Intercept the close button (×) so the panel hides instead of being
    /// destroyed. This keeps the app running in the background (menu-bar
    /// style) and preserves the panel state for the next showPanel().
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        PanelWindowService.shared.hidePanel()
        return false
    }
    
    func windowWillClose(_ notification: Notification) {
        guard let window = notification.object as? NSPanel else { return }
        // If the user closes the panel via the close button, break the delegate
        // link so no further callbacks arrive on a potentially deallocated path.
        window.delegate = nil
        PanelWindowService.shared.panelDidClose()
    }
}
