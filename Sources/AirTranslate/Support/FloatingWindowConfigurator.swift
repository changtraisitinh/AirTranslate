import AppKit
import SwiftUI

struct FloatingWindowConfigurator: NSViewRepresentable {
    let preferredContentHeight: CGFloat

    func makeNSView(context _: Context) -> NSView {
        NSView()
    }

    func updateNSView(_ view: NSView, context _: Context) {
        DispatchQueue.main.async {
            guard let window = view.window else { return }

            window.identifier = NSUserInterfaceItemIdentifier(AirTranslateWindowID.floatingCaptions)
            window.level = .floating
            window.collectionBehavior.insert([.canJoinAllSpaces, .fullScreenAuxiliary])
            window.isMovableByWindowBackground = true
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.backgroundColor = .clear
            window.isOpaque = false
            window.hasShadow = false

            let minimumSize = NSSize(width: 420, height: preferredContentHeight)
            window.minSize = minimumSize
            if window.contentLayoutRect.height + 1 < preferredContentHeight {
                window.setContentSize(
                    NSSize(
                        width: max(window.contentLayoutRect.width, minimumSize.width),
                        height: preferredContentHeight
                    )
                )
            }
        }
    }
}
