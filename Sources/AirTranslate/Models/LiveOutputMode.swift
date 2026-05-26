import Foundation

enum LiveOutputMode: String, CaseIterable, Identifiable {
    case translation
    case transcription

    var id: String { rawValue }

    var title: String {
        switch self {
        case .translation:
            AppText.translation
        case .transcription:
            AppText.transcribeOnly
        }
    }

    var systemImage: String {
        switch self {
        case .translation:
            "character.bubble"
        case .transcription:
            "waveform"
        }
    }
}
