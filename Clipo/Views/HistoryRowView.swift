import SwiftUI

struct HistoryRowView: View {
    let item: ClipItem
    var onTogglePin: () -> Void = {}
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Icon with subtle background
            ZStack {
                RoundedRectangle(cornerRadius: 7, style: .continuous)
                    .fill(iconBackgroundColor.opacity(0.12))
                    .frame(width: 30, height: 30)
                
                Image(systemName: iconName(for: item.type))
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(iconBackgroundColor.opacity(0.8))
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
                    }
                    
                    if let app = item.sourceApp {
                        Text(app)
                            .font(.caption2)
                            .foregroundColor(.secondary.opacity(0.7))
                            .lineLimit(1)
                    }
                    
                    TypeBadge(type: item.type)
                    
                    Spacer()
                    
                    Text(DateFormatterUtility.formattedString(from: item.createdAt))
                        .font(.caption2)
                        .foregroundColor(.secondary.opacity(0.5))
                }
            }
            
            // Pin / Unpin button
            Button(action: onTogglePin) {
                Image(systemName: item.isPinned ? "pin.fill" : "pin")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(
                        item.isPinned
                            ? .accentColor
                            : (isHovering ? .secondary.opacity(0.6) : .clear)
                    )
                    .frame(width: 20, height: 20)
                    .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
            .help(item.isPinned ? "Unpin" : "Pin")
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(isHovering ? Color.secondary.opacity(0.04) : Color.clear)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.12)) {
                isHovering = hovering
            }
        }
    }
    
    private var iconBackgroundColor: Color {
        switch item.type {
        case .url:
            return .blue
        case .codeLikeText:
            return .orange
        case .plainText:
            return .gray
        }
    }
    
    private func iconName(for type: ClipType) -> String {
        switch type {
        case .url:
            return "link"
        case .codeLikeText:
            return "chevron.left.forwardslash.chevron.right"
        case .plainText:
            return "doc.text"
        }
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
        case .url: return "URL"
        case .codeLikeText: return "Code"
        case .plainText: return "Text"
        }
    }
    
    private var typeColor: Color {
        switch type {
        case .url: return .blue
        case .codeLikeText: return .orange
        case .plainText: return .gray
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
                    type: .codeLikeText,
                    sourceApp: "Xcode",
                    isPinned: true
                )
            )
            HistoryRowView(
                item: ClipItem(
                    content: "https://github.com/hanazar/clipo",
                    type: .url,
                    sourceApp: "Safari"
                )
            )
            HistoryRowView(
                item: ClipItem(
                    content: "Meeting notes for tomorrow",
                    type: .plainText
                )
            )
        }
        .padding()
        .frame(width: 500)
    }
}
