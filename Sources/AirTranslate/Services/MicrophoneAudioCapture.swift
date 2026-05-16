import AVFoundation

protocol MicrophoneAudioCaptureDelegate: AnyObject {
    func microphoneAudioCapture(_ capture: MicrophoneAudioCapture, didOutput sampleBuffer: CMSampleBuffer)
    func microphoneAudioCapture(_ capture: MicrophoneAudioCapture, didReceiveAudioSampleCount count: Int, level: Float?)
}

final class MicrophoneAudioCapture: NSObject, @unchecked Sendable {
    private static let audioLevelReportInterval = 8

    weak var delegate: MicrophoneAudioCaptureDelegate?

    private let sampleQueue = DispatchQueue(label: "AirTranslate.MicrophoneAudioCapture.sampleQueue")
    private var session: AVCaptureSession?
    private var output: AVCaptureAudioDataOutput?
    private var audioSampleCount = 0

    @MainActor
    func start(sampleRate: Int = 16_000, deviceUniqueID: String? = nil) async throws {
        guard await requestMicrophoneAccess() else {
            throw CaptureError.microphoneNotGranted
        }

        stop()

        guard let device = MicrophoneDeviceCatalog.captureDevice(for: deviceUniqueID) else {
            throw CaptureError.microphoneUnavailable
        }

        let session = AVCaptureSession()
        let input = try AVCaptureDeviceInput(device: device)
        let output = AVCaptureAudioDataOutput()
        output.audioSettings = [
            AVFormatIDKey: kAudioFormatLinearPCM,
            AVSampleRateKey: sampleRate,
            AVNumberOfChannelsKey: 1,
            AVLinearPCMBitDepthKey: 16,
            AVLinearPCMIsFloatKey: false,
            AVLinearPCMIsBigEndianKey: false
        ]
        output.setSampleBufferDelegate(self, queue: sampleQueue)

        session.beginConfiguration()
        guard session.canAddInput(input), session.canAddOutput(output) else {
            session.commitConfiguration()
            throw CaptureError.microphoneUnavailable
        }
        session.addInput(input)
        session.addOutput(output)
        session.commitConfiguration()

        audioSampleCount = 0
        self.output = output
        self.session = session
        session.startRunning()
    }

    func stop() {
        output?.setSampleBufferDelegate(nil, queue: nil)
        if let session, session.isRunning {
            session.stopRunning()
        }
        output = nil
        session = nil
    }

    @MainActor
    private func requestMicrophoneAccess() async -> Bool {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .authorized:
            return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied, .restricted:
            return false
        @unknown default:
            return false
        }
    }
}

extension MicrophoneAudioCapture: AVCaptureAudioDataOutputSampleBufferDelegate {
    func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        guard sampleBuffer.isValid else { return }

        audioSampleCount += 1
        delegate?.microphoneAudioCapture(self, didOutput: sampleBuffer)
        if audioSampleCount == 1 || audioSampleCount % Self.audioLevelReportInterval == 0 {
            delegate?.microphoneAudioCapture(
                self,
                didReceiveAudioSampleCount: audioSampleCount,
                level: audioLevel(from: sampleBuffer)
            )
        }
    }

    private func audioLevel(from sampleBuffer: CMSampleBuffer) -> Float? {
        guard let formatDescription = CMSampleBufferGetFormatDescription(sampleBuffer),
              let streamDescription = CMAudioFormatDescriptionGetStreamBasicDescription(formatDescription)
        else {
            return nil
        }

        var listSize = 0
        CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: &listSize,
            bufferListOut: nil,
            bufferListSize: 0,
            blockBufferAllocator: nil,
            blockBufferMemoryAllocator: nil,
            flags: 0,
            blockBufferOut: nil
        )

        guard listSize > 0 else { return nil }

        let rawList = UnsafeMutableRawPointer.allocate(
            byteCount: listSize,
            alignment: MemoryLayout<AudioBufferList>.alignment
        )
        defer { rawList.deallocate() }

        let audioBufferList = rawList.bindMemory(to: AudioBufferList.self, capacity: 1)
        var blockBuffer: CMBlockBuffer?
        let status = CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
            sampleBuffer,
            bufferListSizeNeededOut: nil,
            bufferListOut: audioBufferList,
            bufferListSize: listSize,
            blockBufferAllocator: kCFAllocatorDefault,
            blockBufferMemoryAllocator: kCFAllocatorDefault,
            flags: kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
            blockBufferOut: &blockBuffer
        )

        guard status == noErr else { return nil }

        let buffers = UnsafeMutableAudioBufferListPointer(audioBufferList)
        let isFloat = streamDescription.pointee.mFormatFlags & kAudioFormatFlagIsFloat != 0
        var squareSum: Double = 0
        var sampleCount = 0

        for buffer in buffers {
            guard let data = buffer.mData else { continue }

            if isFloat {
                let samples = data.bindMemory(to: Float.self, capacity: Int(buffer.mDataByteSize) / MemoryLayout<Float>.size)
                let count = Int(buffer.mDataByteSize) / MemoryLayout<Float>.size
                for index in 0..<count {
                    let sample = Double(samples[index])
                    squareSum += sample * sample
                }
                sampleCount += count
            } else {
                let samples = data.bindMemory(to: Int16.self, capacity: Int(buffer.mDataByteSize) / MemoryLayout<Int16>.size)
                let count = Int(buffer.mDataByteSize) / MemoryLayout<Int16>.size
                for index in 0..<count {
                    let sample = Double(samples[index]) / Double(Int16.max)
                    squareSum += sample * sample
                }
                sampleCount += count
            }
        }

        guard sampleCount > 0 else { return nil }
        let rms = sqrt(squareSum / Double(sampleCount))
        let decibels = 20 * log10(max(rms, 0.000_001))
        return Float(decibels)
    }
}
