# ForceSpeaker

Rootless jailbreak tweak for iOS 15+ / Dopamine.

It requests the built-in speaker for AVAudioSession audio sessions when no external route is connected.

Build:
make clean package FINALPACKAGE=1 THEOS_PACKAGE_SCHEME=rootless

Install the generated .deb with Sileo.
