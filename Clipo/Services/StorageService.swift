import Foundation
import AppKit

class StorageService {
    static let shared = StorageService()
    
    private let fileName = "clips.json"
    private let backupName = "clips_corrupted_backup.json"
    
    private var storageURL: URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.temporaryDirectory
        let folder = appSupport.appendingPathComponent("Clipo", isDirectory: true)
        if !FileManager.default.fileExists(atPath: folder.path) {
            try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        return folder.appendingPathComponent(fileName)
    }
    
    func getStorageURL() -> URL {
        return storageURL
    }
    
    func openStorageFolder() {
        NSWorkspace.shared.activateFileViewerSelecting([storageURL.deletingLastPathComponent()])
    }
    
    func loadStore() -> (slots: [Int: ClipItem], history: [ClipItem], settings: AppSettings) {
        let url = storageURL
        guard FileManager.default.fileExists(atPath: url.path) else {
            return ([:], [], AppSettings())
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let container = try decoder.decode(StorageContainer.self, from: data)
            return (container.slots, container.history, container.settings)
        } catch {
            print("[Clipo] Failed to load store: \(error). Creating backup and resetting.")
            backupCorruptedStoreIfNeeded()
            return ([:], [], AppSettings())
        }
    }
    
    func saveStore(slots: [Int: ClipItem], history: [ClipItem], settings: AppSettings) {
        let container = StorageContainer(slots: slots, history: history, settings: settings)
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(container)
            try data.write(to: storageURL, options: .atomic)
        } catch {
            print("[Clipo] Failed to save store: \(error)")
        }
    }
    
    func backupCorruptedStoreIfNeeded() {
        let url = storageURL
        let backupURL = url.deletingLastPathComponent().appendingPathComponent(backupName)
        if FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.removeItem(at: backupURL)
            try? FileManager.default.copyItem(at: url, to: backupURL)
        }
    }
    
    private struct StorageContainer: Codable {
        var slots: [Int: ClipItem]
        var history: [ClipItem]
        var settings: AppSettings
    }
}
