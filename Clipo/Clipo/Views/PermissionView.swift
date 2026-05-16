import SwiftUI

struct PermissionView: View {
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "hand.tap.fill")
                .font(.system(size: 48))
                .foregroundColor(.accentColor)
            
            Text("Accessibility Permission Required")
                .font(.title2.bold())
            
            Text("Clipo needs Accessibility permission to simulate copy and paste using global shortcuts.")
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Button("Open System Settings") {
                PermissionService.shared.openAccessibilitySettings()
            }
            .controlSize(.large)
            
            Text("Please add Clipo to Accessibility, then restart the app.")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .frame(width: 480, height: 300)
    }
}

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView()
    }
}
