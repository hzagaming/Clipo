import SwiftUI
import AppKit

extension Notification.Name {
    static let panelKeyboardEvent = Notification.Name("panelKeyboardEvent")
    static let openClipoSettings = Notification.Name("openClipoSettings")
}

// MARK: - ClipType UI Helpers

extension ClipType {
    var filterColor: Color {
        switch self {
        case .plainText: return .gray
        case .url: return .blue
        case .codeLikeText: return .orange
        }
    }
}

struct ClipoPanelView: View {
    @StateObject private var store = ClipStore.shared
    @State private var searchText = ""
    @State private var selectedIndex = 0
    @FocusState private var isSearchFocused: Bool
    @State private var appearAnimation = false
    @State private var searchFieldScale: CGFloat = 0.95
    @State private var searchFieldOpacity: Double = 0
    @State private var showPermissionBanner = false
    @State private var permissionCheckTimer: Timer?
    @State private var selectedTypeFilter: ClipType? = nil
    
    // MARK: - Data
    
    private var filteredHistory: [ClipItem] {
        var items = searchText.isEmpty ? store.history : store.history.filter {
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
        if let filter = selectedTypeFilter {
            items = items.filter { $0.type == filter }
        }
        return items
    }
    
    private var allNavigableItems: [PanelListItem] {
        var items: [PanelListItem] = []
        for i in 1...9 {
            if let item = store.slots[i] {
                items.append(PanelListItem(isSlot: true, slotNumber: i, item: item))
            }
        }
        for item in filteredHistory {
            items.append(PanelListItem(isSlot: false, slotNumber: nil, item: item))
        }
        return items
    }
    
    private var slotNavigableIndices: [Int: Int] {
        var map: [Int: Int] = [:]
        for (index, item) in allNavigableItems.enumerated() {
            if item.isSlot, let num = item.slotNumber {
                map[num] = index
            }
        }
        return map
    }
    
    private var historySection: [PanelListItem] {
        allNavigableItems.filter { !$0.isSlot }
    }
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: 0) {
            headerBar
            
            if showPermissionBanner {
                permissionBanner
            }
            
            searchBar
            typeFilterBar
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        slotSectionView
                        historySectionView
                    }
                    .padding(.vertical, 6)
                }
                .onChange(of: selectedIndex) { newValue in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
            
            footerBar
        }
        .frame(minWidth: 580, minHeight: 480)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: searchText) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                selectedIndex = 0
            }
        }
        .onChange(of: selectedTypeFilter) { _ in
            withAnimation(.easeOut(duration: 0.2)) {
                selectedIndex = 0
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .panelKeyboardEvent)) { notification in
            guard let event = notification.object as? NSEvent else { return }
            handleKeyEvent(event)
        }
    }
    
    // MARK: - Lifecycle
    
    private func onAppear() {
        isSearchFocused = true
        selectedIndex = 0
        startPermissionCheck()
        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
            appearAnimation = true
            searchFieldScale = 1.0
            searchFieldOpacity = 1.0
        }
    }
    
    private func onDisappear() {
        appearAnimation = false
        searchFieldScale = 0.95
        searchFieldOpacity = 0
        stopPermissionCheck()
    }
    
    private func startPermissionCheck() {
        showPermissionBanner = !PermissionService.shared.hasAccessibilityPermission()
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let hasPermission = PermissionService.shared.hasAccessibilityPermission()
            if hasPermission && showPermissionBanner {
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showPermissionBanner = false
                    }
                }
            }
        }
    }
    
    private func stopPermissionCheck() {
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = nil
    }
    
    // MARK: - Subviews
    
    private var headerBar: some View {
        HStack(spacing: 0) {
            HStack(spacing: 6) {
                Image(systemName: "doc.on.clipboard")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.accentColor)
                Text("Clipo")
                    .font(.system(size: 15, weight: .bold))
            }
            
            Spacer()
            
            if !PermissionService.shared.hasAccessibilityPermission() {
                HStack(spacing: 4) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 9))
                        .foregroundColor(.orange)
                    Text("Needs Permission")
                        .font(.system(size: 10, weight: .medium))
                }
                .foregroundColor(.orange.opacity(0.8))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(4)
            }
            
            Button(action: {
                NotificationCenter.default.post(name: .openClipoSettings, object: nil)
            }) {
                Image(systemName: "gear")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.secondary.opacity(0.6))
                    .frame(width: 28, height: 28)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .help("Settings")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(
            Color(NSColor.windowBackgroundColor)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.secondary.opacity(0.08)),
                    alignment: .bottom
                )
        )
    }
    
    private var permissionBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.shield.fill")
                .font(.system(size: 12))
                .foregroundColor(.orange)
            Text("Accessibility permission is required for paste hotkeys.")
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.8))
            Spacer()
            Button(action: {
                PermissionService.shared.requestAccessibilityPermission()
                PermissionService.shared.openAccessibilitySettings()
            }) {
                Text("Open System Settings")
                    .font(.system(size: 11, weight: .semibold))
            }
            .buttonStyle(PlainButtonStyle())
            .foregroundColor(.accentColor)
            
            Button(action: {
                withAnimation(.easeOut(duration: 0.2)) {
                    showPermissionBanner = false
                }
            }) {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary.opacity(0.5))
            }
            .buttonStyle(PlainButtonStyle())
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.06))
        .overlay(
            Rectangle()
                .frame(height: 0.5)
                .foregroundColor(Color.orange.opacity(0.15)),
            alignment: .bottom
        )
    }
    
    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary.opacity(0.7))
            
            TextField("Search clips...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 14))
                .focused($isSearchFocused)
            
            if !searchText.isEmpty {
                Button(action: {
                    withAnimation(.easeOut(duration: 0.15)) {
                        searchText = ""
                    }
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 14))
                        .foregroundColor(.secondary.opacity(0.5))
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(
                            isSearchFocused ? Color.accentColor.opacity(0.4) : Color.secondary.opacity(0.06),
                            lineWidth: isSearchFocused ? 1.5 : 0.5
                        )
                )
                .shadow(
                    color: isSearchFocused ? Color.accentColor.opacity(0.1) : Color.clear,
                    radius: 6,
                    x: 0,
                    y: 2
                )
        )
        .padding(.horizontal, 12)
        .padding(.top, 8)
        .padding(.bottom, 6)
        .scaleEffect(searchFieldScale)
        .opacity(searchFieldOpacity)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSearchFocused)
    }
    
    private var typeFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                FilterPill(
                    title: "All",
                    color: .accentColor,
                    isSelected: selectedTypeFilter == nil
                ) {
                    selectedTypeFilter = nil
                }
                ForEach(ClipType.allCases, id: \.self) { type in
                    FilterPill(
                        title: type.displayName,
                        color: type.filterColor,
                        isSelected: selectedTypeFilter == type
                    ) {
                        selectedTypeFilter = type
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 4)
        }
    }
    
    private func sectionHeader(_ title: String, count: Int, total: Int? = nil) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color.accentColor.opacity(0.6))
                .frame(width: 3, height: 12)
            
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary.opacity(0.7))
                .textCase(.uppercase)
                .tracking(0.8)
            
            if let total = total {
                Text("\(count)/\(total)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.4))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(
                        Capsule()
                            .fill(Color.secondary.opacity(0.08))
                    )
            } else {
                Text("\(count)")
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.4))
                    .padding(.horizontal, 5)
                    .padding(.vertical, 1)
                    .background(
                        Capsule()
                            .fill(Color.secondary.opacity(0.08))
                    )
            }
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 4)
    }
    
    private var slotSectionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Slots", count: store.slots.count, total: 9)
            VStack(spacing: 2) {
                ForEach(1...9, id: \.self) { num in
                    if let item = store.slots[num] {
                        let globalIndex = slotNavigableIndices[num] ?? 0
                        rowView(
                            for: PanelListItem(isSlot: true, slotNumber: num, item: item),
                            globalIndex: globalIndex
                        )
                    } else {
                        SlotRowView(item: nil, slotNumber: num)
                    }
                }
            }
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Color(NSColor.controlBackgroundColor).opacity(0.35))
            )
            .padding(.horizontal, 10)
        }
    }
    
    private var historySectionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Recent History", count: historySection.count)
            if historySection.isEmpty {
                historyOnboardingView
            } else {
                VStack(spacing: 2) {
                    let offset = slotNavigableIndices.count
                    ForEach(Array(historySection.enumerated()), id: \.element.id) { index, row in
                        rowView(for: row, globalIndex: offset + index)
                    }
                }
                .padding(.vertical, 4)
                .background(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color(NSColor.controlBackgroundColor).opacity(0.2))
                )
                .padding(.horizontal, 10)
            }
        }
    }
    
    private var historyOnboardingView: some View {
        VStack(spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: "doc.text")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary.opacity(0.3))
                VStack(alignment: .leading, spacing: 2) {
                    Text("No history yet")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.secondary.opacity(0.5))
                    Text("Save clips to slots and they will appear here")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary.opacity(0.35))
                }
                Spacer()
            }
            
            Divider()
                .padding(.vertical, 2)
            
            VStack(spacing: 8) {
                OnboardingStep(number: 1, text: "Select text in any app")
                OnboardingStep(number: 2, text: "Press ⌥1–9 to save to a slot")
                OnboardingStep(number: 3, text: "Press ⌥Space to open Clipo")
                OnboardingStep(number: 4, text: "Press ↵ to copy, ⌘↵ to paste")
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.25))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .stroke(Color.secondary.opacity(0.06), lineWidth: 0.5)
                )
        )
        .padding(.horizontal, 10)
    }
    
    private var footerBar: some View {
        HStack(spacing: 14) {
            FooterShortcut(keys: "↑↓", label: "Select")
            FooterShortcut(keys: "↵", label: "Copy")
            FooterShortcut(keys: "⌘↵", label: "Paste")
            FooterShortcut(keys: "⌘P", label: "Pin")
            FooterShortcut(keys: "⌫", label: "Delete")
            Spacer()
            FooterShortcut(keys: "esc", label: "Close")
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 8)
        .background(
            Color(NSColor.controlBackgroundColor).opacity(0.5)
                .overlay(
                    Rectangle()
                        .frame(height: 0.5)
                        .foregroundColor(Color.secondary.opacity(0.1)),
                    alignment: .top
                )
        )
    }
    
    private func rowView(for row: PanelListItem, globalIndex: Int) -> some View {
        Group {
            if row.isSlot, let num = row.slotNumber {
                SlotRowView(
                    item: row.item,
                    slotNumber: num,
                    onDelete: {
                        store.deleteSlot(number: num)
                        if selectedIndex >= allNavigableItems.count {
                            selectedIndex = max(0, allNavigableItems.count - 1)
                        }
                    },
                    onCopy: {
                        copyItem(row.item)
                        PanelWindowService.shared.hidePanel()
                    },
                    onPaste: { pasteItem(row.item) }
                )
            } else {
                HistoryRowView(
                    item: row.item,
                    onTogglePin: { store.togglePin(id: row.item.id) },
                    onDelete: {
                        store.deleteHistoryItem(id: row.item.id)
                        if selectedIndex >= allNavigableItems.count {
                            selectedIndex = max(0, allNavigableItems.count - 1)
                        }
                    },
                    onCopy: {
                        copyItem(row.item)
                        PanelWindowService.shared.hidePanel()
                    },
                    onPaste: { pasteItem(row.item) }
                )
            }
        }
        .contentShape(Rectangle())
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(selectedIndex == globalIndex ? Color.accentColor.opacity(0.12) : Color.clear)
                .overlay(
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(
                            selectedIndex == globalIndex ? Color.accentColor.opacity(0.25) : Color.clear,
                            lineWidth: 1
                        )
                )
        )
        .padding(.horizontal, 6)
        .padding(.vertical, 1)
        .id(globalIndex)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.15)) {
                selectedIndex = globalIndex
            }
            copyItem(row.item)
            PanelWindowService.shared.hidePanel()
        }
        .contextMenu {
            Button("Copy") {
                copyItem(row.item)
                PanelWindowService.shared.hidePanel()
            }
            .keyboardShortcut(.return, modifiers: [])
            Button("Paste") { pasteItem(row.item) }
                .keyboardShortcut(.return, modifiers: .command)
            if !row.isSlot {
                Divider()
                Button(row.item.isPinned ? "Unpin" : "Pin") {
                    store.togglePin(id: row.item.id)
                }
                .keyboardShortcut("p", modifiers: .command)
                Button("Delete") {
                    store.deleteHistoryItem(id: row.item.id)
                    if selectedIndex >= allNavigableItems.count {
                        selectedIndex = max(0, allNavigableItems.count - 1)
                    }
                }
                .keyboardShortcut(.delete, modifiers: [])
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: selectedIndex)
    }
    
    // MARK: - Keyboard Handling
    
    func handleKeyEvent(_ event: NSEvent) {
        switch event.keyCode {
        case 126: // Up arrow
            if selectedIndex > 0 {
                withAnimation(.easeOut(duration: 0.1)) {
                    selectedIndex -= 1
                }
            }
        case 125: // Down arrow
            if selectedIndex < allNavigableItems.count - 1 {
                withAnimation(.easeOut(duration: 0.1)) {
                    selectedIndex += 1
                }
            }
        case 36: // Return
            guard selectedIndex < allNavigableItems.count else { return }
            let row = allNavigableItems[selectedIndex]
            if isOnlyCommandPressed(event) {
                pasteItem(row.item)
            } else {
                copyItem(row.item)
                PanelWindowService.shared.hidePanel()
            }
        case 53: // Esc
            PanelWindowService.shared.hidePanel()
        case 51: // Delete (Backspace)
            guard searchText.isEmpty else { return }
            guard selectedIndex < allNavigableItems.count else { return }
            let row = allNavigableItems[selectedIndex]
            if !row.isSlot {
                store.deleteHistoryItem(id: row.item.id)
                if selectedIndex >= allNavigableItems.count {
                    selectedIndex = max(0, allNavigableItems.count - 1)
                }
            }
        case 35: // 'P'
            if isOnlyCommandPressed(event) {
                guard selectedIndex < allNavigableItems.count else { return }
                let row = allNavigableItems[selectedIndex]
                if !row.isSlot {
                    store.togglePin(id: row.item.id)
                }
            }
        default:
            break
        }
    }
    
    /// Checks that the only modifier pressed is Command (no Shift, Option, or Control).
    private func isOnlyCommandPressed(_ event: NSEvent) -> Bool {
        let mods = event.modifierFlags.intersection([.command, .shift, .option, .control])
        return mods == .command
    }
    
    // MARK: - Actions
    
    private func copyItem(_ item: ClipItem) {
        SoundService.shared.playCopy()
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
    }
    
    private func pasteItem(_ item: ClipItem) {
        guard PermissionService.shared.hasAccessibilityPermission() else {
            NotificationService.shared.showNotification(
                title: "Permission Required",
                body: "Clipo needs Accessibility permission to paste text.",
                isError: true
            )
            return
        }
        SoundService.shared.playPaste()
        let shouldRestore = store.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        PanelWindowService.shared.hidePanel()
    }
}

// MARK: - PanelListItem

struct PanelListItem: Identifiable {
    var id: String {
        if isSlot, let num = slotNumber {
            return "slot-\(num)"
        } else {
            return "hist-\(item.id.uuidString)"
        }
    }
    let isSlot: Bool
    let slotNumber: Int?
    let item: ClipItem
}

// MARK: - FilterPill

struct FilterPill: View {
    let title: String
    let color: Color
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 11, weight: isSelected ? .semibold : .medium))
                .foregroundColor(isSelected ? .white : .secondary.opacity(0.7))
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(
                    Capsule()
                        .fill(isSelected ? color.opacity(0.85) : Color.secondary.opacity(0.06))
                )
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : Color.secondary.opacity(0.1), lineWidth: 0.5)
                )
        }
        .buttonStyle(PlainButtonStyle())
        .animation(.spring(response: 0.25, dampingFraction: 0.8), value: isSelected)
    }
}

// MARK: - FooterShortcut

struct FooterShortcut: View {
    let keys: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(keys)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary.opacity(0.6))
                .padding(.horizontal, 4)
                .padding(.vertical, 2)
                .background(
                    RoundedRectangle(cornerRadius: 4, style: .continuous)
                        .fill(Color.secondary.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .stroke(Color.secondary.opacity(0.12), lineWidth: 0.5)
                        )
                )
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary.opacity(0.45))
        }
    }
}

// MARK: - OnboardingStep

struct OnboardingStep: View {
    let number: Int
    let text: String
    
    var body: some View {
        HStack(spacing: 8) {
            Text("\(number)")
                .font(.system(size: 10, weight: .bold))
                .foregroundColor(.accentColor)
                .frame(width: 18, height: 18)
                .background(
                    Circle()
                        .fill(Color.accentColor.opacity(0.1))
                )
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.secondary.opacity(0.6))
            Spacer()
        }
    }
}

// MARK: - Preview

struct ClipoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ClipoPanelView()
            .frame(width: 580, height: 640)
    }
}
