import SwiftUI

extension Notification.Name {
    static let panelKeyboardEvent = Notification.Name("panelKeyboardEvent")
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
    @State private var showPermissionOverlay = false
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
    
    private var allItems: [PanelListItem] {
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
    
    private var slotSection: [PanelListItem] {
        allItems.filter { $0.isSlot }
    }
    
    private var historySection: [PanelListItem] {
        allItems.filter { !$0.isSlot }
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                // Header: search + type filters
                VStack(spacing: 0) {
                    searchBar
                    typeFilterBar
                }
                
                // Content list
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 0) {
                            if !slotSection.isEmpty {
                                slotSectionView
                            }
                            
                            if !historySection.isEmpty {
                                historySectionView
                            }
                            
                            if allItems.isEmpty {
                                emptyStateView
                            }
                        }
                        .padding(.vertical, 6)
                    }
                    .onChange(of: selectedIndex) { newValue in
                        withAnimation(.easeInOut(duration: 0.15)) {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
                
                // Footer shortcuts bar
                footerBar
            }
            .frame(minWidth: 580, minHeight: 480)
            .background(Color(NSColor.windowBackgroundColor))
            
            if showPermissionOverlay {
                permissionOverlay
            }
        }
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
        showPermissionOverlay = !PermissionService.shared.hasAccessibilityPermission()
        permissionCheckTimer?.invalidate()
        permissionCheckTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            let hasPermission = PermissionService.shared.hasAccessibilityPermission()
            if hasPermission && showPermissionOverlay {
                DispatchQueue.main.async {
                    withAnimation(.easeOut(duration: 0.3)) {
                        showPermissionOverlay = false
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
        .padding(.top, 12)
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
    
    private func sectionHeader(_ title: String, count: Int) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color.accentColor.opacity(0.6))
                .frame(width: 3, height: 12)
            
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary.opacity(0.7))
                .textCase(.uppercase)
                .tracking(0.8)
            
            Text("\(count)")
                .font(.system(size: 10, weight: .semibold))
                .foregroundColor(.secondary.opacity(0.4))
                .padding(.horizontal, 5)
                .padding(.vertical, 1)
                .background(
                    Capsule()
                        .fill(Color.secondary.opacity(0.08))
                )
            
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 4)
    }
    
    private var slotSectionView: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader("Slots", count: slotSection.count)
            VStack(spacing: 2) {
                ForEach(Array(slotSection.enumerated()), id: \.element.id) { index, row in
                    rowView(for: row, globalIndex: index)
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
            sectionHeader("History", count: historySection.count)
            VStack(spacing: 2) {
                let offset = slotSection.count
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
    
    private var emptyStateView: some View {
        VStack(spacing: 24) {
            ZStack {
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.accentColor.opacity(0.08))
                    .frame(width: 80, height: 80)
                Image(systemName: "doc.on.clipboard.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.accentColor.opacity(0.7))
            }
            
            VStack(spacing: 6) {
                Text("Welcome to Clipo")
                    .font(.system(size: 18, weight: .bold))
                Text("Your clipboard, supercharged")
                    .font(.system(size: 13))
                    .foregroundColor(.secondary.opacity(0.7))
            }
            
            VStack(spacing: 10) {
                QuickTipRow(
                    icon: "arrow.down.circle.fill",
                    title: "Save",
                    description: "Select text, then press ⌥1–9 to save to a slot"
                )
                QuickTipRow(
                    icon: "arrow.up.circle.fill",
                    title: "Paste",
                    description: "Press ⌥Space to open Clipo, then ↵ to paste"
                )
                QuickTipRow(
                    icon: "magnifyingglass.circle.fill",
                    title: "Search",
                    description: "Type to filter your history and slots instantly"
                )
            }
            .padding(.top, 8)
            
            VStack(spacing: 6) {
                Text("Keyboard Shortcuts")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(.secondary.opacity(0.5))
                    .textCase(.uppercase)
                    .tracking(0.5)
                
                HStack(spacing: 12) {
                    ShortcutBadge(keys: "⌥Space", label: "Open")
                    ShortcutBadge(keys: "⌥1–9", label: "Save")
                    ShortcutBadge(keys: "⌘↵", label: "Paste")
                }
            }
            .padding(.top, 8)
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 36)
        .padding(.bottom, 24)
        .opacity(appearAnimation ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: appearAnimation)
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
                        if selectedIndex >= allItems.count {
                            selectedIndex = max(0, allItems.count - 1)
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
                        if selectedIndex >= allItems.count {
                            selectedIndex = max(0, allItems.count - 1)
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
                    if selectedIndex >= allItems.count {
                        selectedIndex = max(0, allItems.count - 1)
                    }
                }
                .keyboardShortcut(.delete, modifiers: [])
            }
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: selectedIndex)
    }
    
    private var permissionOverlay: some View {
        ZStack {
            Color.black.opacity(0.25)
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.12))
                        .frame(width: 70, height: 70)
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 32))
                        .foregroundColor(.accentColor)
                }
                
                VStack(spacing: 8) {
                    Text("Accessibility Permission")
                        .font(.system(size: 17, weight: .bold))
                    
                    Text("Clipo needs Accessibility permission to simulate copy and paste using global shortcuts.")
                        .font(.system(size: 13))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                        .padding(.horizontal, 8)
                }
                
                VStack(spacing: 10) {
                    Button(action: {
                        PermissionService.shared.requestAccessibilityPermission()
                        PermissionService.shared.openAccessibilitySettings()
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "gear")
                            Text("Open System Settings")
                                .fontWeight(.semibold)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                    }
                    .buttonStyle(GlassButtonStyle())
                    
                    Button(action: {
                        withAnimation(.easeOut(duration: 0.3)) {
                            showPermissionOverlay = false
                        }
                    }) {
                        Text("Skip for now")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary.opacity(0.6))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(24)
            .frame(width: 340)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(NSColor.windowBackgroundColor))
                    .shadow(color: Color.black.opacity(0.25), radius: 24, x: 0, y: 12)
            )
        }
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
            if selectedIndex < allItems.count - 1 {
                withAnimation(.easeOut(duration: 0.1)) {
                    selectedIndex += 1
                }
            }
        case 36: // Return
            guard selectedIndex < allItems.count else { return }
            let row = allItems[selectedIndex]
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
            guard selectedIndex < allItems.count else { return }
            let row = allItems[selectedIndex]
            if !row.isSlot {
                store.deleteHistoryItem(id: row.item.id)
                if selectedIndex >= allItems.count {
                    selectedIndex = max(0, allItems.count - 1)
                }
            }
        case 35: // 'P'
            if isOnlyCommandPressed(event) {
                guard selectedIndex < allItems.count else { return }
                let row = allItems[selectedIndex]
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

// MARK: - QuickTipRow

struct QuickTipRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(.accentColor.opacity(0.7))
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(.primary.opacity(0.8))
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.secondary.opacity(0.6))
            }
            
            Spacer()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Color(NSColor.controlBackgroundColor).opacity(0.5))
        )
        .frame(width: 320)
    }
}

// MARK: - ShortcutBadge

struct ShortcutBadge: View {
    let keys: String
    let label: String
    
    var body: some View {
        HStack(spacing: 4) {
            Text(keys)
                .font(.system(size: 10, weight: .semibold, design: .rounded))
                .foregroundColor(.secondary.opacity(0.6))
                .padding(.horizontal, 5)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 5, style: .continuous)
                        .fill(Color.secondary.opacity(0.08))
                        .overlay(
                            RoundedRectangle(cornerRadius: 5, style: .continuous)
                                .stroke(Color.secondary.opacity(0.12), lineWidth: 0.5)
                        )
                )
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundColor(.secondary.opacity(0.45))
        }
    }
}

// MARK: - Preview

struct ClipoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ClipoPanelView()
            .frame(width: 580, height: 500)
    }
}
