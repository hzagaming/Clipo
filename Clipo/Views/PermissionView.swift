import SwiftUI

struct PermissionView: View {
    @State private var appear = false
    @State private var iconScale: CGFloat = 0.5
    @State private var iconRotation: Double = -30
    var onSkip: (() -> Void)? = nil
    
    var body: some View {
        ZStack {
            // Subtle gradient background
            LinearGradient(
                colors: [
                    Color(NSColor.controlBackgroundColor).opacity(0.8),
                    Color(NSColor.windowBackgroundColor)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 24) {
                // Animated icon
                ZStack {
                    Circle()
                        .fill(Color.accentColor.opacity(0.12))
                        .frame(width: 90, height: 90)
                    
                    Circle()
                        .stroke(Color.accentColor.opacity(0.2), lineWidth: 1.5)
                        .frame(width: 90, height: 90)
                    
                    Image(systemName: "hand.tap.fill")
                        .font(.system(size: 40))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Color.accentColor, Color.accentColor.opacity(0.7)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(iconScale)
                        .rotationEffect(.degrees(iconRotation))
                }
                .padding(.top, 8)
                
                // Title with fade-in
                VStack(spacing: 10) {
                    Text("Accessibility Permission")
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 12)
                    
                    Text("Required to simulate copy and paste using global shortcuts.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .font(.system(size: 13))
                        .lineLimit(2)
                        .padding(.horizontal, 32)
                        .opacity(appear ? 1 : 0)
                        .offset(y: appear ? 0 : 10)
                    
                    HStack(spacing: 6) {
                        Image(systemName: "menubar.rectangle")
                            .font(.system(size: 11))
                        Text("Clipo lives in your menu bar — look for the clipboard icon.")
                            .font(.system(size: 11, weight: .medium))
                    }
                    .foregroundColor(.accentColor.opacity(0.8))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        RoundedRectangle(cornerRadius: 6, style: .continuous)
                            .fill(Color.accentColor.opacity(0.08))
                    )
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 8)
                }
                
                Spacer()
                
                // Action buttons
                VStack(spacing: 12) {
                    Button(action: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            iconScale = 0.85
                        }
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.5)) {
                                iconScale = 1.0
                            }
                        }
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
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 8)
                    
                    Button(action: {
                        onSkip?()
                    }) {
                        Text("Skip for now")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary.opacity(0.6))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(
                                RoundedRectangle(cornerRadius: 6, style: .continuous)
                                    .fill(Color.secondary.opacity(0.06))
                            )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(appear ? 1 : 0)
                    .offset(y: appear ? 0 : 6)
                    
                    VStack(spacing: 6) {
                        Text("1. Open System Settings → Privacy & Security → Accessibility")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.7))
                        Text("2. Add Clipo to the list and enable the checkbox")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.7))
                        Text("3. The app will detect it and continue automatically")
                            .font(.caption)
                            .foregroundColor(.secondary.opacity(0.7))
                        
                        // Debug-build hint: ad-hoc signed apps change identity on every rebuild,
                        // so the old permission entry becomes stale.
                        #if DEBUG
                        Text("Debug build: if permission is already on but not working, remove the old Clipo entry in Accessibility and re-add the current build.")
                            .font(.caption2)
                            .foregroundColor(.orange.opacity(0.85))
                            .multilineTextAlignment(.center)
                            .padding(.top, 4)
                        #endif
                    }
                    .opacity(appear ? 1 : 0)
                }
                .padding(.bottom, 8)
            }
            .padding(32)
        }
        .frame(width: 480, height: 400)
        .onAppear(perform: startAnimation)
    }
    
    private func startAnimation() {
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            iconScale = 1.0
            iconRotation = 0
        }
        withAnimation(.easeOut(duration: 0.5).delay(0.15)) {
            appear = true
        }
    }
}

// MARK: - Glass Button Style

struct GlassButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                Color.accentColor.opacity(configuration.isPressed ? 0.8 : 1.0),
                                Color.accentColor.opacity(configuration.isPressed ? 0.6 : 0.8)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .shadow(
                        color: Color.accentColor.opacity(configuration.isPressed ? 0.2 : 0.35),
                        radius: configuration.isPressed ? 4 : 10,
                        x: 0,
                        y: configuration.isPressed ? 2 : 4
                    )
            )
            .foregroundColor(.white)
            .scaleEffect(configuration.isPressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.2, dampingFraction: 0.7), value: configuration.isPressed)
    }
}

// MARK: - Preview

struct PermissionView_Previews: PreviewProvider {
    static var previews: some View {
        PermissionView(onSkip: nil)
    }
}
