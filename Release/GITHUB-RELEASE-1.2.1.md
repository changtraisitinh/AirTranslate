# AirTranslate 1.2.1

Patch release for Apple default mode translation reliability.

AirTranslate is an independent open-source project and is not affiliated with Apple or OpenAI.

## Changed

- Apple mode now resets GPT transcription and translation model state when selected.
- Apple and GPT mode switching now uses shared session helpers to keep visible mode and internal processing state aligned.

## Fixed

- Fixed Apple default mode translation staying inactive while live transcription continued.
- Translation unavailable states now appear in the translation output instead of leaving the pane stuck on `Translating...`.

## Included from 1.2.0

- Optional OpenAI Realtime transcription and translation modes.
- Realtime translation-only mode with optional translated audio playback.
- Floating captions in GPT mode show the current live caption unit.
- English, Korean, Japanese, and Simplified Chinese README files.

## Download

Download `AirTranslate-1.2.1.zip` from this release, unzip it, then open `AirTranslate.app`.

macOS may require you to approve the app in Privacy & Security because this ZIP is an open-source ad-hoc signed build, not a notarized distribution.

## Privacy

Apple mode uses macOS system frameworks. GPT mode is optional and only sends the necessary audio or text to OpenAI after the user provides an API key.
