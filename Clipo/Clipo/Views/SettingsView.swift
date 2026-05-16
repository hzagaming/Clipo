import SwiftUI

struct SettingsView: View {
    @StateObject private var store = ClipStore.shared
    @State private var showLaunchAtLoginAlert = false
    @State private var confirmationAlert: ConfirmationAlert?
    
    var body: some View {
        TabView {
            generalTab
                .tabItem { Label("General", systemImage: "gear") }
            
            clipboardTab
                .tabItem { Label("Clipboard", systemImage: "doc.on.clipboard") }
            
            privacyTab
                .tabItem { Label("Privacy", systemImage: "shield") }
            
            dataTab
                .tabItem { Label("Data", systemImage: "externaldrive") }
        }
        .padding()
        .frame(width: 520, height: 380)
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
    }
    
    // MARK: - Tabs
    
    private var generalTab: some View {
        Form {
            Section {
                Toggle("Launch at Login", isOn: $store.settings.launchAtLogin)
                    .onChange(of: store.settings.launchAtLogin) { newValue in
                        LaunchAtLoginService.shared.setLaunchAtLogin(newValue)
                        // SMAppService requires code signing. If unsigned, the status won't change.
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            let actual = LaunchAtLoginService.shared.isLaunchAtLoginEnabled()
                            if actual != newValue {
                                store.settings.launchAtLogin = actual
                                showLaunchAtLoginAlert = true
                            }
                        }
                    }
                
                Toggle("Show Dock Icon", isOn: $store.settings.showDockIcon)
                    .disabled(true) // TODO: V2 implementation
            }
            
            Section {
                HStack {
                    Text("Open Clipo Panel")
                    Spacer()
                    Text("Option + Space")
                        .foregroundColor(.secondary)
                        .font(.system(.body, design: .monospaced))
                }
            }
        }
    }
    
    private var clipboardTab: some View {
        Form {
            Section {
                Toggle("Restore Previous Clipboard After Pasting", isOn: $store.settings.restoreClipboardAfterPaste)
                Toggle("Restore Previous Clipboard After Saving Selected Text", isOn: $store.settings.restoreClipboardAfterSave)
            }
            
            Section {
                Picker("Max History Items", selection: $store.settings.maxHistoryItems) {
                    Text("100").tag(100)
                    Text("200").tag(200)
                    Text("500").tag(500)
                }
                
                Picker("Auto Delete Unpinned History", selection: $store.settings.autoDeletePolicy) {
                    ForEach(AutoDeletePolicy.allCases) { policy in
                        Text(policy.displayName).tag(policy)
                    }
                }
            }
        }
    }
    
    private var privacyTab: some View {
        Form {
            Section {
                Toggle("Ignore Sensitive Apps", isOn: $store.settings.ignoreSensitiveApps)
            }
            
            Section(header: Text("Sensitive App Blacklist")) {
                List(store.settings.sensitiveAppBundleIdentifiers, id: \.self) { bundleId in
                    Text(bundleId)
                        .font(.system(.caption, design: .monospaced))
                }
                .frame(height: 120)
            }
            
            Section {
                Button("Clear All History") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Clear History",
                        message: "This will remove all unpinned history items. Are you sure?",
                        confirmButtonTitle: "Clear",
                        action: { store.clearHistory() }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.red)
                
                Button("Reset All Slots") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Reset Slots",
                        message: "This will clear all 9 slots. Are you sure?",
                        confirmButtonTitle: "Reset",
                        action: { store.resetSlots() }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.red)
            }
        }
    }
    
    private var dataTab: some View {
        Form {
            Section {
                Button("Export JSON") {
                    exportJSON()
                }
                .disabled(true) // TODO: V2
                
                Button("Import JSON") {
                    importJSON()
                }
                .disabled(true) // TODO: V2
                
                Button("Open Data Folder") {
                    StorageService.shared.openStorageFolder()
                }
            }
            
            Section {
                Button("Reset All Data") {
                    confirmationAlert = ConfirmationAlert(
                        title: "Reset All Data",
                        message: "This will erase all slots, history, and settings. This action cannot be undone.",
                        confirmButtonTitle: "Erase Everything",
                        action: { store.resetAllData() }
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .foregroundColor(.red)
            }
        }
    }
    
    // MARK: - Helpers
    
    private func exportJSON() {
        // Placeholder for V2
    }
    
    private func importJSON() {
        // Placeholder for V2
    }
}

// MARK: - Confirmation Alert Model

struct ConfirmationAlert: Identifiable {
    let id = UUID()
    let title: String
    let message: String
    let confirmButtonTitle: String
    let action: () -> Void
}

// MARK: - Preview

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
