import SwiftUI

struct SlotRowView: View {
    let item: ClipItem?
    let slotNumber: Int
    var onDelete: () -> Void = {}
    var onCopy: () -> Void = {}
    var onPaste: () -> Void = {}
    var onCreate: () -> Void = {}
    @State private var isHovering = false
    
    var body: some View {
        HStack(spacing: 10) {
            // Slot number badge
            ZStack {
                if let _ = item {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accentColor.opacity(0.9),
                                    Color.accentColor.opacity(0.7)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 30, height: 30)
                        .shadow(
                            color: Color.accentColor.opacity(0.25),
                            radius: 4,
                            x: 0,
                            y: 2
                        )
                } else {
                    RoundedRectangle(cornerRadius: 8, style: .continuous)
                        .stroke(Color.secondary.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                        .frame(width: 30, height: 30)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.secondary.opacity(0.04))
                        )
                }
                
                if item != nil {
                    Text("\(slotNumber)")
                        .font(.system(size: 13, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "plus")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.accentColor.opacity(0.75))
                }
            }
            
            if let item = item {
                // Filled slot
                VStack(alignment: .leading, spacing: ClipStore.shared.settings.rowHeightCompact ? 1 : 3) {
                    Text(item.preview)
                        .lineLimit(1)
                        .font(.system(size: 13, weight: .medium, design: .rounded))
                        .foregroundColor(.primary)
                    
                    HStack(spacing: 6) {
                        TypeBadge(type: item.type)
                        
                        Spacer()
                        
                        HStack(spacing: 3) {
                            Image(systemName: "clock")
                                .font(.system(size: 8))
                            Text(DateFormatterUtility.formattedString(from: item.lastUsedAt))
                                .font(.caption2)
                        }
                        .foregroundColor(.secondary.opacity(0.5))
                    }
                }
                
                // Hover action buttons
                HStack(spacing: 2) {
                    Button(action: onPaste) {
                        Image(systemName: "arrow.down.doc")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary.opacity(0.5))
                            .frame(width: 24, height: 24)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PressableButtonStyle())
                    .help(L10n.string(.footerPaste))
                    
                    Button(action: onDelete) {
                        Image(systemName: "xmark")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary.opacity(0.5))
                            .frame(width: 24, height: 24)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(PressableButtonStyle())
                    .help(L10n.string(.footerDelete))
                }
                .opacity(isHovering ? 1 : 0)
                .animation(.easeInOut(duration: 0.15), value: isHovering)
            } else {
                // Empty slot placeholder
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.string(.newSlot))
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(.secondary.opacity(0.65))
                    Text(L10n.string(.saveSlotHintTemplate, slotNumber))
                        .font(.system(size: 11))
                        .foregroundColor(.secondary.opacity(0.35))
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 7, style: .continuous)
                .fill(isHovering ? Color.secondary.opacity(0.04) : Color.clear)
                .animation(.easeInOut(duration: 0.15), value: isHovering)
        )
        .contentShape(Rectangle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
        .onTapGesture {
            if item == nil {
                onCreate()
            }
        }
    }
}

// MARK: - Preview

struct SlotRowView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 0) {
            SlotRowView(
                item: ClipItem(
                    content: "https://github.com/hanazar/clipo",
                    type: .url
                ),
                slotNumber: 1
            )
            SlotRowView(
                item: ClipItem(
                    content: "func hello() { print(\"world\") }",
                    type: .codeLikeText
                ),
                slotNumber: 2
            )
            SlotRowView(
                item: nil,
                slotNumber: 3
            )
            SlotRowView(
                item: nil,
                slotNumber: 4
            )
        }
        .padding()
        .frame(width: 500)
    }
}
