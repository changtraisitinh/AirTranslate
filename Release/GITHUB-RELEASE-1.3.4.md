# AirTranslate 1.3.4

Floating caption readability update for size-aware line wrapping.

AirTranslate is an independent open-source project and is not affiliated with Apple or OpenAI.

## Changed

- Floating caption wrapping now scales with the selected caption text size instead of using one fixed width.
- Small, medium, large, and extra-large floating caption text sizes now each use a matching wrapping budget.
- This release applies `lidge-jun` / YEEE's PR #6, "fix: scale floating caption wrapping by text size".

## Download

- For most users: Download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to Applications.
- For ZIP users: Download `AirTranslate-1.3.4.zip`.
- Versioned DMG assets are also attached as `AirTranslate-1.3.4.dmg` and `AirTranslate-1.3.4.dmg.sha256`.

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License.
The DMG is provided as a convenient macOS installer and does not replace source distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch.

If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify checksum using `AirTranslate.dmg.sha256`.

Older GitHub Releases remain available for users who need a previous version.
