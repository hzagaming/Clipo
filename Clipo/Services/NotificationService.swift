import SwiftUI
import AppKit

/// Displays lightweight in-app toast notifications instead of system
/// UNUserNotificationCenter alerts. This eliminates the recurring
/// `-[NSXPCDecoder validateAllowedClass:forKey:]` console warnings
/// caused by XPC decoding inside the notification daemon.
///
/// Toasts are queued so rapid-fire notifications do not overwrite each
/// other; each toast displays for its full duration before the next
/// one appears.
class NotificationService {
    static let shared = NotificationService()
    
    private var queue: [(title: String, body: String, isError: Bool)] = []
    private var isDisplaying = false
    private var toastWindow: ToastWindow?
    private var dismissTimer: Timer?
    
    private init() {}
    
    func showNotification(title: String, body: String, isError: Bool = false) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            guard ClipStore.shared.settings.showNotifications else { return }
            // Cap the queue to prevent unbounded growth during rapid-fire events.
            if self.queue.count >= 10 {
                self.queue.removeFirst()
            }
            self.queue.append((title, body, isError))
            self.processQueue()
        }
    }
    
    // MARK: - Private
    
    private func processQueue() {
        guard !isDisplaying, !queue.isEmpty else { return }
        isDisplaying = true
        let next = queue.removeFirst()
        presentToast(title: next.title, body: next.body, isError: next.isError)
    }
    
    private func presentToast(title: String, body: String, isError: Bool) {
        dismissTimer?.invalidate()
        
        if toastWindow == nil {
            toastWindow = ToastWindow()
        }
        
        guard let window = toastWindow else {
            // If ToastWindow init failed, drop the entire queue to avoid an
            // infinite loop between processQueue and presentToast.
            isDisplaying = false
            queue.removeAll()
            return
        }
        
        window.contentView = NSHostingView(rootView: ToastView(title: title, message: body, isError: isError))
        positionWindow(window)
        
        // Entrance: slightly above final position.
        let finalOrigin = window.frame.origin
        window.setFrameOrigin(NSPoint(x: finalOrigin.x, y: finalOrigin.y + 12))
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1
            window.animator().setFrameOrigin(finalOrigin)
        }
        
        let displayDuration = isError ? 3.5 : 2.5
        dismissTimer = Timer.scheduledTimer(withTimeInterval: displayDuration, repeats: false) { [weak self] _ in
            self?.dismissToast()
        }
    }
    
    private func dismissToast() {
        guard let window = toastWindow else {
            isDisplaying = false
            processQueue()
            return
        }
        
        let currentOrigin = window.frame.origin
        let exitOrigin = NSPoint(x: currentOrigin.x, y: currentOrigin.y - 6)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.25
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0
            window.animator().setFrameOrigin(exitOrigin)
        } completionHandler: { [weak self] in
            window.setFrameOrigin(currentOrigin)
            window.orderOut(nil)
            self?.dismissTimer = nil
            self?.isDisplaying = false
            self?.processQueue()
        }
    }
    
    private func positionWindow(_ window: NSWindow) {
        let size = window.frame.size
        let padding: CGFloat = 20
        
        // Use the screen that currently contains the mouse cursor so
        // the toast always appears on the active display.
        let targetFrame: NSRect
        if let mouseLocation = NSEvent.mouseLocation as NSPoint?,
           let screen = NSScreen.screens.first(where: { $0.frame.contains(mouseLocation) }) {
            targetFrame = screen.visibleFrame
        } else if let screen = NSScreen.main ?? NSScreen.screens.first {
            targetFrame = screen.visibleFrame
        } else {
            // Headless / remote-desktop fallback
            targetFrame = NSRect(x: 0, y: 0, width: 1920, height: 1080)
        }
        
        let origin = NSPoint(
            x: targetFrame.maxX - size.width - padding,
            y: targetFrame.maxY - size.height - padding
        )
        window.setFrameOrigin(origin)
    }
}

// MARK: - Toast Window

/// A non-activating, borderless panel that never steals key status.
private class ToastWindow: NSPanel {
    init() {
        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 320, height: 84),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        self.backgroundColor = .clear
        self.isOpaque = false
        self.hasShadow = true
        self.level = .floating
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isReleasedWhenClosed = false
    }
    
    override var canBecomeKey: Bool { false }
    override var canBecomeMain: Bool { false }
}

// MARK: - Toast View

private struct ToastView: View {
    let title: String
    let message: String
    let isError: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isError ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(isError ? .orange : .green)
            
            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white)
                
                Text(message)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.85))
                    .lineLimit(2)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            Spacer(minLength: 4)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(white: 0.15),
                            Color(white: 0.12)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: Color.black.opacity(0.35), radius: 16, x: 0, y: 8)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 0.5)
        )
    }
}
