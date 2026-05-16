import Foundation

class SettingsViewModel: ObservableObject {
    @Published var store = ClipStore.shared
}
