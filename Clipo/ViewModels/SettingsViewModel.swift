import Foundation
import Combine

class SettingsViewModel: ObservableObject {
    @Published var store = ClipStore.shared
}
