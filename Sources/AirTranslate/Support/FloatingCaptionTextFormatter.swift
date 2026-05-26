import Foundation

private enum FloatingCaptionTextLayout {
    static let defaultLineWidthUnits = 32.0
    static let scanLineMultiplier = 4

    static func displayWidth(of character: Character) -> Double {
        if character.isWhitespace {
            return 0.45
        }

        guard let scalar = character.unicodeScalars.first else {
            return 1
        }

        return scalar.isASCII ? 0.62 : 1
    }
}

extension String {
    func floatingCaptionTail(
        maxLines: Int,
        lineWidthUnits: Double = FloatingCaptionTextLayout.defaultLineWidthUnits
    ) -> String {
        let maxLines = max(1, maxLines)
        let lineWidthUnits = max(1, lineWidthUnits)
        let trimmedText = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return "" }
        let scanCharacters = maxLines * 72 * FloatingCaptionTextLayout.scanLineMultiplier
        let captionText = trimmedText.floatingCaptionSentenceBreaks()
        let scanText = String(captionText.boundedSuffix(maxCharacters: scanCharacters))

        let logicalLines = scanText.floatingCaptionWrappedLines(
            maxLineWidth: lineWidthUnits
        )

        return logicalLines
            .suffix(maxLines)
            .joined(separator: "\n")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func boundedSuffix(maxCharacters: Int) -> Substring {
        guard maxCharacters > 0,
              let start = index(endIndex, offsetBy: -maxCharacters, limitedBy: startIndex)
        else {
            return self[startIndex..<endIndex]
        }

        return self[start..<endIndex]
    }

    private func floatingCaptionSentenceBreaks() -> String {
        replacingOccurrences(
            of: #"(?<!\d)([.!?。！？])\s+(?=\S)"#,
            with: "$1\n",
            options: .regularExpression
        )
    }

    private func floatingCaptionWrappedLines(maxLineWidth: Double) -> [String] {
        components(separatedBy: .newlines)
            .flatMap { paragraph in
                paragraph.floatingCaptionWrappedParagraph(maxLineWidth: maxLineWidth)
            }
            .filter { !$0.isEmpty }
    }

    private func floatingCaptionWrappedParagraph(maxLineWidth: Double) -> [String] {
        let paragraph = trimmingCharacters(in: .whitespacesAndNewlines)
        guard !paragraph.isEmpty else { return [] }

        var lines: [String] = []
        var currentLine = ""
        var currentWidth = 0.0

        for word in paragraph.split(whereSeparator: \.isWhitespace) {
            let word = String(word)
            let wordWidth = word.floatingCaptionDisplayWidth

            if wordWidth > maxLineWidth {
                if !currentLine.isEmpty {
                    lines.append(currentLine)
                    currentLine = ""
                    currentWidth = 0
                }
                lines.append(contentsOf: word.floatingCaptionSplitLongToken(maxLineWidth: maxLineWidth))
                continue
            }

            let separatorWidth = currentLine.isEmpty ? 0 : FloatingCaptionTextLayout.displayWidth(of: " ")
            let nextWidth = currentWidth + separatorWidth + wordWidth
            if !currentLine.isEmpty, nextWidth > maxLineWidth {
                lines.append(currentLine)
                currentLine = word
                currentWidth = wordWidth
            } else {
                if !currentLine.isEmpty {
                    currentLine += " "
                    currentWidth += separatorWidth
                }
                currentLine += word
                currentWidth += wordWidth
            }
        }

        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        return lines
    }

    private var floatingCaptionDisplayWidth: Double {
        reduce(0) { width, character in
            width + FloatingCaptionTextLayout.displayWidth(of: character)
        }
    }

    private func floatingCaptionSplitLongToken(maxLineWidth: Double) -> [String] {
        var lines: [String] = []
        var currentLine = ""
        var currentWidth = 0.0

        for character in self {
            let characterWidth = FloatingCaptionTextLayout.displayWidth(of: character)
            if !currentLine.isEmpty, currentWidth + characterWidth > maxLineWidth {
                lines.append(currentLine)
                currentLine = ""
                currentWidth = 0
            }

            currentLine.append(character)
            currentWidth += characterWidth
        }

        if !currentLine.isEmpty {
            lines.append(currentLine)
        }

        return lines
    }
}
