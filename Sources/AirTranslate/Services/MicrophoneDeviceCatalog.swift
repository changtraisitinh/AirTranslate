import AVFoundation
import Foundation

enum MicrophoneDeviceCatalog {
    static func availableInputDevices() -> [MicrophoneInputDevice] {
        let inputDevices = audioDevices().map { device in
            MicrophoneInputDevice(
                id: device.uniqueID,
                name: device.localizedName,
                uniqueID: device.uniqueID
            )
        }

        return [MicrophoneInputDevice.systemDefault] + inputDevices.sorted { $0.name < $1.name }
    }

    static func captureDevice(for uniqueID: String?) -> AVCaptureDevice? {
        guard let uniqueID else {
            return AVCaptureDevice.default(for: .audio)
        }

        return audioDevices().first { $0.uniqueID == uniqueID }
    }

    private static func audioDevices() -> [AVCaptureDevice] {
        AVCaptureDevice.DiscoverySession(
            deviceTypes: [.microphone, .external],
            mediaType: .audio,
            position: .unspecified
        ).devices
    }
}
