# AirTranslate 1.3.0

Release notes for Apple basic-mode microphone improvements and duplicate-input stability fixes.

AirTranslate is an independent open-source project and is not affiliated with Apple or OpenAI.

## Added

- Microphone input support now includes built-in microphones, Bluetooth devices, and AirPods.
- Apple basic mode now auto-detects source language when possible.

## Changed

- Improved microphone source handling for more stable live transcription.
- Improved duplicate-input suppression for Bluetooth and switching scenarios.

## Download

- For most users: Download `AirTranslate.dmg`, open it, and drag `AirTranslate.app` to Applications.
- For ZIP users: Download `AirTranslate-1.3.0.zip`.
- Versioned DMG assets are also attached as `AirTranslate-1.3.0.dmg` and `AirTranslate-1.3.0.dmg.sha256`.

## Fixed

- Reduced unstable duplicate transcript bursts from microphone input.
- Fixed input transitions that could duplicate segments after source changes.

## Distribution Notes

AirTranslate remains fully open-source under the Apache-2.0 License.
The DMG is provided as a convenient macOS installer and does not replace source distribution.

Because this build is not Apple-notarized yet, macOS may show an "unidentified developer" warning on first launch.

If that happens:

Control-click / right-click `AirTranslate.app` -> Open -> Open

You can verify checksum using `AirTranslate.dmg.sha256`.

Older GitHub Releases remain available for users who need a previous version.
