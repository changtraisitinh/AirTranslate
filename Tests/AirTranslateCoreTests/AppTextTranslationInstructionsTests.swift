import Testing
@testable import AirTranslate

@Suite
struct AppTextTranslationInstructionsTests {
    @Test
    func vietnameseTranslationInstructionsPreserveTechnicalTerms() {
        let instructions = AppText.openAITranslationInstructions(source: "English", target: "Vietnamese")

        #expect(instructions.localizedCaseInsensitiveContains("technical"))
        #expect(instructions.localizedCaseInsensitiveContains("IT"))
        #expect(instructions.localizedCaseInsensitiveContains("API"))
        #expect(instructions.localizedCaseInsensitiveContains("UI"))
    }
}
