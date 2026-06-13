# AirTranslate Version History

## 1.3.5 - 2026-06-13

### Changed

- Saved transcript history now loads lightweight previews first and opens full text only when a transcript is selected.
- Realtime GPT transcript updates are coalesced to reduce MainActor and UI churn during long sessions.
- Realtime audio send backlog is bounded so stalled network sends cannot accumulate without limit.
- Start/stop capture teardown is serialized before a new capture start.

### Fixed

- Very large transcript panes now render a bounded display tail even in standard session mode while preserving the full saved text.

## 1.3.4 - 2026-05-26

### Changed

- Floating caption wrapping now scales with the selected text size so larger captions keep readable text within the floating window.

## 1.3.3 - 2026-05-26

### Added

- Added a dedicated Transcribe Only output mode that shows only the original transcript pane.

### Changed

- Floating captions keep the wrapping improvements from 1.3.2-era development and stay original-only during Transcribe Only sessions.
- Transcribe Only language changes now keep the hidden target language aligned with the visible source language.

### Fixed

- Prevented blank translation-only floating captions while Transcribe Only mode is active.

## 1.3.2 - 2026-05-17

### Fixed

- Centered the empty transcript placeholder in the main workspace.

## 1.3.1 - 2026-05-16

### Changed

- Temporarily disabled Apple basic-mode source language auto-detection while language-switch handling is improved.
- Added a clear in-app notice when the disabled auto-detect toggle is clicked.

### Fixed

- Prevented saved auto-detect preferences from re-enabling the feature in this build.

## 1.3.0 - 2026-05-16

### Added

- Added input support for built-in, Bluetooth, and AirPods microphones.
- Added source language auto-detection for Apple basic mode when language inference is available.

### Changed

- Improved microphone pipeline stability for long sessions.

### Fixed

- Fixed duplicate transcript input from unstable microphone transitions.
- Reduced duplicate segments when switching capture source setup.

## 1.2.1 - 2026-05-14

### Changed

- Apple mode now keeps the visible mode and internal translation state aligned.
- GPT mode setup now uses the same session-level mode switching path as Apple mode.

### Fixed

- Fixed Apple default mode translation staying inactive while transcription continued.
- Translation unavailable states now show a clear message in the translation output.

## 1.2.0 - 2026-05-13

### Added

- Optional GPT realtime transcription and translation modes.
- Realtime translation-only path with optional translated audio playback.
- macOS Keychain storage for user-provided OpenAI API keys.
- English, Korean, Japanese, and Simplified Chinese README files.

### Changed

- GPT realtime floating captions show only the current live caption unit instead of the accumulated transcript.
- GPT realtime output is preserved without transcript lint cleanup rewriting model text.
- Saved original-plus-translation transcripts are grouped as one library item.

### Fixed

- Reduced duplicate live transcript text after paragraph cleanup or settings changes.
- Improved per-pane editing behavior for saved original and translated transcripts.

## 1.1.0 - 2026-05-10

### Added

- Centered live audio waveform meter.

### Changed

- Improved hover, pressed, active, and click-confirmation feedback for transport controls.
- Moved the live audio waveform into the center header area.

## 2026-05-09 - Library Modal UI

### Added

- Original-plus-translation saved transcripts grouped into a single library row.
- Confirmation-protected delete-all action.

### Changed

- Saved transcript management moved from the sidebar into a focused modal.

## 2026-05-09 - Transcript Control and Stability

### Added

- Configurable silence interval for paragraph breaks.

### Fixed

- Bounded speech analyzer input buffering.
- Bounded translation segment cache.
- Reduced text animation work for long transcript updates.
