import Foundation

enum AudioInputSource: String, CaseIterable, Identifiable {
    case systemAudio
    case microphone

    var id: String { rawValue }

    var title: String {
        switch self {
        case .systemAudio:
            AppText.systemAudioInput
        case .microphone:
            AppText.microphoneInput
        }
    }
}
