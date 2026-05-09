import SwiftUI

struct MenuBarStatusView: View {
    @Bindable var session: TranslationSessionStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .center, spacing: 10) {
                Image(systemName: session.isPaused ? "pause.circle.fill" : (session.isRunning ? "waveform.circle.fill" : "captions.bubble.fill"))
                    .font(.title2)
                    .foregroundStyle(session.isPaused ? .orange : (session.isRunning ? .green : .secondary))

                VStack(alignment: .leading, spacing: 2) {
                    Text(AppText.floatingCaptions)
                        .font(.headline)

                    Text(session.statusMessage)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                Spacer(minLength: 0)
            }

            HStack(spacing: 8) {
                Button {
                    openWindow(id: AirTranslateWindowID.floatingCaptions)
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Label(AppText.showFloatingCaptions, systemImage: "macwindow.on.rectangle")
                }

                Button {
                    FloatingCaptionWindowController.close()
                } label: {
                    Image(systemName: "eye.slash")
                }
                .help(AppText.hideFloatingCaptions)

                Button {
                    openWindow(id: AirTranslateWindowID.main)
                    NSApp.activate(ignoringOtherApps: true)
                } label: {
                    Image(systemName: "macwindow")
                }
                .help(AppText.openMainWindow)
            }

            Divider()

            VStack(alignment: .leading, spacing: 10) {
                settingRow(AppText.floatingDisplay) {
                    Picker(AppText.floatingDisplay, selection: $session.floatingCaptionDisplayMode) {
                        ForEach(FloatingCaptionDisplayMode.allCases) { mode in
                            Text(mode.title).tag(mode)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }

                settingRow(AppText.floatingTextSize) {
                    Picker(AppText.floatingTextSize, selection: $session.floatingCaptionTextSize) {
                        ForEach(FloatingCaptionTextSize.allCases) { size in
                            Text(size.title).tag(size)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }

                settingRow(AppText.floatingLineCount) {
                    Picker(AppText.floatingLineCount, selection: $session.floatingCaptionLineCount) {
                        ForEach(FloatingCaptionLineCount.allCases) { lineCount in
                            Text(lineCount.title).tag(lineCount)
                        }
                    }
                    .labelsHidden()
                    .pickerStyle(.segmented)
                }
            }

            Divider()

            HStack(spacing: 8) {
                Button {
                    session.isRunning ? session.stop() : session.start()
                } label: {
                    Label(session.isRunning ? AppText.stop : AppText.start, systemImage: session.isRunning ? "stop.fill" : "play.fill")
                }
                .buttonStyle(.borderedProminent)

                if session.isRunning {
                    Button {
                        session.isPaused ? session.resume() : session.pause()
                    } label: {
                        Label(
                            session.isPaused ? AppText.resume : AppText.pause,
                            systemImage: session.isPaused ? "play.fill" : "pause.fill"
                        )
                    }
                }
            }
        }
        .padding(16)
        .frame(width: 360)
        .background(.regularMaterial)
    }

    private func settingRow<Content: View>(
        _ title: String,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)

            content()
        }
    }
}
