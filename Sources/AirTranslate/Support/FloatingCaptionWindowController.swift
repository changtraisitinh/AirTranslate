import AppKit

@MainActor
enum FloatingCaptionWindowController {
    static func close() {
        floatingWindow?.close()
    }

    private static var floatingWindow: NSWindow? {
        NSApp.windows.first { window in
            window.identifier?.rawValue == AirTranslateWindowID.floatingCaptions
                || window.title == AppText.floatingCaptions
        }
    }
}
