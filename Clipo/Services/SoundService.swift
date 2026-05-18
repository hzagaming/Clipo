import AppKit

/// Provides audible feedback for user actions using macOS built-in system sounds.
/// Supports per-sound toggles and global volume control for fine-grained customization.
class SoundService {
    static let shared = SoundService()
    private init() {}
    
    private var settings: AppSettings { ClipStore.shared.settings }
    
    private func play(named name: String, enabled: Bool) {
        guard settings.soundEnabled, enabled else { return }
        guard settings.soundVolume > 0 else { return }
        guard let sound = NSSound(named: name) else { return }
        sound.volume = Float(settings.soundVolume)
        sound.play()
    }
    
    func playPreview() {
        guard settings.soundEnabled else { return }
        guard settings.soundVolume > 0 else { return }
        guard let sound = NSSound(named: "Tink") else { return }
        sound.volume = Float(settings.soundVolume)
        sound.play()
    }
    
    func playSave()   { play(named: "Pop",       enabled: settings.soundSaveEnabled) }
    func playCopy()   { play(named: "Tink",      enabled: settings.soundCopyEnabled) }
    func playPaste()  { play(named: "Purr",      enabled: settings.soundPasteEnabled) }
    func playOpen()   { play(named: "Glass",     enabled: settings.soundOpenEnabled) }
    func playClose()  { play(named: "Funk",      enabled: settings.soundCloseEnabled) }
    func playError()  { play(named: "Sosumi",    enabled: settings.soundErrorEnabled) }
    func playReset()  { play(named: "Submarine", enabled: settings.soundResetEnabled) }
}
