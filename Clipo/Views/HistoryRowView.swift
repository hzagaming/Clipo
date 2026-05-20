import SwiftUI

struct HistoryRowView: View {
    let item: ClipItem
    var onTogglePin: () -> Void = {}
    var onDelete: () -> Void = {}
    var onCopy: () -> Void = {}
    var onPaste: () -> Void = {}
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Icon with subtle background
            ZStack {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(item.type.iconBackgroundColor.opacity(0.12))
                    .frame(width: 30, height: 30)
                
                Image(systemName: iconName(for: item.type))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(item.type.iconBackgroundColor.opacity(0.8))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(item.preview)
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium, design: .rounded))
                    .foregroundColor(.primary)
                
                HStack(spacing: 6) {
                    if item.isPinned {
                        HStack(spacing: 2) {
                            Image(systemName: "pin.fill")
                                .font(.system(size: 8, weight: .bold))
                            Text("Pinned")
                                .font(.system(size: 9, weight: .medium))
                        }
                        .foregroundColor(.accentColor)
                        .padding(.horizontal, 5)
                        .padding(.vertical, 1)
                        .background(
                            RoundedRectangle(cornerRadius: 4, style: .continuous)
                                .fill(Color.accentColor.opacity(0.1))
                        )
                        .transition(.scale(scale: 0.5, anchor: .leading).combined(with: .opacity))
                    }
                    
                    if let app = item.sourceApp, ClipStore.shared.settings.showSourceApp {
                        Text(app)
                            .font(.caption2)
                            .foregroundColor(.secondary.opacity(0.7))
                            .lineLimit(1)
                    }
                    
                    if ClipStore.shared.settings.showTypeBadge {
                        TypeBadge(type: item.type)
                    }
                    
                    Spacer()
                    
                    if ClipStore.shared.settings.showTimestamp {
                        Text(DateFormatterUtility.formattedString(from: item.createdAt))
                            .font(.caption2)
                            .foregroundColor(.secondary.opacity(0.5))
                    }
                }
            }
            
            // Hover action buttons
            HStack(spacing: 2) {
                Button(action: onTogglePin) {
                    Image(systemName: item.isPinned ? "pin.fill" : "pin")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(item.isPinned ? .accentColor : .secondary.opacity(0.5))
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                        .rotationEffect(.degrees(item.isPinned ? 0 : -45))
                        .animation(ClipStore.shared.settings.reduceAnimations ? nil : .spring(response: 0.3, dampingFraction: 0.6), value: item.isPinned)
                }
                .buttonStyle(HistoryRowButtonStyle())
                .help(item.isPinned ? "Unpin" : "Pin")
                
                Button(action: onDelete) {
                    Image(systemName: "trash")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary.opacity(0.5))
                        .frame(width: 24, height: 24)
                        .contentShape(Rectangle())
                }
                .buttonStyle(HistoryRowButtonStyle())
                .help("Delete")
            }
            .opacity(isHovering ? 1 : 0)
            .animation(ClipStore.shared.settings.reduceAnimations ? nil : .easeInOut(duration: 0.15), value: isHovering)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, ClipStore.shared.settings.rowHeightCompact ? 2 : 6)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(isHovering ? Color.secondary.opacity(0.04) : Color.clear)
                .animation(ClipStore.shared.settings.reduceAnimations ? nil : .easeInOut(duration: 0.15), value: isHovering)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            if ClipStore.shared.settings.reduceAnimations {
                isHovering = hovering
            } else {
                withAnimation(.easeInOut(duration: 0.12)) {
                    isHovering = hovering
                }
            }
        }
    }
    
    private func iconName(for type: ClipType) -> String {
        switch type {
        case ClipType.url:
            return "link"
        case ClipType.codeLikeText:
            return "chevron.left.forwardslash.chevron.right"
        case ClipType.plainText:
            return "doc.text"
        case ClipType.image:
            return "photo"
        case ClipType.file:
            return "doc"
        case ClipType.richText:
            return "textformat"
        case ClipType.data:
            return "shippingbox"
        }
    }
}

private struct HistoryRowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.92 : 1)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(ClipStore.shared.settings.reduceAnimations ? nil : .easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct TypeBadge: View {
    let type: ClipType
    
    var body: some View {
        Text(typeLabel)
            .font(.system(size: 9, weight: .medium))
            .foregroundColor(typeColor.opacity(0.8))
            .padding(.horizontal, 5)
            .padding(.vertical, 1)
            .background(
                RoundedRectangle(cornerRadius: 4, style: .continuous)
                    .fill(typeColor.opacity(0.1))
            )
    }
    
    private var typeLabel: String {
        switch type {
        case ClipType.plainText: return "Text"
        case ClipType.url: return "URL"
        case ClipType.codeLikeText: return "Code"
        case ClipType.image: return "Image"
        case ClipType.file: return "File"
        case ClipType.richText: return "Rich"
        case ClipType.data: return "Data"
        }
    }
    
    private var typeColor: Color {
        switch type {
        case ClipType.url: return .blue
        case ClipType.codeLikeText: return .orange
        case ClipType.plainText: return .gray
        case ClipType.image: return .purple
        case ClipType.file: return .green
        case ClipType.richText: return .pink
        case ClipType.data: return .secondary
        }
    }
}

// MARK: - Preview

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            HistoryRowView(
                item: ClipItem(
                    content: "import Foundation\nprint(\"Hello\")",
                    type: ClipType.codeLikeText,
                    sourceApp: "Xcode",
                    isPinned: true
                )
            )
            HistoryRowView(
                item: ClipItem(
                    content: "https://github.com/hanazar/clipo",
                    type: ClipType.url,
                    sourceApp: "Safari"
                )
            )
            HistoryRowView(
                item: ClipItem(
                    content: "Meeting notes for tomorrow",
                    type: ClipType.plainText
                )
            )
        }
        .padding()
        .frame(width: 500)
    }
}
