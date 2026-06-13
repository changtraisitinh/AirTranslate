import Foundation
import Testing
@testable import AirTranslate

@Suite
struct TranslationSessionStoreLanguageCandidateTests {
    @Test
    func supportedLanguageOrderIsUsedForAutoDetectionCandidateSelection() {
        let candidates = LanguageOption.prioritizedAutoDetectionCandidates(
            sourceLanguage: LanguageOption.korean,
            targetLanguage: LanguageOption.korean
        )

        #expect(candidates.first == LanguageOption.english)
    }

    @Test
    func targetLanguageIsExcludedFromAutoDetectionCandidates() {
        let candidates = LanguageOption.prioritizedAutoDetectionCandidates(
            sourceLanguage: LanguageOption.korean,
            targetLanguage: LanguageOption.english
        )

        #expect(!candidates.contains(LanguageOption.english))
    }

    @Test
    func targetLanguageIsExcludedWhenManualSourceMatchesTarget() {
        let candidates = LanguageOption.prioritizedAutoDetectionCandidates(
            sourceLanguage: LanguageOption.korean,
            targetLanguage: LanguageOption.korean
        )

        #expect(candidates.first == LanguageOption.english)
        #expect(!candidates.contains(LanguageOption.korean))
    }

    @Test
    func autoDetectionCandidatesIncludeAllNonTargetSupportedLanguagesInSourcePriorityOrder() {
        let candidates = LanguageOption.prioritizedAutoDetectionCandidates(
            sourceLanguage: LanguageOption.korean,
            targetLanguage: LanguageOption.english
        )
        let expected = LanguageOption.supported.filter { $0 != LanguageOption.english }

        #expect(candidates == expected)
        #expect(Set(candidates.map({ $0.id })) == Set(expected.map({ $0.id })))
    }

    @Test
    func everySupportedLanguageIsExcludedWhenItIsTheTarget() {
        for target in LanguageOption.supported {
            let candidates = LanguageOption.prioritizedAutoDetectionCandidates(
                sourceLanguage: LanguageOption.english,
                targetLanguage: target
            )

            #expect(!candidates.contains(target))
            #expect(candidates.count == LanguageOption.supported.count - 1)
        }
    }

    @Test
    func autoDetectionRequestsConfirmationForLanguageChangeAfterSilence() {
        let shouldConfirm = AutoDetectionLanguageChangePolicy.shouldRequestConfirmation(
            isAutoDetectionEnabled: true,
            activeLanguage: LanguageOption.english,
            detectedLanguage: LanguageOption.supported[2],
            confidence: 0.9,
            hadLongSilence: true,
            hasVisibleTranscript: true,
            minimumSwitchConfidence: 0.72
        )

        #expect(shouldConfirm)
    }

    @Test
    func autoDetectionDoesNotRequestConfirmationWithoutSilence() {
        let shouldConfirm = AutoDetectionLanguageChangePolicy.shouldRequestConfirmation(
            isAutoDetectionEnabled: true,
            activeLanguage: LanguageOption.english,
            detectedLanguage: LanguageOption.supported[2],
            confidence: 0.9,
            hadLongSilence: false,
            hasVisibleTranscript: true,
            minimumSwitchConfidence: 0.72
        )

        #expect(!shouldConfirm)
    }

    @Test
    func autoDetectionDoesNotRequestConfirmationForLowConfidenceSwitch() {
        let shouldConfirm = AutoDetectionLanguageChangePolicy.shouldRequestConfirmation(
            isAutoDetectionEnabled: true,
            activeLanguage: LanguageOption.english,
            detectedLanguage: LanguageOption.supported[2],
            confidence: 0.5,
            hadLongSilence: true,
            hasVisibleTranscript: true,
            minimumSwitchConfidence: 0.72
        )

        #expect(!shouldConfirm)
    }

    @Test
    func autoDetectionDoesNotRequestConfirmationForInitialLanguageDetection() {
        let shouldConfirm = AutoDetectionLanguageChangePolicy.shouldRequestConfirmation(
            isAutoDetectionEnabled: true,
            activeLanguage: nil,
            detectedLanguage: LanguageOption.supported[2],
            confidence: 0.9,
            hadLongSilence: true,
            hasVisibleTranscript: false,
            minimumSwitchConfidence: 0.72
        )

        #expect(!shouldConfirm)
    }

    @Test
    func longSessionCaptionLineTrimsDisplayOnly() {
        let text = (1...500)
            .map { "Live transcript line \($0) keeps accumulating during a long session." }
            .joined(separator: "\n")
        let line = CaptionLine(
            sourceText: text,
            translatedText: text,
            createdAt: Date(),
            isFinal: false,
            usesLongSessionDisplay: true
        )

        #expect(line.sourceText == text)
        #expect(line.translatedText == text)
        #expect(line.sourceDisplayText != text)
        #expect(line.translatedDisplayText != text)
        #expect(line.sourceDisplayText.hasPrefix("..."))
        #expect(line.translatedDisplayText.hasPrefix("..."))
    }

    @Test
    func veryLargeCaptionLineTrimsDisplayEvenInStandardMode() {
        let text = (1...500)
            .map { "Standard session can still receive a very long realtime transcript line \($0)." }
            .joined(separator: "\n")
        let line = CaptionLine(
            sourceText: text,
            translatedText: text,
            createdAt: Date(),
            isFinal: false
        )

        #expect(line.sourceText == text)
        #expect(line.translatedText == text)
        #expect(line.sourceDisplayText != text)
        #expect(line.translatedDisplayText != text)
        #expect(line.sourceDisplayText.hasPrefix("..."))
        #expect(line.translatedDisplayText.hasPrefix("..."))
    }

    @Test
    @MainActor
    func savedTranscriptContentsLoadOnlyWhenSelected() throws {
        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("AirTranslateTests-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }

        let tailMarker = "TAIL_MARKER_AFTER_PREVIEW"
        let text = "Launch title\n"
            + String(repeating: "Preview filler keeps this saved transcript large.\n", count: 200)
            + tailMarker
        let fileURL = directory.appendingPathComponent("2026-06-13_Launch-title.txt")
        try text.write(to: fileURL, atomically: true, encoding: .utf8)

        let session = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            transcriptsDirectoryURL: directory
        )
        let transcript = try #require(session.savedTranscripts.first)

        #expect(transcript.title == "Launch title")
        #expect(!transcript.sourceText.contains(tailMarker))

        session.selectSavedTranscript(transcript.id)

        #expect(session.savedDraftSourceText.contains(tailMarker))
    }

    @Test
    @MainActor
    func transcribeOnlyModeHidesTranslationPane() {
        let session = TranslationSessionStore()

        session.selectedModel = .appleSpeechOnly
        #expect(!session.shouldShowTranslationPane)

        session.selectedModel = .appleSystem
        #expect(session.shouldShowTranslationPane)
    }

    @Test
    @MainActor
    func sameLanguagePairSwitchesToTranscribeOnlyMode() {
        let session = TranslationSessionStore()

        session.sourceLanguage = LanguageOption.english
        session.targetLanguage = LanguageOption.english

        #expect(session.liveOutputMode == .transcription)
        #expect(!session.shouldShowTranslationPane)
    }

    @Test
    @MainActor
    func sourceLanguageChangeKeepsTranscribeOnlyModeAndSyncsHiddenTarget() {
        let session = TranslationSessionStore()

        session.sourceLanguage = LanguageOption.english
        session.targetLanguage = LanguageOption.english
        session.useTranscribeOnlyMode()
        session.targetLanguage = LanguageOption.supported[2]

        #expect(session.liveOutputMode == .transcription)
        #expect(!session.shouldShowTranslationPane)
        #expect(session.targetLanguage == session.sourceLanguage)
    }

    @Test
    @MainActor
    func explicitTranslationModeRestoresTranslationModeFromTranscribeOnly() {
        let session = TranslationSessionStore()

        session.useTranscribeOnlyMode()
        session.useTranslationMode()

        #expect(session.liveOutputMode == .translation)
        #expect(session.shouldShowTranslationPane)
    }

    @Test
    @MainActor
    func transcribeOnlyModeUsesOriginalOnlyFloatingCaptionsAndRestoresPreviousMode() {
        let session = TranslationSessionStore()

        session.useTranslationMode()
        session.floatingCaptionDisplayMode = .originalAndTranslation
        #expect(session.floatingCaptionDisplayMode == .originalAndTranslation)

        session.useTranscribeOnlyMode()
        #expect(session.floatingCaptionDisplayMode == .original)
        #expect(session.floatingNoticeText == nil)

        session.useTranslationMode()
        #expect(session.floatingCaptionDisplayMode == .originalAndTranslation)
    }

    @Test
    @MainActor
    func transcribeOnlyModeKeepsFloatingCaptionsOriginalOnly() {
        let session = TranslationSessionStore()

        session.useTranscribeOnlyMode()
        session.floatingCaptionDisplayMode = .translation

        #expect(session.floatingCaptionDisplayMode == .original)
        #expect(session.availableFloatingCaptionDisplayModes == [.original])
    }

    @Test
    func startReadinessBlocksAppleStartWhenAssetsAreStillChecking() {
        let readiness = StartReadinessPolicy.assess(
            requiresOpenAIAPIKey: false,
            hasOpenAIAPIKey: false,
            requiredLocalModelAvailability: ModelAvailability(
                state: .checking,
                detail: "Checking"
            )
        )

        #expect(readiness.issue == .localAssetsChecking)
        #expect(!readiness.canStart)
    }

    @Test
    func startReadinessBlocksAppleStartWhenAssetsNeedDownload() {
        let readiness = StartReadinessPolicy.assess(
            requiresOpenAIAPIKey: false,
            hasOpenAIAPIKey: false,
            requiredLocalModelAvailability: ModelAvailability(
                state: .downloadRequired,
                detail: "Download needed"
            )
        )

        #expect(readiness.issue == .localAssetsDownloadRequired)
        #expect(!readiness.canStart)
    }

    @Test
    func startReadinessBlocksOpenAIStartWithoutAPIKey() {
        let readiness = StartReadinessPolicy.assess(
            requiresOpenAIAPIKey: true,
            hasOpenAIAPIKey: false,
            requiredLocalModelAvailability: nil
        )

        #expect(readiness.issue == .openAIAPIKeyMissing)
        #expect(!readiness.canStart)
    }

    @Test
    func startReadinessAllowsOpenAIStartWithAPIKeyWithoutLocalAssets() {
        let readiness = StartReadinessPolicy.assess(
            requiresOpenAIAPIKey: true,
            hasOpenAIAPIKey: true,
            requiredLocalModelAvailability: nil
        )

        #expect(readiness.canStart)
    }

    @Test
    @MainActor
    func startDownloadsRequiredAssetsWithoutClearingVisibleTranscript() async {
        let downloadProbe = ModelAssetDownloadProbe()
        let session = TranslationSessionStore(
            modelAvailabilityProvider: { _, _ in [:] },
            modelAssetDownloader: { model, _, _ in
                await downloadProbe.record(model)
                try await Task.sleep(for: .seconds(1))
            }
        )
        let existingLine = CaptionLine(
            sourceText: "Existing transcript should stay visible.",
            translatedText: "기존 기록은 남아 있어야 합니다.",
            createdAt: Date(),
            isFinal: true
        )
        session.sourceLanguage = .english
        session.targetLanguage = .korean
        session.selectedModel = .appleSystem
        session.lines = [existingLine]
        session.modelAvailabilityByModelID[session.selectedModel.id] = ModelAvailability(
            state: .downloadRequired,
            detail: "Download needed"
        )

        session.start()
        defer { session.stop() }
        try? await Task.sleep(for: .milliseconds(50))

        #expect(!session.isRunning)
        #expect(session.isStarting)
        #expect(session.lines == [existingLine])
        #expect(session.statusMessage == "\(AppText.modelStatusDownloading): \(IntelligenceModel.appleSystem.title)")
        #expect(await downloadProbe.modelIDs() == [IntelligenceModel.appleSystem.id])
    }
}

private actor ModelAssetDownloadProbe {
    private var models = [IntelligenceModel]()

    func record(_ model: IntelligenceModel) {
        models.append(model)
    }

    func modelIDs() -> [String] {
        models.map(\.id)
    }
}
