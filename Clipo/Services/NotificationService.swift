import SwiftUI
import AppKit

/// Displays lightweight in-app toast notifications instead of system
/// UNUserNotificationCenter alerts. This eliminates the recurring
/// `-[NSXPCDecoder validateAllowedClass:forKey:]` console warnings
/// caused by XPC decoding inside the notification daemon.
class NotificationService {
    static let shared = NotificationService()
    
    private var toastWindow: ToastWindow?
    private var dismissTimer: Timer?
    
    private init() {}
    
    func showNotification(title: String, body: String) {
        DispatchQueue.main.async { [weak self] in
            self?.presentToast(title: title, body: body)
        }
    }
    
    // MARK: - Private
    
    private func presentToast(title: String, body: String) {
        dismissTimer?.invalidate()
        
        if toastWindow == nil {
            toastWindow = ToastWindow()
        }
        
        guard let window = toastWindow else { return }
        
        window.contentView = NSHostingView(rootView: ToastView(title: title, message: body))
        positionWindow(window)
        
        window.alphaValue = 0
        window.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            context.timingFunction = CAMediaTimingFunction(name: .easeOut)
            window.animator().alphaValue = 1
        }
        
        dismissTimer = Timer.scheduledTimer(withTimeInterval: 2.5, repeats: false) { [weak self] _ in
            self?.dismissToast()
        }
    }
    
    private func dismissToast() {
        guard let window = toastWindow else { return }
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.timingFunction = CAMediaTimingFunction(name: .easeIn)
            window.animator().alphaValue = 0
        } completionHandler: { [weak self] in
            window.orderOut(nil)
            self?.dismissTimer = nil
        }
    }
    
    private func positionWindow(_ window: NSWindow) {
        guard let screen = NSScreen.main ?? NSScreen.screens.first else { return }
        let visibleFrame = screen.visibleFrame
        let size = window.frame.size
        let padding: CGFloat = 20
        
        let origin = NSPoint(
            x: visibleFrame.maxX - size.width - padding,
            y: visibleFrame.maxY - size.height - padding
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
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 22))
                .foregroundColor(.green)
            
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
