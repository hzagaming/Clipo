import SwiftUI

struct HistoryRowView: View {
    let item: ClipItem
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: iconName(for: item.type))
                .frame(width: 24, height: 24)
                .foregroundColor(.secondary)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.preview)
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium, design: .default))
                HStack(spacing: 6) {
                    if item.isPinned {
                        Image(systemName: "pin.fill")
                            .font(.caption2)
                            .foregroundColor(.accentColor)
                    }
                    if let app = item.sourceApp {
                        Text(app)
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    Text(item.type.rawValue)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(DateFormatterUtility.formattedString(from: item.createdAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
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

struct HistoryRowView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryRowView(
            item: ClipItem(
                content: "import Foundation\nprint(\"Hello\")",
                type: .codeLikeText,
                sourceApp: "Xcode",
                isPinned: true
            )
        )
        .padding()
        .frame(width: 400)
    }
}
