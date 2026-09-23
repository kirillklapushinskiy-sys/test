# ForceSpeaker

Rootless jailbreak tweak intended for iOS 15+ / Dopamine.

## What it does

When an app activates an `AVAudioSession`, ForceSpeaker asks iOS to use the
built-in speaker when no external audio route (headphones, Bluetooth, AirPlay,
car audio) is currently connected.

It is intended to make receiver-style audio sessions use the loudspeaker.

## Important limitation

iOS/CallKit can change the audio route after a tweak requests it. This means
the tweak cannot guarantee that every system call or every third-party VoIP
implementation will stay on the loudspeaker.

## Target

- iPhone 7
- iOS 15.8.x
- Dopamine / rootless
- arm64

## Build

Requires Theos:

```sh
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless
```

The resulting package is in `packages/`.

## Install

Transfer the generated `.deb` to the iPhone and open it with Sileo.

If audio behaves incorrectly, uninstall the package from Sileo and respring.
