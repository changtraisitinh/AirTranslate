import SwiftUI

struct CaptionBoardView: View {
    @Bindable var session: TranslationSessionStore
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            SessionOverviewCard(
                title: AppText.liveCaptions,
                subtitle: session.languageSummary,
                modelDetail: session.selectedModel.detail,
                isRunning: session.isRunning,
                isPaused: session.isPaused,
                isDubbingEnabled: session.isDubbingEnabled,
                isTranscriptLintEnabled: session.isTranscriptLintEnabled,
                modelTitle: session.selectedModel.title
            ) {
                openWindow(id: AirTranslateWindowID.floatingCaptions)
            }

            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 10) {
                        if session.lines.isEmpty {
                            ContentUnavailableView(
                                AppText.noCaptionsYet,
                                systemImage: "captions.bubble",
                                description: Text(AppText.noCaptionsDescription)
                            )
                            .frame(maxWidth: .infinity, minHeight: 320)
                            .padding(24)
                            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 18, style: .continuous)
                                    .strokeBorder(Color.primary.opacity(0.08))
                            }
                        }

                        ForEach(session.lines) { line in
                            CaptionLineView(line: line)
                                .id(line.id)
                                .transition(.move(edge: .bottom).combined(with: .opacity))
                        }
                    }
                    .padding(.vertical, 4)
                    .animation(.spring(response: 0.32, dampingFraction: 0.86), value: session.lines.count)
                }
                .onChange(of: session.lines.last?.id) { _, id in
                    if let id {
                        withAnimation(.easeOut(duration: 0.22)) {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: session.lines.last?.revision) { _, _ in
                    if let id = session.lines.last?.id {
                        withAnimation(.easeOut(duration: 0.22)) {
                            proxy.scrollTo(id, anchor: .bottom)
                        }
                    }
                }
            }
        }
        .padding(24)
    }
}

private struct CaptionLineView: View {
    let line: CaptionLine

    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            TranscriptPane(
                title: AppText.original,
                description: AppText.originalDescription,
                text: line.sourceText,
                isPrimary: true
            )
            TranscriptPane(
                title: AppText.translation,
                description: AppText.translationDescription,
                text: line.translatedText,
                isPrimary: false
            )
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

private struct TranscriptPane: View {
    let title: String
    let description: String
    let text: String
    let isPrimary: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(description)
                .font(.caption)
                .foregroundStyle(.tertiary)

            StreamingTranscriptText(
                text: text,
                font: isPrimary ? .body : .body.weight(.medium)
            )
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 360, alignment: .topLeading)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08))
        }
    }
}

private struct SessionOverviewCard: View {
    let title: String
    let subtitle: String
    let modelDetail: String
    let isRunning: Bool
    let isPaused: Bool
    let isDubbingEnabled: Bool
    let isTranscriptLintEnabled: Bool
    let modelTitle: String
    let showFloatingCaptions: () -> Void

    var body: some View {
        HStack(alignment: .top, spacing: 20) {
            VStack(alignment: .leading, spacing: 12) {
                Text(title)
                    .font(.title2.weight(.semibold))

                Text(subtitle)
                    .font(.headline.weight(.medium))
                    .foregroundStyle(.secondary)

                Text(modelDetail)
                    .font(.subheadline)
                    .foregroundStyle(.tertiary)

                HStack(spacing: 8) {
                    SessionMetadataChip(systemImage: "brain.head.profile", title: modelTitle)
                    SessionMetadataChip(systemImage: "square.and.arrow.down", title: AppText.autoSave)

                    if isDubbingEnabled {
                        SessionMetadataChip(systemImage: "waveform.and.mic", title: AppText.dubbing)
                    }

                    if isTranscriptLintEnabled {
                        SessionMetadataChip(systemImage: "text.badge.checkmark", title: AppText.transcriptLint)
                    }
                }
            }

            Spacer(minLength: 0)

            VStack(alignment: .trailing, spacing: 12) {
                SessionStatusBadge(isRunning: isRunning, isPaused: isPaused)

                Button(action: showFloatingCaptions) {
                    Label(AppText.showFloatingCaptions, systemImage: "macwindow.on.rectangle")
                }
                .buttonStyle(.bordered)
            }
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08))
        }
    }
}

private struct SessionStatusBadge: View {
    let isRunning: Bool
    let isPaused: Bool

    private var title: String {
        isPaused ? AppText.paused : (isRunning ? AppText.listening : AppText.idle)
    }

    private var systemImage: String {
        isPaused ? "pause.circle.fill" : (isRunning ? "waveform.circle.fill" : "moon.zzz.fill")
    }

    private var foregroundStyle: Color {
        isPaused ? .orange : (isRunning ? .green : .secondary)
    }

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(foregroundStyle.opacity(0.12), in: Capsule())
            .foregroundStyle(foregroundStyle)
            .accessibilityElement(children: .combine)
    }
}

private struct SessionMetadataChip: View {
    let systemImage: String
    let title: String

    var body: some View {
        Label(title, systemImage: systemImage)
            .font(.caption.weight(.medium))
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.quaternary.opacity(0.45), in: Capsule())
            .foregroundStyle(.secondary)
    }
}
