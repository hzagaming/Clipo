import AppKit

class ClipboardHistoryService {
    static let shared = ClipboardHistoryService()

    private var timer: Timer?
    private var keyMonitor: Any?
    private var lastChangeCount = NSPasteboard.general.changeCount
    private var ignoredChangeCounts: Set<Int> = []
    private var ignorePasteEventsUntil = Date.distantPast

    private init() {}

    func start() {
        stop()
        lastChangeCount = NSPasteboard.general.changeCount
        timer = Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [weak self] _ in
            self?.pollPasteboard()
        }
        keyMonitor = NSEvent.addGlobalMonitorForEvents(matching: .keyDown) { [weak self] event in
            self?.handleGlobalKeyDown(event)
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        if let keyMonitor = keyMonitor {
            NSEvent.removeMonitor(keyMonitor)
            self.keyMonitor = nil
        }
    }

    func ignoreChangeCount(_ changeCount: Int) {
        ignoredChangeCounts.insert(changeCount)
        lastChangeCount = changeCount
    }

    func ignorePasteEvents(for duration: TimeInterval) {
        ignorePasteEventsUntil = Date().addingTimeInterval(duration)
    }

    private func pollPasteboard() {
        let pasteboard = NSPasteboard.general
        let currentChangeCount = pasteboard.changeCount
        guard currentChangeCount != lastChangeCount else { return }

        lastChangeCount = currentChangeCount
        if ignoredChangeCounts.remove(currentChangeCount) != nil {
            return
        }

        recordCurrentPasteboard()
    }

    private func handleGlobalKeyDown(_ event: NSEvent) {
        guard Date() >= ignorePasteEventsUntil else { return }
        guard event.keyCode == 9 else { return } // V
        guard event.modifierFlags.intersection([.command, .control, .option]) == .command else { return }

        DispatchQueue.main.async { [weak self] in
            self?.recordCurrentPasteboard()
        }
    }

    private func recordCurrentPasteboard() {
        let appName = AppDetectionService.shared.currentFrontmostAppName()
        let bundleId = AppDetectionService.shared.currentFrontmostBundleIdentifier()
        if ClipStore.shared.settings.ignoreSensitiveApps &&
            AppDetectionService.shared.isSensitiveApp(bundleIdentifier: bundleId) {
            return
        }

        guard let item = ClipboardService.shared.readClipItemFromPasteboard(
            sourceApp: appName,
            sourceBundleIdentifier: bundleId
        ) else {
            return
        }

        ClipStore.shared.recordHistoryItem(item)
    }
}
