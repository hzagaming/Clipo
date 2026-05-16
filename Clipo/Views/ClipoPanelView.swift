import SwiftUI

extension Notification.Name {
    static let panelKeyboardEvent = Notification.Name("panelKeyboardEvent")
}

struct ClipoPanelView: View {
    @StateObject private var store = ClipStore.shared
    @State private var searchText = ""
    @State private var selectedIndex = 0
    @FocusState private var isSearchFocused: Bool
    @State private var appearAnimation = false
    @State private var searchFieldScale: CGFloat = 0.95
    @State private var searchFieldOpacity: Double = 0
    
    // MARK: - Data
    
    private var filteredHistory: [ClipItem] {
        if searchText.isEmpty { return store.history }
        return store.history.filter { $0.content.localizedCaseInsensitiveContains(searchText) }
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
        VStack(spacing: 0) {
            searchBar
            
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 0) {
                        if !slotSection.isEmpty {
                            sectionHeader("Slots")
                            ForEach(Array(slotSection.enumerated()), id: \.element.id) { index, row in
                                rowView(for: row, globalIndex: index)
                            }
                        }
                        
                        if !historySection.isEmpty {
                            sectionHeader("History")
                            let offset = slotSection.count
                            ForEach(Array(historySection.enumerated()), id: \.element.id) { index, row in
                                rowView(for: row, globalIndex: offset + index)
                            }
                        }
                        
                        if allItems.isEmpty {
                            emptyStateView
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onChange(of: selectedIndex) { newValue in
                    withAnimation(.easeInOut(duration: 0.15)) {
                        proxy.scrollTo(newValue, anchor: .center)
                    }
                }
            }
        }
        .frame(minWidth: 580, minHeight: 440)
        .background(Color(NSColor.windowBackgroundColor))
        .onAppear(perform: onAppear)
        .onDisappear(perform: onDisappear)
        .onChange(of: searchText) { _ in
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
        .padding(.bottom, 8)
        .scaleEffect(searchFieldScale)
        .opacity(searchFieldOpacity)
        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isSearchFocused)
    }
    
    private func sectionHeader(_ title: String) -> some View {
        HStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 1.5)
                .fill(Color.accentColor.opacity(0.6))
                .frame(width: 3, height: 12)
            
            Text(title)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.secondary.opacity(0.7))
                .textCase(.uppercase)
                .tracking(0.8)
        }
        .padding(.horizontal, 16)
        .padding(.top, 10)
        .padding(.bottom, 4)
    }
    
    private func rowView(for row: PanelListItem, globalIndex: Int) -> some View {
        Group {
            if row.isSlot, let num = row.slotNumber {
                SlotRowView(item: row.item, slotNumber: num)
            } else {
                HistoryRowView(item: row.item)
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
        .padding(.horizontal, 10)
        .padding(.vertical, 1)
        .id(globalIndex)
        .onTapGesture {
            withAnimation(.easeOut(duration: 0.15)) {
                selectedIndex = globalIndex
            }
            copyItem(row.item)
        }
        .animation(.spring(response: 0.2, dampingFraction: 0.8), value: selectedIndex)
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 40))
                .foregroundColor(.secondary.opacity(0.3))
            
            Text(searchText.isEmpty ? "No items yet" : "No results found")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.secondary.opacity(0.5))
            
            if searchText.isEmpty {
                Text("Select text and press ⌘⌥1–9 to save")
                    .font(.caption)
                    .foregroundColor(.secondary.opacity(0.35))
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.top, 60)
        .opacity(appearAnimation ? 1 : 0)
        .animation(.easeOut(duration: 0.4).delay(0.2), value: appearAnimation)
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
            if event.modifierFlags.contains(.command) {
                pasteItem(row.item)
            } else {
                copyItem(row.item)
                PanelWindowService.shared.hidePanel()
            }
        case 53: // Esc
            SoundService.shared.playClose()
            PanelWindowService.shared.hidePanel()
        default:
            break
        }
    }
    
    // MARK: - Actions
    
    private func copyItem(_ item: ClipItem) {
        SoundService.shared.playCopy()
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
    }
    
    private func pasteItem(_ item: ClipItem) {
        SoundService.shared.playPaste()
        let shouldRestore = store.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        PanelWindowService.shared.hidePanel()
    }
}

// MARK: - PanelListItem (Stable ID)

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

// MARK: - Preview

struct ClipoPanelView_Previews: PreviewProvider {
    static var previews: some View {
        ClipoPanelView()
            .frame(width: 580, height: 500)
    }
}
