import AppKit

struct PasteboardPayload: Codable, Equatable {
    var items: [PasteboardPayloadItem]

    private static let maxRepresentationBytes = 20 * 1024 * 1024
    private static let maxTotalBytes = 80 * 1024 * 1024

    static func capture(from pasteboard: NSPasteboard = .general) -> PasteboardPayload? {
        guard let pasteboardItems = pasteboard.pasteboardItems else { return nil }

        var capturedItems: [PasteboardPayloadItem] = []
        var totalBytes = 0

        for item in pasteboardItems {
            var representations: [PasteboardRepresentation] = []

            for type in item.types {
                guard let data = item.data(forType: type), !data.isEmpty else { continue }
                guard data.count <= maxRepresentationBytes else { continue }
                guard totalBytes + data.count <= maxTotalBytes else { continue }

                representations.append(
                    PasteboardRepresentation(type: type.rawValue, data: data)
                )
                totalBytes += data.count
            }

            if !representations.isEmpty {
                capturedItems.append(PasteboardPayloadItem(representations: representations))
            }
        }

        return capturedItems.isEmpty ? nil : PasteboardPayload(items: capturedItems)
    }

    @discardableResult
    func write(to pasteboard: NSPasteboard = .general) -> Bool {
        let pasteboardItems = items.compactMap { payloadItem -> NSPasteboardItem? in
            let pasteboardItem = NSPasteboardItem()
            var wroteRepresentation = false

            for representation in payloadItem.representations {
                let type = NSPasteboard.PasteboardType(representation.type)
                pasteboardItem.setData(representation.data, forType: type)
                wroteRepresentation = true
            }

            return wroteRepresentation ? pasteboardItem : nil
        }

        guard !pasteboardItems.isEmpty else { return false }
        pasteboard.clearContents()
        return pasteboard.writeObjects(pasteboardItems)
    }

    var plainText: String? {
        for preferredType in textTypePriority {
            if let text = firstString(forType: preferredType), !text.isEmpty {
                return text
            }
        }
        return nil
    }

    var fileURLs: [URL] {
        items.flatMap { item in
            item.representations.compactMap { representation in
                guard representation.isFileURLType,
                      let value = representation.stringValue,
                      let url = URL(string: value),
                      url.isFileURL else {
                    return nil
                }
                return url
            }
        }
    }

    func replacingFileURLs(_ replacements: [URL: URL]) -> PasteboardPayload {
        guard !replacements.isEmpty else { return self }

        let updatedItems = items.map { item in
            let updatedRepresentations = item.representations.map { representation in
                representation.replacingFileURLs(replacements)
            }
            return PasteboardPayloadItem(representations: updatedRepresentations)
        }

        return PasteboardPayload(items: updatedItems)
    }

    var containsImage: Bool {
        containsType(prefixes: ["public.png", "public.jpeg", "public.tiff", "public.heic", "public.image"])
    }

    var containsRichText: Bool {
        containsType(prefixes: [NSPasteboard.PasteboardType.rtf.rawValue, "public.html"])
    }

    var preview: String {
        if let text = plainText, !text.isEmpty {
            return StringPreviewUtility.makePreview(from: text)
        }

        let urls = fileURLs
        if !urls.isEmpty {
            let names = urls.prefix(3).map { $0.lastPathComponent.isEmpty ? $0.path : $0.lastPathComponent }
            let suffix = urls.count > names.count ? " +" + String(urls.count - names.count) : ""
            return urls.count == 1 ? "File: \(names[0])" : "Files: \(names.joined(separator: ", "))\(suffix)"
        }

        if containsImage {
            return "Image"
        }

        if containsRichText {
            return "Rich Text"
        }

        let typeCount = Set(items.flatMap { $0.representations.map(\.type) }).count
        return typeCount > 0 ? "Clipboard Item (\(typeCount) types)" : "Clipboard Item"
    }

    var searchableText: String {
        var parts: [String] = []
        if let text = plainText {
            parts.append(text)
        }
        parts.append(contentsOf: fileURLs.map { $0.lastPathComponent })
        parts.append(contentsOf: items.flatMap { $0.representations.map(\.type) })
        return parts.joined(separator: " ")
    }

    var inferredType: ClipType {
        if !fileURLs.isEmpty {
            return .file
        }
        if let text = plainText, URLDetector.isValidURL(text) {
            return .url
        }
        if containsImage {
            return .image
        }
        if containsRichText {
            return .richText
        }
        if let text = plainText, CodeLikeDetector.isCodeLike(text) {
            return .codeLikeText
        }
        if plainText != nil {
            return .plainText
        }
        return .data
    }

    private var textTypePriority: [String] {
        [
            NSPasteboard.PasteboardType.string.rawValue,
            "public.utf8-plain-text",
            "public.utf16-plain-text",
            "public.utf16-external-plain-text",
            NSPasteboard.PasteboardType.URL.rawValue
        ]
    }

    private func firstString(forType type: String) -> String? {
        for item in items {
            if let representation = item.representations.first(where: { $0.type == type }),
               let value = representation.stringValue {
                return value
            }
        }
        return nil
    }

    private func containsType(prefixes: [String]) -> Bool {
        items.contains { item in
            item.representations.contains { representation in
                prefixes.contains { representation.type.hasPrefix($0) }
            }
        }
    }
}

struct PasteboardPayloadItem: Codable, Equatable {
    var representations: [PasteboardRepresentation]
}

struct PasteboardRepresentation: Codable, Equatable {
    var type: String
    var data: Data

    var stringValue: String? {
        if let value = String(data: data, encoding: .utf8) {
            return value
        }
        if let value = String(data: data, encoding: .utf16) {
            return value
        }
        if let value = String(data: data, encoding: .utf16LittleEndian) {
            return value
        }
        if let value = String(data: data, encoding: .utf16BigEndian) {
            return value
        }
        return nil
    }

    var isFileURLType: Bool {
        type == NSPasteboard.PasteboardType.fileURL.rawValue ||
            type == NSPasteboard.PasteboardType.URL.rawValue
    }

    func replacingFileURLs(_ replacements: [URL: URL]) -> PasteboardRepresentation {
        if isFileURLType,
           let value = stringValue,
           let url = URL(string: value),
           let replacement = replacements[url],
           let replacementData = replacement.absoluteString.data(using: .utf8) {
            return PasteboardRepresentation(type: type, data: replacementData)
        }

        if type == "NSFilenamesPboardType",
           let propertyList = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
           let paths = propertyList as? [String] {
            let updatedPaths = paths.map { path in
                let url = URL(fileURLWithPath: path)
                return replacements[url]?.path ?? path
            }

            if let updatedData = try? PropertyListSerialization.data(
                fromPropertyList: updatedPaths,
                format: .binary,
                options: 0
            ) {
                return PasteboardRepresentation(type: type, data: updatedData)
            }
        }

        return self
    }
}
