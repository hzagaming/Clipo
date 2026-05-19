import SwiftUI
import AppKit

struct SettingsView: View {
    @StateObject private var store = ClipStore.shared
    @State private var showLaunchAtLoginAlert = false
    @State private var confirmationAlert: ConfirmationAlert?
    @State private var importExportAlert: ImportExportAlert?
    @State private var selectedTab = 0
    @State private var permissionStatus = PermissionService.shared.hasAccessibilityPermission()
    @State private var isWaitingForPermissionGrant = PermissionService.shared.isWaitingForAccessibilityGrant
    @State private var permissionTimer: Timer?
    @State private var newBundleId = ""
    @State private var volumeSliderValue: Double = ClipStore.shared.settings.soundVolume
    
    private var sidebarItems: [(title: String, icon: String)] {
        [
            (L10n.string(.tabGeneral), "gear"),
            (L10n.string(.tabShortcuts), "command"),
            (L10n.string(.tabClipboard), "doc.on.clipboard"),
            (L10n.string(.tabPrivacy), "shield"),
            (L10n.string(.tabData), "externaldrive"),
            (L10n.string(.tabInsights), "chart.bar"),
            (L10n.string(.tabSFX), "speaker.wave.2")
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
            refreshPermissionStatus()
            startPermissionTimer()
        }
        .onDisappear {
            stopPermissionTimer()
        }
        .onReceive(NotificationCenter.default.publisher(for: .accessibilityPermissionChanged)) { _ in
            refreshPermissionStatus()
        }
        .onChange(of: store.settings.soundVolume) { newValue in
            volumeSliderValue = newValue
        }
        .alert(isPresented: $showLaunchAtLoginAlert) {
            Alert(
                title: Text(L10n.string(.alertLaunchAtLoginTitle)),
                message: Text(L10n.string(.alertLaunchAtLoginMessage)),
                dismissButton: .default(Text(L10n.string(.okButton)))
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
                dismissButton: .default(Text(L10n.string(.okButton)))
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
                Text(L10n.string(.panelTitle))
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
                    case 0: generalTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 1: shortcutsTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 2: clipboardTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 3: privacyTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 4: dataTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 5: InsightsView().transition(.opacity.combined(with: .move(edge: .trailing)))
                    case 6: sfxTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    default: generalTab.transition(.opacity.combined(with: .move(edge: .trailing)))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .animation(.easeOut(duration: 0.2), value: selectedTab)
            }
        }
    }
    
    // MARK: - Status Bar
    
    private var statusBar: some View {
        HStack(spacing: 12) {
            StatusBadge(
                icon: permissionStatus ? "checkmark.shield.fill" : (isWaitingForPermissionGrant ? "clock" : "exclamationmark.shield.fill"),
                label: permissionStatus ? L10n.string(.statusAccessibilityOn) : (isWaitingForPermissionGrant ? L10n.string(.checkingPermission) : L10n.string(.statusAccessibilityOff)),
                color: permissionStatus ? .green : .orange
            )
            StatusBadge(
                icon: store.settings.launchAtLogin ? "checkmark.circle.fill" : "power.circle",
                label: store.settings.launchAtLogin ? L10n.string(.statusLaunchAtLoginOn) : L10n.string(.statusLaunchAtLoginOff),
                color: store.settings.launchAtLogin ? .green : .secondary
            )
            StatusBadge(
                icon: "doc.on.clipboard",
                label: L10n.string(.statusHistoryTemplate, store.history.count),
                color: .blue
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.history.count)
            StatusBadge(
                icon: "square.grid.2x2",
                label: L10n.string(.statusSlotsTemplate, store.slots.values.compactMap { $0 }.count),
                color: .accentColor
            )
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.slots.values.compactMap { $0 }.count)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(NSColor.controlBackgroundColor).opacity(0.4))
    }
    
    // MARK: - General Tab
    
    private var generalTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle(L10n.string(.sectionStartup))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "power",
                    title: L10n.string(.launchAtLoginTitle),
                    subtitle: L10n.string(.launchAtLoginSubtitle),
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
                    title: L10n.string(.showDockIconTitle),
                    subtitle: L10n.string(.showDockIconSubtitle),
                    isOn: $store.settings.showDockIcon
                )
                .onChange(of: store.settings.showDockIcon) { newValue in
                    let policy: NSApplication.ActivationPolicy = newValue ? .regular : .accessory
                    let success = NSApp.setActivationPolicy(policy)
                    if success {
                        if newValue {
                            NSApp.activate(ignoringOtherApps: true)
                            NotificationService.shared.showNotification(
                                title: L10n.string(.dockEnabledTitle),
                                body: L10n.string(.dockEnabledBody)
                            )
                        } else {
                            NotificationService.shared.showNotification(
                                title: L10n.string(.dockHiddenTitle),
                                body: L10n.string(.dockHiddenBody)
                            )
                        }
                    } else {
                        NotificationService.shared.showNotification(
                            title: L10n.string(.settingSavedTitle),
                            body: L10n.string(.settingSavedBody)
                        )
                    }
                }
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "menubar.rectangle",
                    title: L10n.string(.showMenuBarIconTitle),
                    subtitle: L10n.string(.showMenuBarIconSubtitle),
                    isOn: $store.settings.showMenuBarIcon
                )
                .onChange(of: store.settings.showMenuBarIcon) { _ in
                    if let appDelegate = NSApp.delegate as? AppDelegate {
                        appDelegate.setupStatusItem()
                    }
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionLanguage))
            VStack(spacing: 0) {
                HStack {
                    Image(systemName: "globe")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.string(.languageTitle))
                            .font(.system(size: 13, weight: .medium))
                        Text(L10n.string(.languageSubtitle))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Picker("", selection: $store.settings.language) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.displayName).tag(language)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 150)
                    .labelsHidden()
                }
                .padding(.vertical, 8)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionAppearance))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "bell",
                    title: L10n.string(.showNotificationsTitle),
                    subtitle: L10n.string(.showNotificationsSubtitle),
                    isOn: $store.settings.showNotifications
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "figure.walk.motion",
                    title: L10n.string(.reduceAnimationsTitle),
                    subtitle: L10n.string(.reduceAnimationsSubtitle),
                    isOn: $store.settings.reduceAnimations
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "square.grid.2x2",
                    title: L10n.string(.showEmptySlotsTitle),
                    subtitle: L10n.string(.showEmptySlotsSubtitle),
                    isOn: $store.settings.showEmptySlots
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "number.square",
                    title: L10n.string(.showSlotSectionTitle),
                    subtitle: L10n.string(.showSlotSectionSubtitle),
                    isOn: $store.settings.showSlotSection
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "app.badge",
                    title: L10n.string(.showSourceAppTitle),
                    subtitle: L10n.string(.showSourceAppSubtitle),
                    isOn: $store.settings.showSourceApp
                )
                
                Divider().padding(.leading, 44)
                
                HStack(spacing: 12) {
                    Image(systemName: "timer")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.string(.notificationDurationTitle))
                            .font(.system(size: 13, weight: .medium))
                        Text(L10n.string(.notificationDurationSubtitle))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.1fs", store.settings.notificationDuration))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 40, alignment: .trailing)
                    
                    Slider(value: $store.settings.notificationDuration, in: 1.0...5.0, step: 0.5)
                        .frame(width: 100)
                        .controlSize(.small)
                        .disabled(!store.settings.showNotifications)
                }
                .padding(.vertical, 8)
                .opacity(store.settings.showNotifications ? 1.0 : 0.5)
                
                Divider().padding(.leading, 44)
                
                HStack(spacing: 12) {
                    Image(systemName: "gauge.with.dots.needle.67percent")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.string(.panelAnimationSpeedTitle))
                            .font(.system(size: 13, weight: .medium))
                        Text(L10n.string(.panelAnimationSpeedSubtitle))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.1fx", store.settings.panelAnimationSpeed))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 40, alignment: .trailing)
                    
                    Slider(value: $store.settings.panelAnimationSpeed, in: 0.5...2.0, step: 0.1)
                        .frame(width: 100)
                        .controlSize(.small)
                        .disabled(store.settings.reduceAnimations)
                }
                .padding(.vertical, 8)
                .opacity(store.settings.reduceAnimations ? 0.5 : 1.0)
                
                Divider().padding(.leading, 44)
                
                HStack(spacing: 12) {
                    Image(systemName: "rectangle.stack.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.string(.panelOpacityTitle))
                            .font(.system(size: 13, weight: .medium))
                        Text(L10n.string(.panelOpacitySubtitle))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text("\(Int((store.settings.panelOpacity * 100).rounded()))%")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 32, alignment: .trailing)
                    
                    Slider(value: $store.settings.panelOpacity, in: 0.5...1.0, step: 0.05)
                        .frame(width: 100)
                        .controlSize(.small)
                }
                .padding(.vertical, 8)
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "arrow.up.and.down.compress",
                    title: L10n.string(.rowHeightCompactTitle),
                    subtitle: L10n.string(.rowHeightCompactSubtitle),
                    isOn: $store.settings.rowHeightCompact
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "clock",
                    title: L10n.string(.showTimestampTitle),
                    subtitle: L10n.string(.showTimestampSubtitle),
                    isOn: $store.settings.showTimestamp
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "tag",
                    title: L10n.string(.showTypeBadgeTitle),
                    subtitle: L10n.string(.showTypeBadgeSubtitle),
                    isOn: $store.settings.showTypeBadge
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "command",
                    title: L10n.string(.showFooterShortcutsTitle),
                    subtitle: L10n.string(.showFooterShortcutsSubtitle),
                    isOn: $store.settings.showFooterShortcuts
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "cursorarrow.click",
                    title: L10n.string(.clickOutsideClosesPanelTitle),
                    subtitle: L10n.string(.clickOutsideClosesPanelSubtitle),
                    isOn: $store.settings.clickOutsideClosesPanel
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
            sectionTitle(L10n.string(.sectionGlobalShortcuts))
            VStack(spacing: 0) {
                shortcutRow(
                    title: L10n.string(.openPanelShortcutTitle),
                    keyBinding: $store.settings.hotkeyPreferences.openPanelKeyCode,
                    modifierBinding: $store.settings.hotkeyPreferences.openPanelModifiers,
                    showKeyPicker: true
                )
                
                Divider().padding(.leading, 12)
                
                shortcutRow(
                    title: L10n.string(.saveSlotShortcutTitle),
                    keyBinding: .constant(0),
                    modifierBinding: $store.settings.hotkeyPreferences.saveSlotModifiers,
                    showKeyPicker: false
                )
                
                Divider().padding(.leading, 12)
                
                shortcutRow(
                    title: L10n.string(.copySlotShortcutTitle),
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
                    Text(L10n.string(.shortcutConflictWarning))
                        .font(.system(size: 12))
                        .foregroundColor(.orange.opacity(0.9))
                    Spacer()
                }
                .padding(.horizontal, 4)
            }
            
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "arrow.2.circlepath",
                    title: L10n.string(.keyboardWrapAroundTitle),
                    subtitle: L10n.string(.keyboardWrapAroundSubtitle),
                    isOn: $store.settings.keyboardWrapAround
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "escape",
                    title: L10n.string(.escapeClosesPanelTitle),
                    subtitle: L10n.string(.escapeClosesPanelSubtitle),
                    isOn: $store.settings.escapeClosesPanel
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            Button(action: {
                store.settings.hotkeyPreferences.resetToDefaults()
                HotkeyService.shared.registerAllHotkeys()
            }) {
                HStack(spacing: 6) {
                    Image(systemName: "arrow.counterclockwise")
                        .font(.system(size: 12))
                    Text(L10n.string(.resetShortcutsButton))
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
            sectionTitle(L10n.string(.sectionPasteBehavior))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "arrow.uturn.backward",
                    title: L10n.string(.restoreAfterPasteTitle),
                    subtitle: L10n.string(.restoreAfterPasteSubtitle),
                    isOn: $store.settings.restoreClipboardAfterPaste
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "arrow.uturn.backward",
                    title: L10n.string(.restoreAfterSaveTitle),
                    subtitle: L10n.string(.restoreAfterSaveSubtitle),
                    isOn: $store.settings.restoreClipboardAfterSave
                )
                
                Divider().padding(.leading, 44)
                
                HStack(spacing: 12) {
                    Image(systemName: "hourglass")
                        .font(.system(size: 16))
                        .foregroundColor(.accentColor)
                        .frame(width: 24)
                    
                    VStack(alignment: .leading, spacing: 2) {
                        Text(L10n.string(.pasteDelayTitle))
                            .font(.system(size: 13, weight: .medium))
                        Text(L10n.string(.pasteDelaySubtitle))
                            .font(.system(size: 11))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                    
                    Spacer()
                    
                    Text(String(format: "%.2fs", store.settings.pasteDelay))
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.secondary)
                        .frame(width: 48, alignment: .trailing)
                    
                    Slider(value: $store.settings.pasteDelay, in: 0.0...1.0, step: 0.05)
                        .frame(width: 100)
                        .controlSize(.small)
                }
                .padding(.vertical, 8)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionHistoryBehavior))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "doc.text.magnifyingglass",
                    title: L10n.string(.ignoreDuplicateHistoryTitle),
                    subtitle: L10n.string(.ignoreDuplicateHistorySubtitle),
                    isOn: $store.settings.ignoreDuplicateHistory
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "arrow.down.doc",
                    title: L10n.string(.pasteOnSelectionTitle),
                    subtitle: L10n.string(.pasteOnSelectionSubtitle),
                    isOn: $store.settings.pasteOnSelection
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "text.magnifyingglass",
                    title: L10n.string(.searchCaseSensitiveTitle),
                    subtitle: L10n.string(.searchCaseSensitiveSubtitle),
                    isOn: $store.settings.searchCaseSensitive
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "sparkle.magnifyingglass",
                    title: L10n.string(.searchFuzzyMatchingTitle),
                    subtitle: L10n.string(.searchFuzzyMatchingSubtitle),
                    isOn: $store.settings.searchFuzzyMatching
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "exclamationmark.triangle",
                    title: L10n.string(.confirmBeforeDeleteTitle),
                    subtitle: L10n.string(.confirmBeforeDeleteSubtitle),
                    isOn: $store.settings.confirmBeforeDelete
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionStorage))
            VStack(spacing: 0) {
                HStack {
                    Text(L10n.string(.maxHistoryItemsTitle))
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
                    Text(L10n.string(.autoDeleteUnpinnedTitle))
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
                    Text(L10n.string(.currentHistoryTitle))
                        .font(.system(size: 13))
                    Spacer()
                    Text(L10n.string(.currentHistoryCountTemplate, store.history.count))
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
            sectionTitle(L10n.string(.sectionAccessibilityPermission))
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Image(systemName: permissionStatus ? "checkmark.shield.fill" : "exclamationmark.shield.fill")
                        .font(.system(size: 16))
                        .foregroundColor(permissionStatus ? .green : .orange)
                    Text(permissionStatus ? L10n.string(.accessibilityGranted) : (isWaitingForPermissionGrant ? L10n.string(.checkingPermission) : L10n.string(.accessibilityRequired)))
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(permissionStatus ? .green : .orange)
                    Spacer()
                }
                
                Text(permissionStatus
                    ? L10n.string(.accessibilityEnabledDescription)
                    : (isWaitingForPermissionGrant
                        ? L10n.string(.accessibilityWaitingMessage)
                        : L10n.string(.accessibilityDescription)))
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                if !permissionStatus {
                    Button(action: {
                        PermissionService.shared.requestAccessibilityPermission()
                        PermissionService.shared.openAccessibilitySettings()
                        refreshPermissionStatus()
                    }) {
                        HStack(spacing: 6) {
                            Image(systemName: "gear")
                            Text(isWaitingForPermissionGrant ? L10n.string(.checkAgainButton) : L10n.string(.openSystemSettingsButton))
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
            
            sectionTitle(L10n.string(.sectionSecurity))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "eye.slash",
                    title: L10n.string(.ignoreSensitiveAppsTitle),
                    subtitle: L10n.string(.ignoreSensitiveAppsSubtitle),
                    isOn: $store.settings.ignoreSensitiveApps
                )
                
                Divider().padding(.leading, 44)
                
                ToggleRow(
                    icon: "lock.shield",
                    title: L10n.string(.autoClearOnScreenLockTitle),
                    subtitle: L10n.string(.autoClearOnScreenLockSubtitle),
                    isOn: $store.settings.autoClearOnScreenLock
                )
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionSensitiveAppBlacklist))
            VStack(alignment: .leading, spacing: 8) {
                if store.settings.sensitiveAppBundleIdentifiers.isEmpty {
                    Text(L10n.string(.noAppsBlacklisted))
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
                        Text(L10n.string(.addButton))
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
    
    // MARK: - Sound Effects Tab
    
    private var sfxTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle(L10n.string(.sectionSoundEffects))
            VStack(spacing: 0) {
                ToggleRow(
                    icon: "speaker.wave.2",
                    title: L10n.string(.sfxMasterToggle),
                    subtitle: L10n.string(.sfxMasterToggleSubtitle),
                    isOn: $store.settings.soundEnabled
                )
                
                VStack(spacing: 0) {
                    Divider().padding(.leading, 44)
                    
                    HStack(spacing: 12) {
                        Image(systemName: "speaker.wave.3")
                            .font(.system(size: 16))
                            .foregroundColor(.accentColor)
                            .frame(width: 24)
                        
                        Text(L10n.string(.sfxVolumeTitle))
                            .font(.system(size: 13, weight: .medium))
                        
                        Spacer()
                        
                        Text("\(Int((volumeSliderValue * 100).rounded()))%")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundColor(.secondary)
                            .frame(width: 32, alignment: .trailing)
                        
                        Slider(
                            value: $volumeSliderValue,
                            in: 0...1,
                            onEditingChanged: { isEditing in
                                if !isEditing {
                                    store.settings.soundVolume = volumeSliderValue
                                    SoundService.shared.playPreview()
                                }
                            }
                        )
                        .frame(width: 100)
                        .controlSize(.small)
                        .accessibilityLabel(L10n.string(.sfxVolumeTitle))
                    }
                    .padding(.vertical, 8)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "doc.on.doc", title: L10n.string(.sfxCopyToggle), isOn: $store.settings.soundCopyEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "doc.on.clipboard", title: L10n.string(.sfxPasteToggle), isOn: $store.settings.soundPasteEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "square.grid.2x2", title: L10n.string(.sfxSaveToggle), isOn: $store.settings.soundSaveEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "arrow.up.forward.app", title: L10n.string(.sfxOpenToggle), isOn: $store.settings.soundOpenEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "xmark.app", title: L10n.string(.sfxCloseToggle), isOn: $store.settings.soundCloseEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "exclamationmark.triangle", title: L10n.string(.sfxErrorToggle), isOn: $store.settings.soundErrorEnabled)
                    
                    Divider().padding(.leading, 44)
                    
                    sfxToggleRow(icon: "arrow.counterclockwise", title: L10n.string(.sfxResetToggle), isOn: $store.settings.soundResetEnabled)
                }
                .disabled(!store.settings.soundEnabled)
                .opacity(store.settings.soundEnabled ? 1.0 : 0.5)
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
        }
    }
    
    private func sfxToggleRow(icon: String, title: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.accentColor)
                .frame(width: 24)
            
            Text(title)
                .font(.system(size: 13, weight: .medium))
            
            Spacer()
            
            Toggle("", isOn: isOn)
                .toggleStyle(SwitchToggleStyle(tint: .accentColor))
                .labelsHidden()
                .accessibilityLabel(title)
        }
        .padding(.vertical, 8)
    }
    
    // MARK: - Data Tab
    
    private var dataTab: some View {
        VStack(alignment: .leading, spacing: 20) {
            sectionTitle(L10n.string(.sectionImportExport))
            VStack(spacing: 12) {
                HStack(spacing: 12) {
                    SettingsActionButton(title: L10n.string(.exportJSON), icon: "square.and.arrow.up") {
                        exportJSON()
                    }
                    SettingsActionButton(title: L10n.string(.importJSON), icon: "square.and.arrow.down") {
                        importJSON()
                    }
                }
                
                SettingsActionButton(title: L10n.string(.openDataFolder), icon: "folder") {
                    StorageService.shared.openStorageFolder()
                }
            }
            .padding(12)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor))
            )
            
            sectionTitle(L10n.string(.sectionDangerZone))
            VStack(spacing: 8) {
                DangerButton(title: L10n.string(.clearAllHistory)) {
                    confirmationAlert = ConfirmationAlert(
                        title: L10n.string(.alertClearHistoryTitle),
                        message: L10n.string(.alertClearHistoryMessage),
                        confirmButtonTitle: L10n.string(.alertClearHistoryConfirm),
                        action: {
                            store.clearHistory()
                            SoundService.shared.playReset()
                        }
                    )
                }
                
                DangerButton(title: L10n.string(.resetAllSlots)) {
                    confirmationAlert = ConfirmationAlert(
                        title: L10n.string(.alertResetSlotsTitle),
                        message: L10n.string(.alertResetSlotsMessage),
                        confirmButtonTitle: L10n.string(.alertResetSlotsConfirm),
                        action: {
                            store.resetSlots()
                            SoundService.shared.playReset()
                        }
                    )
                }
                
                DangerButton(title: L10n.string(.resetAllData)) {
                    confirmationAlert = ConfirmationAlert(
                        title: L10n.string(.alertResetAllTitle),
                        message: L10n.string(.alertResetAllMessage),
                        confirmButtonTitle: L10n.string(.alertResetAllConfirm),
                        action: {
                            store.resetAllData()
                            SoundService.shared.playReset()
                        }
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
            refreshPermissionStatus()
        }
    }
    
    private func stopPermissionTimer() {
        permissionTimer?.invalidate()
        permissionTimer = nil
    }

    private func refreshPermissionStatus() {
        permissionStatus = PermissionService.shared.refreshAccessibilityPermission()
        isWaitingForPermissionGrant = PermissionService.shared.isWaitingForAccessibilityGrant
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
        panel.title = L10n.string(.exportJSON)
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
                title: L10n.string(.exportSuccessTitle),
                body: L10n.string(.exportSuccessBody, url.lastPathComponent)
            )
        } catch {
            importExportAlert = ImportExportAlert(
                title: L10n.string(.exportFailedTitle),
                message: error.localizedDescription
            )
        }
    }
    
    private func importJSON() {
        let panel = NSOpenPanel()
        panel.title = L10n.string(.importJSON)
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
                    title: L10n.string(.importSuccessTitle),
                    body: L10n.string(.importSuccessBody, url.lastPathComponent)
                )
            } else {
                NotificationService.shared.showNotification(
                    title: L10n.string(.importSuccessTitle),
                    body: L10n.string(.importSuccessRestartBody)
                )
            }
        } catch {
            importExportAlert = ImportExportAlert(
                title: L10n.string(.importFailedTitle),
                message: L10n.string(.importFailedMessage)
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
        .buttonStyle(PressableButtonStyle(scale: 0.97))
        .scaleEffect(isSelected ? 1.0 : 0.98)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSelected)
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
                .accessibilityLabel(title)
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
