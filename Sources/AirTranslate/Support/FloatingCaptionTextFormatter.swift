import Foundation

extension String {
    func floatingCaptionTail(maxLines: Int) -> String {
        let maxLines = max(1, maxLines)
        let trimmedText = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return "" }

        let logicalLines = trimmedText
            .components(separatedBy: .newlines)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let tailText: String
        if logicalLines.count > maxLines {
            tailText = logicalLines.suffix(maxLines).joined(separator: "\n")
        } else {
            tailText = trimmedText
        }

        let maxCharacters = maxLines * 72
        guard tailText.count > maxCharacters else { return tailText }

        return String(tailText.suffix(maxCharacters))
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
