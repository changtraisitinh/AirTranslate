import Foundation

struct MicrophoneInputDevice: Identifiable, Equatable {
    static let systemDefaultID = "system-default"

    let id: String
    let name: String
    let uniqueID: String?

    static var systemDefault: MicrophoneInputDevice {
        MicrophoneInputDevice(
            id: systemDefaultID,
            name: AppText.systemDefaultMicrophone,
            uniqueID: nil
        )
    }
}
