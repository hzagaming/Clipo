import SwiftUI
import AppKit

struct SettingsView: View {
    @StateObject private var store = ClipStore.shared
    @State private var showLaunchAtLoginAlert = false
    @State private var confirmationAlert: ConfirmationAlert?
    @State private var selectedTab = 0
    @State private var importExportAlert: ImportExportAlert?
    
    var body: some View {
        VStack(spacing: 0) {
            // Custom tab bar
            HStack(spacing: 0) {
                ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                    TabButton(
                        title: tab.title,
                        icon: tab.icon,
                        isSelected: selectedTab == index
                    ) {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            selectedTab = index
                        }
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.top, 12)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.horizontal, 16)
            
            // Content area with transition
            TabView(selection: $selectedTab) {
                generalTab.tag(0)
                clipboardTab.tag(1)
                privacyTab.tag(2)
                dataTab.tag(3)
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.85), value: selectedTab)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
        .frame(width: 540, height: 400)
        .background(Color(NSColor.windowBackgroundColor))
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
    
    // MARK: - Tabs
    
    private var tabs: [(title: String, icon: String)] {
        [
            ("General", "gear"),
            ("Clipboard", "doc.on.clipboard"),
            ("Privacy", "shield"),
            ("Data", "externaldrive")
        ]
    }
    
    private var generalTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SettingsCard(title: "Startup") {
                    AnimatedToggle("Launch at Login", isOn: $store.settings.launchAtLogin)
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
                    
                    AnimatedToggle("Show Dock Icon", isOn: $store.settings.showDockIcon)
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
                
                SettingsCard(title: "Sound Effects") {
                    AnimatedToggle("Enable Sound Effects", isOn: $store.settings.soundEnabled)
                }
                
                SettingsCard(title: "Shortcuts") {
                    // Open Panel
                    HStack {
                        Text("Open Clipo Panel")
                            .font(.system(size: 13))
                        Spacer()
                        Picker("", selection: $store.settings.hotkeyPreferences.openPanelKeyCode) {
                            ForEach(HotkeyPreferences.openPanelKeyPresets, id: \.code) { preset in
                                Text(preset.label).tag(preset.code)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 90)
                        .labelsHidden()
                        Picker("", selection: $store.settings.hotkeyPreferences.openPanelModifiers) {
                            ForEach(HotkeyPreferences.modifierPresets, id: \.mask) { preset in
                                Text(preset.label).tag(preset.mask)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 140)
                        .labelsHidden()
                    }
                    .onChange(of: store.settings.hotkeyPreferences.openPanelKeyCode) { _ in reRegisterHotkeys() }
                    .onChange(of: store.settings.hotkeyPreferences.openPanelModifiers) { _ in reRegisterHotkeys() }
                    
                    Divider().padding(.vertical, 2)
                    
                    // Save Slot
                    HStack {
                        Text("Save to Slot 1–9")
                            .font(.system(size: 13))
                        Spacer()
                        Picker("", selection: $store.settings.hotkeyPreferences.saveSlotModifiers) {
                            ForEach(HotkeyPreferences.modifierPresets, id: \.mask) { preset in
                                Text(preset.label).tag(preset.mask)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 140)
                        .labelsHidden()
                    }
                    .onChange(of: store.settings.hotkeyPreferences.saveSlotModifiers) { _ in reRegisterHotkeys() }
                    
                    Divider().padding(.vertical, 2)
                    
                    // Paste Slot
                    HStack {
                        Text("Paste from Slot")
                            .font(.system(size: 13))
                        Spacer()
                        Picker("", selection: $store.settings.hotkeyPreferences.pasteSlotModifiers) {
                            ForEach(HotkeyPreferences.modifierPresets, id: \.mask) { preset in
                                Text(preset.label).tag(preset.mask)
                            }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .frame(width: 140)
                        .labelsHidden()
                    }
                    .onChange(of: store.settings.hotkeyPreferences.pasteSlotModifiers) { _ in reRegisterHotkeys() }
                    
                    // Conflict warning
                    if store.settings.hotkeyPreferences.saveSlotModifiers == store.settings.hotkeyPreferences.pasteSlotModifiers {
                        HStack(spacing: 6) {
                            Image(systemName: "exclamationmark.triangle.fill")
                                .font(.caption2)
                                .foregroundColor(.orange)
                            Text("Save and Paste modifiers are identical — slots will conflict.")
                                .font(.caption2)
                                .foregroundColor(.orange.opacity(0.85))
                        }
                        .padding(.top, 4)
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var clipboardTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SettingsCard(title: "Paste Behavior") {
                    AnimatedToggle("Restore clipboard after pasting", isOn: $store.settings.restoreClipboardAfterPaste)
                    AnimatedToggle("Restore clipboard after saving", isOn: $store.settings.restoreClipboardAfterSave)
                }
                
                SettingsCard(title: "Storage") {
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
                    
                    Divider().padding(.vertical, 4)
                    
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
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var privacyTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SettingsCard(title: "Security") {
                    AnimatedToggle("Ignore Sensitive Apps", isOn: $store.settings.ignoreSensitiveApps)
                }
                
                SettingsCard(title: "Sensitive App Blacklist") {
                    VStack(alignment: .leading, spacing: 6) {
                        ForEach(store.settings.sensitiveAppBundleIdentifiers, id: \.self) { bundleId in
                            HStack(spacing: 8) {
                                Image(systemName: "app.badge.fill")
                                    .font(.caption2)
                                    .foregroundColor(.secondary.opacity(0.6))
                                Text(bundleId)
                                    .font(.system(.caption, design: .monospaced))
                                    .foregroundColor(.secondary)
                                Spacer()
                            }
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.secondary.opacity(0.05))
                            .cornerRadius(6)
                        }
                    }
                }
                
                SettingsCard(title: "Danger Zone") {
                    DangerButton(title: "Clear All History") {
                        confirmationAlert = ConfirmationAlert(
                            title: "Clear History",
                            message: "This will remove all unpinned history items. Are you sure?",
                            confirmButtonTitle: "Clear",
                            action: { store.clearHistory() }
                        )
                    }
                    
                    DangerButton(title: "Reset All Slots") {
                        confirmationAlert = ConfirmationAlert(
                            title: "Reset Slots",
                            message: "This will clear all 9 slots. Are you sure?",
                            confirmButtonTitle: "Reset",
                            action: { store.resetSlots() }
                        )
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var dataTab: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 16) {
                SettingsCard(title: "Import / Export") {
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
                
                SettingsCard(title: "Danger Zone") {
                    DangerButton(title: "Reset All Data") {
                        confirmationAlert = ConfirmationAlert(
                            title: "Reset All Data",
                            message: "This will erase all slots, history, and settings. This action cannot be undone.",
                            confirmButtonTitle: "Erase Everything",
                            action: { store.resetAllData() }
                        )
                    }
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private func reRegisterHotkeys() {
        HotkeyService.shared.registerAllHotkeys()
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
            // Apply imported Dock icon policy immediately.
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

// MARK: - Custom Components

struct TabButton: View {
    let title: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 16, weight: isSelected ? .semibold : .regular))
                Text(title)
                    .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
            }
            .foregroundColor(isSelected ? .accentColor : .secondary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isSelected ? Color.accentColor.opacity(0.1) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
    }
}

struct SettingsCard<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.secondary.opacity(0.8))
                .textCase(.uppercase)
                .tracking(0.5)
            
            VStack(spacing: 8) {
                content
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Color.secondary.opacity(0.08), lineWidth: 0.5)
                    )
            )
        }
    }
}

struct AnimatedToggle: View {
    let title: String
    @Binding var isOn: Bool
    
    init(_ title: String, isOn: Binding<Bool>) {
        self.title = title
        self._isOn = isOn
    }
    
    var body: some View {
        Toggle(title, isOn: $isOn)
            .toggleStyle(SwitchToggleStyle(tint: .accentColor))
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isOn)
    }
}

struct ShortcutRow: View {
    let title: String
    let shortcut: String
    
    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 13))
            Spacer()
            Text(shortcut)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .foregroundColor(.secondary)
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.secondary.opacity(0.1))
                )
        }
    }
}

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
