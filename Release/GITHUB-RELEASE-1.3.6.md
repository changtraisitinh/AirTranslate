# AirTranslate 1.3.6

Live translation mode cleanup, Gemini Live support, and translated-audio volume fixes.

AirTranslate is an independent open-source project and is not affiliated with Apple, OpenAI, or Google.

## Added

- Added Gemini 3.5 Live Translate mode for direct audio-to-live-translation sessions.
- Added Gemini API key storage in macOS Keychain with in-app missing-key guidance.
- Added a compact LIVE Translation entry point for API-backed GPT and Gemini modes.
- Added a sidebar voice-output toggle and a single translated-voice volume slider.

## Changed

- GPT mode now uses OpenAI Realtime Translation as the realtime translation path and displays source transcript updates from the realtime session.
- API-backed GPT and Gemini modes now use one translated-audio speaker path instead of separate original/translated volume controls.
- Apple basic mode keeps voice output off by default, while API-backed modes default translated voice output on.
- Settings and sidebar controls now separate Apple basic mode, GPT Realtime, and Gemini Live Translate more clearly.

## Fixed

- Fixed source-language changes in the quick sidebar language control unexpectedly switching the app to Transcribe Only mode.
- Fixed GPT realtime translation not showing the original transcript while Gemini Live did.
- Fixed translated audio playback in GPT and Gemini live modes.
- Fixed Apple basic-mode translated speech output lowering the Mac system volume.

## Download

- For most users: Download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to Applications.
- For ZIP users: Download `AirTranslate-1.3.6.zip`.
- Versioned DMG assets are also attached as `AirTranslate-1.3.6.dmg` and `AirTranslate-1.3.6.dmg.sha256`.

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License.
The DMG is provided as a convenient macOS installer and does not replace source distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch.

If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify checksum using `AirTranslate.dmg.sha256`.

Older GitHub Releases remain available for users who need a previous version.
