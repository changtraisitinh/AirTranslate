import Foundation
import Testing
@testable import AirTranslate

@Suite
struct GeminiLiveTranslationServiceTests {
    @Test
    func serverEventPublishesTranscriptsAndTranslatedAudio() {
        let service = GeminiLiveTranslationService()
        let delegate = GeminiLiveTranslationProbe()
        service.delegate = delegate

        service.handleEventText("""
        {
          "serverContent": {
            "inputTranscription": {
              "text": "hello",
              "languageCode": "en"
            },
            "outputTranscription": {
              "text": "안녕하세요",
              "languageCode": "ko"
            },
            "modelTurn": {
              "parts": [
                {
                  "inlineData": {
                    "data": "AQIDBA==",
                    "mimeType": "audio/pcm;rate=24000"
                  }
                }
              ]
            }
          }
        }
        """)

        #expect(delegate.inputTranscript == "hello")
        #expect(delegate.outputTranscript == "안녕하세요")
        #expect(delegate.audio == "AQIDBA==")
        #expect(delegate.sampleRate == 24_000)
    }

    @Test
    func outputAudioSampleRateFallsBackToGeminiLiveDefault() {
        #expect(GeminiLiveTranslationService.outputAudioSampleRate(from: nil) == 24_000)
        #expect(GeminiLiveTranslationService.outputAudioSampleRate(from: "audio/pcm") == 24_000)
        #expect(GeminiLiveTranslationService.outputAudioSampleRate(from: "audio/pcm;rate=22050") == 22_050)
    }

    @Test
    func setupCompleteMarksRealtimeInputReady() {
        let service = GeminiLiveTranslationService()

        #expect(!service.isReadyForRealtimeInput)

        service.handleEventText(#"{"setupComplete":{}}"#)

        #expect(service.isReadyForRealtimeInput)
    }
}

private final class GeminiLiveTranslationProbe: GeminiLiveTranslationServiceDelegate {
    var inputTranscript = ""
    var outputTranscript = ""
    var audio = ""
    var sampleRate = 0.0
    var didInterrupt = false
    var error: Error?

    func geminiLiveTranslationService(
        _ service: GeminiLiveTranslationService,
        didReceiveInputTranscript text: String,
        languageCode _: String?
    ) {
        inputTranscript = text
    }

    func geminiLiveTranslationService(
        _ service: GeminiLiveTranslationService,
        didReceiveOutputTranscript text: String,
        languageCode _: String?
    ) {
        outputTranscript = text
    }

    func geminiLiveTranslationService(
        _ service: GeminiLiveTranslationService,
        didOutputAudioPCM16Base64 audio: String,
        sampleRate: Double
    ) {
        self.audio = audio
        self.sampleRate = sampleRate
    }

    func geminiLiveTranslationServiceDidInterruptOutputAudio(_ service: GeminiLiveTranslationService) {
        didInterrupt = true
    }

    func geminiLiveTranslationService(_ service: GeminiLiveTranslationService, didFail error: Error) {
        self.error = error
    }
}
