import Testing
@testable import AirTranslate

@Suite
struct FloatingCaptionTextFormatterTests {
    @Test
    func floatingCaptionTailWrapsLongEnglishCaptionWhileKeepingRecentLines() {
        let text = """
        This lecture introduces depreciation methods and deferred tax accounting before moving into practice questions for the next topic.
        """

        let caption = text.floatingCaptionTail(maxLines: 3)
        let lines = caption.split(separator: "\n", omittingEmptySubsequences: true)

        #expect(lines.count > 1)
        #expect(lines.count <= 3)
        #expect(caption.contains("deferred tax"))
    }

    @Test
    func floatingCaptionTailWrapsCJKTextWithoutWhitespace() {
        let text = "감가상각비와이연법인세회계처리를연속해서설명하는강의문장이길어져도자막창에서는읽기좋게나뉘어야합니다"

        let caption = text.floatingCaptionTail(maxLines: 3)
        let lines = caption.split(separator: "\n", omittingEmptySubsequences: true)

        #expect(lines.count > 1)
        #expect(lines.count <= 3)
        #expect(lines.allSatisfy { !$0.isEmpty })
    }

    @Test
    func floatingCaptionTailBreaksAfterCommonSentencePunctuation() {
        let text = "First idea appears. Second idea follows? Third idea lands!"

        let caption = text.floatingCaptionTail(maxLines: 3)

        #expect(caption == """
        First idea appears.
        Second idea follows?
        Third idea lands!
        """)
    }
}
