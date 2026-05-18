import SwiftUI
import AppKit

struct SettingsView: View {
    @StateObject private var store = ClipStore.shared
    @State private var showLaunchAtLoginAlert = false
    @State private var confirmationAlert: ConfirmationAlert?
    @State private var importExportAlert: ImportExportAlert?
    @State private var selectedTab = 0
    @State private var permissionStatus = PermissionService.shared.hasAccessibilityPermission()
    @State private var permissionTimer: Timer?
    @State private var newBundleId = ""
    
    private var sidebarItems: [(title: String, icon: String)] {
        [
            ("General", "gear"),
            ("Shortcuts", "command"),
            ("Clipboard", "doc.on.clipboard"),
            ("Privacy", "shield"),
            ("Data", "externaldrive")
        ]
    }
    
    var body: some View {
        HStack(spacing: 0) {
            sidebar
            Divider()
            contentArea
        }
        .frame(width: 760, height: 520)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear {
            permissionStatus = PermissionService.shared.hasAccessibilityPermission()
            startPermissionTimer()
        }
        .onDisappear {
            stopPermissionTimer()
        }
        .alert(isPresented: $showLaunchAtLoginAlert) {
            Alert(
                title: Text("Launch at Login Failed"),
                message: Text("This feature requires the app to be code-signed. Please sign the app with your Apple Developer ID or disable this setting."),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(item: $confirmationAlert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                primaryButton: .destructive(Text(alert.confirmButtonTitle)) {
                    alert.action()
                },
                secondaryButton: .cancel()
            )
        }
        .alert(item: $importExportAlert) { alert in
            Alert(
                title: Text(alert.title),
                message: Text(alert.message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Sidebar
    
    private var sidebar: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Image(systemName: "doc.on.clipboard")
                    .font(.system(size: 20))
                    .foregroundColor(.accentColor)
                Text("Clipo")
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            VStack(spacing: 2) {
                ForEach(Array(sidebarItems.enumerated()), id: \.offset) { index, item in
                    SidebarItem(
                        title: item.title,
                        icon: item.icon,
                        isSelected: selectedTab == index
                    ) {
                        withAnimation(.easeOut(duration: 0.15)) {
                            selectedTab = index
                        }
                    }
                }
            }
            .padding(.horizontal, 10)
            
            Spacer()
        }
        .frame(width: 180)
        .background(Color(NSColor.windowBackgroundColor))
    }
    
    // MARK: - Content Area
    
    private var contentArea: some View {
        VStack(spacing: 0) {
            statusBar
            Divider()
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    switch selectedTab {
                    case 0: generalTab
                    case 1: shortcutsTab
                    case 2: clipboardTab
                    case 3: privacyTab
                    case 4: dataTab
                    default: generalTab
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
            }
        }
    }
    
    // MARK: - Status Bar
    
    private var statusBar: some View {
        HStack(spacing: 12) {
            StatusBadge(
                icon: permissionStatus ? "checkmark.shield.fill" : "exclamationmark.shield.fill",
                label: permissionStatus ? "Accessibility On" : "Accessibility Off",
                color: permissionStatus ? .green : .orange
            )
            StatusBadge(
                icon: store.settings.launchAtLogin ? "checkmark.circle.fill" : "power.circle",
                label: store.settings.launchAtLogin ? "Launch at Login On" : "Launch at Login Off",
                color: store.settings.launchAtLogin ? .green : .secondary
            )
            StatusBadge(
                icon: "doc.on.clipboard",
                label: "\(store.history.count) History",
                color: .blue
            )
            StatusBadge(
                icon: "square.grid.2x2",
                label: "\(store.slots.count)/9 Slots",
                color: .accentColor
            )
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.4))
    }
    
    // MARK: - General Tab
    
    private var generalTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Startup")
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "power",
                    title: "Launch at Login",
                    subtitle: "Start Clipo automatically when you log in",
                    isOn: $store.settings.launchAtLogin
                )
                .onChange(of: store.settings.launchAtLogin) { newValue in
                    LaunchAtLoginService.shared.setLaunchAtLogin(newValue)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        let actual = LaunchAtLoginService.shared.isLaunchAtLoginEnabled()
                        if actual != newValue {
                            store.settings.launchAtLogin = actual
                            showLaunchAtLoginAlert = true
                        }
                    }
                }
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "dock.rectangle",
                    title: "Show Dock Icon",
                    subtitle: "Display Clipo in the Dock for easy access",
                    isOn: $store.settings.showDockIcon
                )
                .onChange(of: store.settings.showDockIcon) { newValue in
                    let policy: NSApplication.ActivationPolicy = newValue ? .regular : .accessory
                    let success = NSApp.setActivationPolicy(policy)
                    if success {
                        if newValue {
                            NSApp.activate(ignoringOtherApps: true)
                            NotificationService.shared.showNotification(
                                title: "Dock Icon Enabled",
                                body: "The Clipo icon now appears in the Dock."
                            )
                        } else {
                            NotificationService.shared.showNotification(
                                title: "Dock Icon Hidden",
                                body: "The Dock icon will disappear after you restart Clipo."
                            )
                        }
                    } else {
                        NotificationService.shared.showNotification(
                            title: "Setting Saved",
                            body: "The change will take effect after you restart Clipo."
                        )
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle("Feedback")
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "speaker.wave.2",
                    title: "Sound Effects",
                    subtitle: "Play sounds when copying, pasting, and saving",
                    isOn: $store.settings.soundEnabled
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
    }
    
    // MARK: - Shortcuts Tab
    
    private var shortcutsTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Global Shortcuts")
            VStack(spacing: 0) {
                shortcutRow(
                    title: "Open Clipo Panel",
                    keyBinding: $store.settings.hotkeyPreferences.openPanelKeyCode,
                    modifierBinding: $store.settings.hotkeyPreferences.openPanelModifiers,
                    showKeyPicker: true
                )
                
                Divider().padding(.leading, 12)
                
                shortcutRow(
                    title: "Save to Slot 1–9",
                    keyBinding: .constant(0),
                    modifierBinding: $store.settings.hotkeyPreferences.saveSlotModifiers,
                    showKeyPicker: false
                )
                
                Divider().padding(.leading, 12)
                
                shortcutRow(
                    title: "Paste from Slot",
                    keyBinding: .constant(0),
                    modifierBinding: $store.settings.hotkeyPreferences.pasteSlotModifiers,
                    showKeyPicker: false
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            if store.settings.hotkeyPreferences.saveSlotModifiers == store.settings.hotkeyPreferences.pasteSlotModifiers {
                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 11))
                        .foregroundColor(.orange)
                    Text("Save and Paste modifiers are identical — slots will conflict.")
                        .font(.system(size: 12))
                        .foregroundColor(.orange.opacity(0.9))
                    Spacer()
                }
                .padding(.horizontal, 4)
            }
            
            Button(action: {
                store.settings.hotkeyPreferences.resetToDefaults()
                HotkeyService.shared.registerAllHotkeys()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12))
                    Text("Reset Shortcuts to Default")
                        .font(.system(size: 12, weight: .medium))
                }
                .foregroundColor(.accentColor)
                .padding(.horizontal, 4)
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
    
    private func shortcutRow(
        title: String,
        keyBinding: Binding<UInt32>,
        modifierBinding: Binding<UInt32>,
        showKeyPicker: Bool
    ) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            if showKeyPicker {
                Picker("", selection: keyBinding) {
                    ForEach(HotkeyPreferences.openPanelKeyPresets, id: \.code) { preset in
                        Text(preset.label).tag(preset.code)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 90)
                .labelsHidden()
                .onChange(of: keyBinding.wrappedValue) { _ in reRegisterHotkeys() }
            }
            Picker("", selection: modifierBinding) {
                ForEach(HotkeyPreferences.modifierPresets, id: \.mask) { preset in
                    Text(preset.label).tag(preset.mask)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .frame(width: 150)
            .labelsHidden()
            .onChange(of: modifierBinding.wrappedValue) { _ in reRegisterHotkeys() }
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Clipboard Tab
    
    private var clipboardTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Paste Behavior")
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "arrow.uturn.backward",
                    title: "Restore Clipboard After Pasting",
                    subtitle: "Return previous clipboard content after a paste operation",
                    isOn: $store.settings.restoreClipboardAfterPaste
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "arrow.uturn.backward",
                    title: "Restore Clipboard After Saving",
                    subtitle: "Return previous clipboard content after saving to a slot",
                    isOn: $store.settings.restoreClipboardAfterSave
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle("Storage")
            VStack(spacing: 0) {
                HStack {
                    Text("Max History Items")
                        .font(.system(size: 13))
                    Spacer()
                    Picker("", selection: $store.settings.maxHistoryItems) {
                        Text("100").tag(100)
                        Text("200").tag(200)
                        Text("500").tag(500)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .frame(width: 180)
                }
                .padding(.vertical, 8)
                
                Divider().padding(.leading, 12)
                
                HStack {
                    Text("Auto Delete Unpinned")
                        .font(.system(size: 13))
                    Spacer()
                    Picker("", selection: $store.settings.autoDeletePolicy) {
                        ForEach(AutoDeletePolicy.allCases) { policy in
                            Text(policy.displayName).tag(policy)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 180)
                }
                .padding(.vertical, 8)
                
                Divider().padding(.leading, 12)
                
                HStack {
                    Text("Current History")
                        .font(.system(size: 13))
                    Spacer()
                    Text("\(store.history.count) items")
                        .font(.system(size: 13))
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
    }
    
    // MARK: - Privacy Tab
    
    private var privacyTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Accessibility Permission")
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: permissionStatus ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                        .font(.system(size: 16))
                        .foregroundColor(permissionStatus ? .green : .orange)
                    Text(permissionStatus ? "Granted" : "Required")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(permissionStatus ? .green : .orange)
                    Spacer()
                }
                
                Text("Clipo needs Accessibility permission to simulate keyboard shortcuts for copy and paste operations.")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if !permissionStatus {
                    Button(action: {
                        PermissionService.shared.requestAccessibilityPermission()
                        PermissionService.shared.openAccessibilitySettings()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "gear")
                            Text("Open System Settings")
                                .font(.system(size: 12, weight: .semibold))
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(6)
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle("Security")
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "eye.slash",
                    title: "Ignore Sensitive Apps",
                    subtitle: "Do not save clipboard content from password managers",
                    isOn: $store.settings.ignoreSensitiveApps
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle("Sensitive App Blacklist")
            VStack(alignment: .leading, spacing: 8) {
                if store.settings.sensitiveAppBundleIdentifiers.isEmpty {
                    Text("No apps blacklisted")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary.opacity(0.5))
                        .padding(.vertical, 4)
                } else {
                    ForEach(Array(store.settings.sensitiveAppBundleIdentifiers.enumerated()), id: \.element) { index, bundleId in
                        HStack(spacing: 8) {
                            Image(systemName: "app.badge.fill")
                                .font(.caption2)
                                .foregroundColor(.secondary.opacity(0.5))
                            Text(bundleId)
                                .font(.system(.caption, design: .monospaced))
                                .foregroundColor(.secondary)
                            Spacer()
                            Button(action: { removeBundleId(at: index) }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.secondary.opacity(0.4))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Color.secondary.opacity(0.04))
                        .cornerRadius(6)
                    }
                }
                
                HStack(spacing: 8) {
                    TextField("com.example.app", text: $newBundleId)
                        .textFieldStyle(PlainTextFieldStyle())
                        .font(.system(.caption, design: .monospaced))
                    
                    Button(action: {
                        addBundleId(newBundleId)
                        newBundleId = ""
                    }) {
                        Text("Add")
                            .font(.system(size: 12, weight: .semibold))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .background(Color.accentColor.opacity(0.1))
                    .foregroundColor(.accentColor)
                    .cornerRadius(6)
                    .disabled(newBundleId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.top, 4)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
    }
    
    // MARK: - Data Tab
    
    private var dataTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle("Import / Export")
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    SettingsActionButton(title: "Export JSON", icon: "square.and.arrow.up") {
                        exportJSON()
                    }
                    SettingsActionButton(title: "Import JSON", icon: "square.and.arrow.down") {
                        importJSON()
                    }
                }
                
                SettingsActionButton(title: "Open Data Folder", icon: "folder") {
                    StorageService.shared.openStorageFolder()
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle("Danger Zone")
            VStack(spacing: 8) {
                DangerButton(title: "Clear All History") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Clear History",
                        message: "This will remove all unpinned history items. Pinned items and slots will remain.",
                        confirmButtonTitle: "Clear",
                        action: { store.clearHistory() }
                    )
                }
                
                DangerButton(title: "Reset All Slots") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Reset Slots",
                        message: "This will clear all 9 slots. History will remain.",
                        confirmButtonTitle: "Reset",
                        action: { store.resetSlots() }
                    )
                }
                
                DangerButton(title: "Reset All Data") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Reset All Data",
                        message: "This will erase all slots, history, and settings. This action cannot be undone.",
                        confirmButtonTitle: "Erase Everything",
                        action: { store.resetAllData() }
                    )
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
    }
    
    // MARK: - Helpers
    
    private func sectionTitle(_ text: String) -> some View {
        Text(text)
            .font(.system(size: 11, weight: .bold))
            .foregroundColor(.secondary.opacity(0.7))
            .textCase(.uppercase)
            .tracking(0.5)
            .padding(.bottom, 6)
    }
    
    private func reRegisterHotkeys() {
        HotkeyService.shared.registerAllHotkeys()
    }
    
    private func startPermissionTimer() {
        permissionTimer?.invalidate()
        permissionTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { _ in
            let current = PermissionService.shared.hasAccessibilityPermission()
            if current != permissionStatus {
                permissionStatus = current
            }
        }
    }
    
    private func stopPermissionTimer() {
        permissionTimer?.invalidate()
        permissionTimer = nil
    }
    
    private func addBundleId(_ id: String) {
        let trimmed = id.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        guard !store.settings.sensitiveAppBundleIdentifiers.contains(trimmed) else { return }
        var settings = store.settings
        settings.sensitiveAppBundleIdentifiers.append(trimmed)
        store.settings = settings
    }
    
    private func removeBundleId(at index: Int) {
        var settings = store.settings
        settings.sensitiveAppBundleIdentifiers.remove(at: index)
        store.settings = settings
    }
    
    // MARK: - Import / Export
    
    private func exportJSON() {
        let panel = NSSavePanel()
        panel.title = "Export Clipo Data"
        panel.nameFieldStringValue = "clipo-data.json"
        panel.canCreateDirectories = true
        
        guard panel.runModal() == .OK, let url = panel.url else { return }
        
        do {
            try StorageService.shared.exportStore(
                slots: store.slots,
                history: store.history,
                settings: store.settings,
                to: url
            )
            NotificationService.shared.showNotification(
                title: "Export Successful",
                body: "Data saved to \(url.lastPathComponent)"
            )
        } catch {
            importExportAlert = ImportExportAlert(
                title: "Export Failed",
                message: error.localizedDescription
            )
        }
    }
    
    private func importJSON() {
        let panel = NSOpenPanel()
        panel.title = "Import Clipo Data"
        panel.allowsMultipleSelection = false
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        
        guard panel.runModal() == .OK, let url = panel.url else { return }
        
        do {
            let imported = try StorageService.shared.validateAndImportStore(from: url)
            store.importData(
                slots: imported.slots,
                history: imported.history,
                settings: imported.settings
            )
            HotkeyService.shared.registerAllHotkeys()
            let policy: NSApplication.ActivationPolicy = store.settings.showDockIcon ? .regular : .accessory
            let policyApplied = NSApp.setActivationPolicy(policy)
            if policyApplied {
                NotificationService.shared.showNotification(
                    title: "Import Successful",
                    body: "Data restored from \(url.lastPathComponent)"
                )
            } else {
                NotificationService.shared.showNotification(
                    title: "Import Successful",
                    body: "Data restored. Dock icon change will take effect after restart."
                )
            }
        } catch {
            importExportAlert = ImportExportAlert(
                title: "Import Failed",
                message: "The selected file is invalid or corrupted. Your existing data was not changed."
            )
        }
    }
}

// MARK: - Sidebar Item

struct SidebarItem: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                    .foregroundColor(isSelected ? .accentColor : .secondary.opacity(0.7))
                    .frame(width: 20)
                Text(title)
                    .font(.system(size: 13, weight: isSelected ? .semibold : .medium))
                    .foregroundColor(isSelected ? .primary : .secondary.opacity(0.7))
                Spacer()
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
            .background(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// MARK: - Status Badge

struct StatusBadge: View {
    let icon: String
    let label: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: icon)
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(color)
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.secondary.opacity(0.7))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor))
        )
    }
}

// MARK: - Toggle Row

struct ToggleRow: View {
    let icon: String
    let title: String
    let subtitle: String
    @Binding var isOn: Bool
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            
            Spacer()
            
            Toggle("", isOn: $isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
        }
        .padding(.vertical, 8)
    }
}

// MARK: - Danger Button

struct DangerButton: View {
    let title: String
    let action: () -> Void
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: "exclamationmark.triangle.fill")
                    .font(.caption)
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                Spacer()
            }
            .foregroundColor(isHovering ? .white : .red.opacity(0.85))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(isHovering ? Color.red.opacity(0.85) : Color.red.opacity(0.08))
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Settings Action Button

struct SettingsActionButton: View {
    let title: String
    let icon: String
    var isEnabled: Bool = true
    var action: (() -> Void)? = nil
    @State private var isHovering = false
    
    var body: some View {
        Button(action: { action?() }) {
            VStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundColor(isEnabled ? (isHovering ? .accentColor : .primary) : .secondary.opacity(0.4))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isEnabled && isHovering ? Color.accentColor.opacity(0.08) : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(Color.secondary.opacity(isEnabled ? 0.1 : 0.05), lineWidth: 0.5)
                    )
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isEnabled)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

// MARK: - Alert Models

struct ConfirmationAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let confirmButtonTitle: String
    let action: () -> Void
}

struct ImportExportAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
