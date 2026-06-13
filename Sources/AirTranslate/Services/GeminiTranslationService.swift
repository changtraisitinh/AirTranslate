import Foundation

actor GeminiTranslationService {
    private let endpointBase = URL(string: "https://generativelanguage.googleapis.com/v1beta/models")!

    func translate(
        _ text: String,
        source: LanguageOption,
        target: LanguageOption,
        model selectedModel: GeminiTranslationModel
    ) async throws -> String {
        guard !text.isEmpty else { return text }
        guard selectedModel.isEnabled else { return text }
        guard let apiKey = try GeminiAPIKeyStore.readAPIKey(), !apiKey.isEmpty else {
            throw GeminiTranslationError.missingAPIKey
        }

        let endpoint = endpointBase
            .appendingPathComponent("\(selectedModel.apiModelID):generateContent")

        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(apiKey, forHTTPHeaderField: "x-goog-api-key")
        request.httpBody = try JSONEncoder().encode(
            GeminiGenerateContentRequest(
                systemInstruction: GeminiContent(
                    parts: [
                        GeminiPart(text: AppText.geminiTranslationInstructions(
                            source: source.localizedTitle,
                            target: target.localizedTitle
                        ))
                    ]
                ),
                contents: [
                    GeminiContent(parts: [GeminiPart(text: text)])
                ],
                generationConfig: GeminiGenerationConfig(maxOutputTokens: 4096)
            )
        )

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GeminiTranslationError.invalidResponse
        }
        guard (200..<300).contains(httpResponse.statusCode) else {
            let errorResponse = try? JSONDecoder().decode(GeminiErrorResponse.self, from: data)
            throw GeminiTranslationError.requestFailed(
                statusCode: httpResponse.statusCode,
                message: errorResponse?.error.message
            )
        }

        let responseBody = try JSONDecoder().decode(GeminiGenerateContentResponse.self, from: data)
        guard let outputText = responseBody.firstOutputText else {
            throw GeminiTranslationError.emptyOutput
        }
        return outputText.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

private struct GeminiGenerateContentRequest: Encodable {
    let systemInstruction: GeminiContent
    let contents: [GeminiContent]
    let generationConfig: GeminiGenerationConfig
}

private struct GeminiGenerationConfig: Encodable {
    let maxOutputTokens: Int
}

private struct GeminiContent: Codable {
    let parts: [GeminiPart]
}

private struct GeminiPart: Codable {
    let text: String?
}

private struct GeminiGenerateContentResponse: Decodable {
    let candidates: [GeminiCandidate]?

    var firstOutputText: String? {
        candidates?
            .compactMap(\.content)
            .flatMap(\.parts)
            .compactMap(\.text)
            .first { !$0.isEmpty }
    }
}

private struct GeminiCandidate: Decodable {
    let content: GeminiContent?
}

private struct GeminiErrorResponse: Decodable {
    let error: GeminiErrorBody
}

private struct GeminiErrorBody: Decodable {
    let message: String
}

enum GeminiTranslationError: LocalizedError {
    case missingAPIKey
    case invalidResponse
    case emptyOutput
    case requestFailed(statusCode: Int, message: String?)

    var errorDescription: String? {
        switch self {
        case .missingAPIKey:
            AppText.geminiAPIKeyMissing
        case .invalidResponse:
            AppText.geminiInvalidResponse
        case .emptyOutput:
            AppText.geminiEmptyOutput
        case let .requestFailed(statusCode, message):
            AppText.geminiRequestFailed(statusCode: statusCode, message: message)
        }
    }
}
