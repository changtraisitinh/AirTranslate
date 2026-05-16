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
}
