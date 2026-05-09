import SwiftUI

struct SettingsView: View {
    @Bindable var session: TranslationSessionStore

    var body: some View {
        Form {
            Section(AppText.floatingCaptions) {
                Picker(AppText.floatingDisplay, selection: $session.floatingCaptionDisplayMode) {
                    ForEach(FloatingCaptionDisplayMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }

                Picker(AppText.floatingTextSize, selection: $session.floatingCaptionTextSize) {
                    ForEach(FloatingCaptionTextSize.allCases) { size in
                        Text(size.title).tag(size)
                    }
                }

                Picker(AppText.floatingLineCount, selection: $session.floatingCaptionLineCount) {
                    ForEach(FloatingCaptionLineCount.allCases) { lineCount in
                        Text(lineCount.title).tag(lineCount)
                    }
                }

                Text(AppText.floatingDisplayDescription)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Section(AppText.permissions) {
                Text(AppText.permissionsHelp)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(width: 420)
        .padding()
    }
}
