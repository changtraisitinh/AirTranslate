# AirTranslate structure

This document maps the repository's runtime areas so contributors can find the
right files before changing the app.

## Swift Package Targets

- `Sources/AirTranslate`
  - The macOS SwiftUI executable target.
  - Owns the menu bar app, settings, live caption board, floating caption
    window, audio capture services, translation services, and transcript
    persistence.
- `Sources/AirTranslateCore`
  - Shared transcript text processing logic used by the app and tests.
- `Tests/AirTranslateCoreTests`
  - Swift Testing coverage for transcript processing and language-candidate
    behavior.

## Main App Surfaces

- `Sources/AirTranslate/App/AirTranslateApp.swift`
  - App entry point and scene setup.
- `Sources/AirTranslate/Views/ContentView.swift`
  - Main app shell.
- `Sources/AirTranslate/Views/SidebarView.swift`
  - Session controls, model/language choices, and inline settings.
- `Sources/AirTranslate/Views/CaptionBoardView.swift`
  - Live transcript workspace and caption rows.
- `Sources/AirTranslate/Views/FloatingCaptionWindowView.swift`
  - Always-on-top floating caption overlay.
- `Sources/AirTranslate/Views/TranscriptLibraryView.swift`
  - Saved transcript browser and editor.
- `Sources/AirTranslate/Views/SettingsView.swift`
  - Settings modal, including OpenAI and floating-caption settings.

## Session And Services

- `Sources/AirTranslate/Services/TranslationSessionStore.swift`
  - Main observable session state.
  - Coordinates audio capture, transcription, translation, caption lines,
    floating caption presentation, saving, and speech output.
- `Sources/AirTranslate/Services/SystemAudioCapture.swift`
  - ScreenCaptureKit-based system-audio capture.
- `Sources/AirTranslate/Services/MicrophoneAudioCapture.swift`
  - Microphone input capture.
- `Sources/AirTranslate/Services/LiveSpeechTranscriber.swift`
  - Apple Speech transcription.
- `Sources/AirTranslate/Services/OpenAIRealtimeTranscriber.swift`
  - Optional OpenAI realtime transcription.
- `Sources/AirTranslate/Services/AppleTranslationService.swift`
  - Apple Translation integration.
- `Sources/AirTranslate/Services/OpenAITranslationService.swift`
  - Optional OpenAI translation path.
- `Sources/AirTranslate/Services/TranslatedSpeechOutput.swift`
  - Spoken translated output.

## Floating Captions

- `Sources/AirTranslate/Support/FloatingCaptionWindowController.swift`
  - Floating caption panel lifecycle.
- `Sources/AirTranslate/Support/FloatingCaptionTextFormatter.swift`
  - Tail selection and line formatting for floating captions.
- `Sources/AirTranslate/Models/FloatingCaptionDisplayMode.swift`
  - Original, original plus translation, or translation-only display choices.
- `Sources/AirTranslate/Models/FloatingCaptionLineCount.swift`
  - User-selectable floating caption line count.
- `Sources/AirTranslate/Models/FloatingCaptionTextSize.swift`
  - User-selectable floating caption text size and line-height estimates.

## Release And Site

- `Release`
  - Release notes, release assets, and release packaging scripts.
- `docs`
  - Static guide site served by GitHub Pages.
- `script`
  - Local build metadata and helper scripts.

## Local-Only Notes

Contributor-local planning notes can live in `devlog/`. That directory is
ignored so private investigation notes do not appear in pull requests.
