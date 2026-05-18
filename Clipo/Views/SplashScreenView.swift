import SwiftUI

struct SplashScreenView: View {
    @State private var phase = 0
    
    var body: some View {
        ZStack {
            // Animated gradient background
            LinearGradient(
                colors: [
                    Color(red: 0.08, green: 0.08, blue: 0.12),
                    Color(red: 0.12, green: 0.10, blue: 0.18),
                    Color(red: 0.06, green: 0.06, blue: 0.10)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Ambient glow behind logo
            Circle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.accentColor.opacity(0.25),
                            Color.accentColor.opacity(0.05),
                            Color.clear
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: 120
                    )
                )
                .frame(width: 240, height: 240)
                .opacity(phase >= 1 ? 1.0 : 0.0)
                .scaleEffect(phase >= 1 ? 1.0 : 0.6)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: phase)
            
            VStack(spacing: 16) {
                Spacer()
                
                // Logo mark
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color.accentColor.opacity(0.9),
                                    Color.accentColor.opacity(0.6)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color.accentColor.opacity(0.4), radius: 20, x: 0, y: 8)
                    
                    Image(systemName: "clipboard.fill")
                        .font(.system(size: 36, weight: .semibold))
                        .foregroundColor(.white)
                }
                .scaleEffect(phase >= 1 ? 1.0 : 0.6)
                .opacity(phase >= 1 ? 1.0 : 0.0)
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: phase)
                
                // Main title
                Text(L10n.string(.panelTitle))
                    .font(.system(size: 42, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [.white, .white.opacity(0.85)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .scaleEffect(phase >= 1 ? 1.0 : 0.6)
                    .opacity(phase >= 1 ? 1.0 : 0.0)
                    .animation(.spring(response: 0.6, dampingFraction: 0.7).delay(0.1), value: phase)
                
                // Subtitle
                Text("Hanazar Software")
                    .font(.system(size: 14, weight: .medium, design: .rounded))
                    .foregroundColor(.white.opacity(0.5))
                    .tracking(3)
                    .offset(y: phase >= 1 ? 0 : 20)
                    .opacity(phase >= 1 ? 1.0 : 0.0)
                    .animation(.easeOut(duration: 0.5).delay(0.3), value: phase)
                
                Spacer()
                
                // Progress bar
                VStack(spacing: 8) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.white.opacity(0.08))
                        .frame(width: 140, height: 3)
                        .overlay(
                            GeometryReader { geo in
                                RoundedRectangle(cornerRadius: 2)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color.accentColor, Color.accentColor.opacity(0.6)],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                    )
                                    .frame(width: geo.size.width * (phase >= 1 ? 1.0 : 0.0), height: 3)
                                    .animation(.easeInOut(duration: 1.5).delay(0.5), value: phase)
                            }
                        )
                    
                    Text(L10n.string(.loadingText))
                        .font(.caption2)
                        .foregroundColor(.white.opacity(0.25))
                        .opacity(phase >= 1 ? 1.0 : 0.0)
                        .animation(.easeOut(duration: 0.3).delay(0.3), value: phase)
                }
                .padding(.bottom, 40)
            }
        }
        .onAppear {
            phase = 1
        }
    }
}

// MARK: - Preview

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .frame(width: 400, height: 500)
    }
}
