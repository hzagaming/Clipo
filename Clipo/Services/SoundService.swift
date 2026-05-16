import AppKit

/// Provides audible feedback for user actions using macOS built-in system sounds.
/// Sounds are subtle and short to avoid being intrusive in a productivity tool.
class SoundService {
    static let shared = SoundService()
    
    private init() {}
    
    /// Master switch — respects user preference in AppSettings.
    private var isEnabled: Bool {
        ClipStore.shared.settings.soundEnabled
    }
    
    /// Played when text is saved to a slot (Cmd+Opt+1..9).
    func playSave() {
        guard isEnabled else { return }
        NSSound(named: "Pop")?.play()
    }
    
    /// Played when text is copied to clipboard (Return in panel, or menu Copy).
    func playCopy() {
        guard isEnabled else { return }
        NSSound(named: "Tink")?.play()
    }
    
    /// Played when text is pasted into the active app (Ctrl+Opt+1..9, or Cmd+Return).
    func playPaste() {
        guard isEnabled else { return }
        NSSound(named: "Purr")?.play()
    }
    
    /// Played when the Clipo Panel opens (Opt+Space).
    func playOpen() {
        guard isEnabled else { return }
        NSSound(named: "Glass")?.play()
    }
    
    /// Played when the Clipo Panel closes (Esc or click-outside).
    func playClose() {
        guard isEnabled else { return }
        NSSound(named: "Funk")?.play()
    }
    
    /// Played on errors or permission denials.
    func playError() {
        guard isEnabled else { return }
        NSSound(named: "Sosumi")?.play()
    }
    
    /// Played when history is cleared or slots are reset.
    func playReset() {
        guard isEnabled else { return }
        NSSound(named: "Submarine")?.play()
    }
}
