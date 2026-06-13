# AirTranslate 1.3.5

Runtime performance and long-session stability update.

AirTranslate is an independent open-source project and is not affiliated with Apple or OpenAI.

## Changed

- Saved transcript history now loads lightweight previews first, then loads full transcript text only when a saved item is selected.
- GPT realtime transcript updates are coalesced to reduce MainActor and UI churn during long sessions.
- GPT realtime audio send backlog is bounded so stalled network sends cannot accumulate without limit.
- Capture start now waits for any previous stop teardown before starting a new capture session.

## Fixed

- Very large transcript panes now render a bounded display tail even in standard session mode while keeping the full text available for saving and copying.
- GPT translated audio output now decodes base64 audio on the audio queue instead of the MainActor path.

## Download

- For most users: Download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to Applications.
- For ZIP users: Download `AirTranslate-1.3.5.zip`.
- Versioned DMG assets are also attached as `AirTranslate-1.3.5.dmg` and `AirTranslate-1.3.5.dmg.sha256`.

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License.
The DMG is provided as a convenient macOS installer and does not replace source distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch.

If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify checksum using `AirTranslate.dmg.sha256`.

Older GitHub Releases remain available for users who need a previous version.
