import AppKit
import SwiftUI

@main
struct AirTranslateApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @State private var session = TranslationSessionStore()
    @State private var menuBarPanelController = MenuBarPanelController()

    var body: some Scene {
        WindowGroup("AirTranslate", id: AirTranslateWindowID.main) {
            ContentView(session: session)
                .frame(minWidth: 900, minHeight: 560)
                .background(MenuBarPanelInstaller(session: session, controller: menuBarPanelController))
                .onReceive(NotificationCenter.default.publisher(for: NSApplication.willTerminateNotification)) { _ in
                    session.prepareForTermination()
                }
        }
        .commands {
            CommandGroup(replacing: .newItem) {}
        }

        Window(AppText.floatingCaptions, id: AirTranslateWindowID.floatingCaptions) {
            FloatingCaptionWindowView(session: session)
        }
        .defaultSize(width: 720, height: 170)
        .defaultWindowPlacement { content, context in
            let idealSize = content.sizeThatFits(.unspecified)
            let visibleRect = context.defaultDisplay.visibleRect
            let width = min(max(idealSize.width, 420), min(960, visibleRect.width - 32))
            let height = min(max(idealSize.height, 90), min(720, visibleRect.height - 32))
            let position = CGPoint(
                x: visibleRect.midX - width / 2,
                y: visibleRect.minY + min(180, visibleRect.height * 0.18)
            )
            return WindowPlacement(position, size: CGSize(width: width, height: height))
        }
        .windowStyle(.plain)
        .restorationBehavior(.disabled)

        Settings {
            SettingsView(session: session)
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        if let appIcon = NSImage(named: "AppIcon") {
            NSApp.applicationIconImage = appIcon
        }
        NSApp.setActivationPolicy(.regular)
        NSApp.activate(ignoringOtherApps: true)
    }
}
