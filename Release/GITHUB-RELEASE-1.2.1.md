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

For most macOS users, download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to the Applications folder.

For developers or users who prefer the archive format, `AirTranslate-1.2.1.zip` is also available.

AirTranslate remains fully open-source under the Apache-2.0 License. The DMG is only a convenient macOS installation package; it does not replace the source code distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch. If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify the DMG checksum with `AirTranslate.dmg.sha256`.

## Privacy

Apple mode uses macOS system frameworks. GPT mode is optional and only sends the necessary audio or text to OpenAI after the user provides an API key.
