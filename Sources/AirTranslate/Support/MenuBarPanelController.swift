import AppKit
import SwiftUI

@MainActor
final class MenuBarPanelController: NSObject, NSPopoverDelegate {
    private let popover = NSPopover()
    private let hostingController = NSHostingController(rootView: AnyView(EmptyView()))
    private var statusItem: NSStatusItem?
    private weak var session: TranslationSessionStore?
    private var lastWasActive = false

    override init() {
        super.init()
        popover.animates = true
        popover.behavior = .transient
        popover.contentSize = NSSize(width: 360, height: 430)
        popover.contentViewController = hostingController
        popover.delegate = self
    }

    func install(session: TranslationSessionStore) {
        ensureStatusItem()
        update(session: session)
    }

    func update(session: TranslationSessionStore) {
        self.session = session
        hostingController.rootView = AnyView(MenuBarStatusView(session: session))
        updateStatusButton(using: session)
    }

    func popoverDidShow(_ notification: Notification) {
        refreshButtonAppearance()
    }

    func popoverDidClose(_ notification: Notification) {
        refreshButtonAppearance()
    }

    @objc
    private func togglePopover(_ sender: Any?) {
        guard let button = statusItem?.button else {
            return
        }

        if popover.isShown {
            popover.performClose(sender)
        } else {
            NSApp.activate(ignoringOtherApps: true)
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            popover.contentViewController?.view.window?.makeKey()
        }

        refreshButtonAppearance()
    }

    private func ensureStatusItem() {
        guard statusItem == nil else {
            return
        }

        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.isVisible = true
        statusItem = item

        guard let button = item.button else {
            return
        }

        button.target = self
        button.action = #selector(togglePopover(_:))
        button.sendAction(on: [.leftMouseDown])
        button.imagePosition = .imageLeading
        button.imageScaling = .scaleProportionallyDown
        button.toolTip = AppText.menuBarTitle
    }

    private func refreshButtonAppearance() {
        guard let session else {
            return
        }

        updateStatusButton(using: session)
    }

    private func updateStatusButton(using session: TranslationSessionStore) {
        refreshStatusItemPositionIfNeeded(session: session)
        guard let button = statusItem?.button else {
            return
        }

        let isEmphasized = popover.isShown || session.isRunning || session.isPaused
        let titleColor = isEmphasized ? NSColor.labelColor : NSColor.secondaryLabelColor
        let titleWeight: NSFont.Weight = isEmphasized ? .semibold : .regular
        let title = menuBarTitle(for: session)

        button.attributedTitle = NSAttributedString(
            string: title,
            attributes: [
                .font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize, weight: titleWeight),
                .foregroundColor: titleColor
            ]
        )
        button.image = statusImage(for: session, emphasized: isEmphasized)
        button.contentTintColor = statusTintColor(for: session, emphasized: isEmphasized)
        button.toolTip = session.statusMessage
    }

    private func refreshStatusItemPositionIfNeeded(session: TranslationSessionStore) {
        let isActive = session.isRunning || session.isPaused
        guard isActive != lastWasActive else {
            return
        }

        lastWasActive = isActive
        guard let statusItem else {
            return
        }

        NSStatusBar.system.removeStatusItem(statusItem)
        self.statusItem = nil
        ensureStatusItem()
    }

    private func menuBarTitle(for session: TranslationSessionStore) -> String {
        if session.isPaused {
            return AppText.menuBarPausedTitle
        }
        if session.isRunning {
            return AppText.menuBarRunningTitle
        }
        return AppText.menuBarTitle
    }

    private func statusImage(for session: TranslationSessionStore, emphasized: Bool) -> NSImage? {
        let symbolName: String
        if session.isPaused {
            symbolName = "pause.circle.fill"
        } else if session.isRunning {
            symbolName = "waveform.circle.fill"
        } else {
            symbolName = "captions.bubble.fill"
        }

        let configuration = NSImage.SymbolConfiguration(
            pointSize: NSFont.smallSystemFontSize,
            weight: emphasized ? .bold : .regular
        )

        guard let image = NSImage(systemSymbolName: symbolName, accessibilityDescription: menuBarTitle(for: session))?
            .withSymbolConfiguration(configuration)
        else {
            return nil
        }

        image.isTemplate = true
        return image
    }

    private func statusTintColor(for session: TranslationSessionStore, emphasized: Bool) -> NSColor {
        if session.isPaused {
            return .systemOrange
        }
        if session.isRunning {
            return .controlAccentColor
        }
        return emphasized ? .labelColor : .secondaryLabelColor
    }
}
