import SwiftUI

struct SlotRowView: View {
    let item: ClipItem
    let slotNumber: Int
    
    var body: some View {
        HStack(spacing: 12) {
            Text("\(slotNumber)")
                .font(.caption.bold())
                .frame(width: 24, height: 24)
                .background(Color.accentColor)
                .foregroundColor(.white)
                .cornerRadius(6)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(item.preview)
                    .lineLimit(1)
                    .font(.system(size: 13, weight: .medium, design: .default))
                HStack(spacing: 6) {
                    Text(item.type.rawValue)
                        .font(.caption2)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(DateFormatterUtility.formattedString(from: item.lastUsedAt))
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 4)
    }
}

struct SlotRowView_Previews: PreviewProvider {
    static var previews: some View {
        SlotRowView(
            item: ClipItem(
                content: "https://github.com/hanazar/clipo",
                type: .url
            ),
            slotNumber: 1
        )
        .padding()
        .frame(width: 400)
    }
}
