# AirTranslate 1.3.3

Transcribe Only workflow update for cleaner original-only captions and safer mode switching.

AirTranslate is an independent open-source project and is not affiliated with Apple or OpenAI.

## Added

- Added a clearer Transcribe Only output mode that hides the translation pane and keeps the live workspace focused on the original transcript.

## Changed

- Floating captions keep readable wrapping while streaming.
- Transcribe Only mode now keeps the hidden target language synchronized with the visible source language, so changing the source language does not silently switch back to Translation mode.
- Floating caption display choices are limited to Original while Transcribe Only mode is active.

## Fixed

- Prevented translation-only floating caption settings from producing blank floating captions in Transcribe Only mode.

## Download

- For most users: Download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to Applications.
- For ZIP users: Download `AirTranslate-1.3.3.zip`.
- Versioned DMG assets are also attached as `AirTranslate-1.3.3.dmg` and `AirTranslate-1.3.3.dmg.sha256`.

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License.
The DMG is provided as a convenient macOS installer and does not replace source distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch.

If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify checksum using `AirTranslate.dmg.sha256`.

Older GitHub Releases remain available for users who need a previous version.
