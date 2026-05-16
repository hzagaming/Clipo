import SwiftUI

struct ClipoPanelView: View {
    @StateObject private var store = ClipStore.shared
    @State private var searchText = ""
    @State private var selectedIndex = 0
    @FocusState private var isSearchFocused: Bool
    @State private var monitor: Any?
    
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
                            Text("No items found")
                                .foregroundColor(.secondary)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 40)
                        }
                    }
                }
                .onChange(of: selectedIndex) { newValue in
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
        .frame(minWidth: 560, minHeight: 420)
        .onAppear {
            // Defensive: remove any previous monitor to prevent duplicates
            // in case onDisappear was not called (e.g. orderOut without view teardown).
            if let existing = monitor {
                NSEvent.removeMonitor(existing)
            }
            isSearchFocused = true
            selectedIndex = 0
            monitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown, handler: handleKeyEvent)
        }
        .onDisappear {
            if let existing = monitor {
                NSEvent.removeMonitor(existing)
                monitor = nil
            }
        }
        .onChange(of: searchText) { _ in
            selectedIndex = 0
        }
    }
    
    // MARK: - Subviews
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            TextField("Search clips...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .focused($isSearchFocused)
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding(10)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func sectionHeader(_ title: String) -> some View {
        Text(title)
            .font(.caption.bold())
            .foregroundColor(.secondary)
            .padding(.horizontal)
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
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(selectedIndex == globalIndex ? Color.accentColor.opacity(0.15) : Color.clear)
        )
        .padding(.horizontal, 8)
        .padding(.vertical, 2)
        .id(globalIndex)
        .onTapGesture {
            selectedIndex = globalIndex
            copyItem(row.item)
        }
    }
    
    // MARK: - Keyboard Handling
    
    private func handleKeyEvent(_ event: NSEvent) -> NSEvent? {
        // Allow typing in the search field without interception.
        if isSearchFocused && event.keyCode != 53 && event.keyCode != 36 && !(event.keyCode == 125 || event.keyCode == 126) {
            return event
        }
        
        switch event.keyCode {
        case 126: // Up arrow
            if selectedIndex > 0 {
                selectedIndex -= 1
            }
            return nil
        case 125: // Down arrow
            if selectedIndex < allItems.count - 1 {
                selectedIndex += 1
            }
            return nil
        case 36: // Return
            guard selectedIndex < allItems.count else { return nil }
            let row = allItems[selectedIndex]
            if event.modifierFlags.contains(.command) {
                pasteItem(row.item)
            } else {
                copyItem(row.item)
                PanelWindowService.shared.hidePanel()
            }
            return nil
        case 53: // Esc
            PanelWindowService.shared.hidePanel()
            return nil
        default:
            return event
        }
    }
    
    // MARK: - Actions
    
    private func copyItem(_ item: ClipItem) {
        ClipboardService.shared.writeTextToPasteboard(item.content)
        NotificationService.shared.showNotification(title: "Copied", body: item.preview)
    }
    
    private func pasteItem(_ item: ClipItem) {
        let shouldRestore = store.settings.restoreClipboardAfterPaste
        PasteService.shared.pasteText(item.content, restorePrevious: shouldRestore)
        PanelWindowService.shared.hidePanel()
    }
}

// MARK: - PanelListItem (Stable ID)

private struct PanelListItem: Identifiable {
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
    }
}
