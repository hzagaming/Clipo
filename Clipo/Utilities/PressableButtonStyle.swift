import SwiftUI

/// A button style that provides subtle press feedback via scale + opacity.
struct PressableButtonStyle: ButtonStyle {
    var scale: CGFloat = 0.92
    var opacity: Double = 0.7
    var duration: Double = 0.1

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scale : 1.0)
            .opacity(configuration.isPressed ? opacity : 1.0)
            .animation(.easeOut(duration: duration), value: configuration.isPressed)
    }
}
