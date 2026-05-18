import Foundation

class FileBackupService {
    static let shared = FileBackupService()

    private let fileManager = FileManager.default

    private var backupsURL: URL {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? fileManager.temporaryDirectory
        let folder = appSupport
            .appendingPathComponent("Clipo", isDirectory: true)
            .appendingPathComponent("FileBackups", isDirectory: true)
        if !fileManager.fileExists(atPath: folder.path) {
            try? fileManager.createDirectory(at: folder, withIntermediateDirectories: true, attributes: nil)
        }
        return folder
    }

    func backupFiles(in payload: PasteboardPayload) -> PasteboardPayload {
        let fileURLs = payload.fileURLs
        guard !fileURLs.isEmpty else { return payload }

        let backupSetURL = backupsURL.appendingPathComponent(UUID().uuidString, isDirectory: true)
        var replacements: [URL: URL] = [:]

        for (index, sourceURL) in fileURLs.enumerated() {
            if isInsideBackups(sourceURL) {
                replacements[sourceURL] = sourceURL
                continue
            }

            guard fileManager.fileExists(atPath: sourceURL.path) else { continue }
            try? fileManager.createDirectory(at: backupSetURL, withIntermediateDirectories: true, attributes: nil)

            let name = sourceURL.lastPathComponent.isEmpty ? "Item-\(index + 1)" : sourceURL.lastPathComponent
            let destinationURL = uniqueDestinationURL(for: name, in: backupSetURL)

            do {
                try fileManager.copyItem(at: sourceURL, to: destinationURL)
                replacements[sourceURL] = destinationURL
            } catch {
                print("[Clipo] Failed to back up copied file \(sourceURL.path): \(error)")
            }
        }

        return payload.replacingFileURLs(replacements)
    }

    func removeAllBackups() {
        try? fileManager.removeItem(at: backupsURL)
    }

    private func uniqueDestinationURL(for name: String, in folder: URL) -> URL {
        let destination = folder.appendingPathComponent(name)
        guard fileManager.fileExists(atPath: destination.path) else { return destination }

        let base = destination.deletingPathExtension().lastPathComponent
        let ext = destination.pathExtension

        for suffix in 2...999 {
            let candidateName = ext.isEmpty ? "\(base)-\(suffix)" : "\(base)-\(suffix).\(ext)"
            let candidate = folder.appendingPathComponent(candidateName)
            if !fileManager.fileExists(atPath: candidate.path) {
                return candidate
            }
        }

        return folder.appendingPathComponent(UUID().uuidString)
    }

    private func isInsideBackups(_ url: URL) -> Bool {
        let standardizedPath = url.standardizedFileURL.path
        let backupPath = backupsURL.standardizedFileURL.path
        return standardizedPath == backupPath || standardizedPath.hasPrefix(backupPath + "/")
    }
}
