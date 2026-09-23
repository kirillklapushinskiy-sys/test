ARCHS = arm64
TARGET = iphone:clang:latest:15.0
THEOS_PACKAGE_SCHEME = rootless
include $(THEOS)/makefiles/common.mk
TWEAK_NAME = ForceSpeaker
ForceSpeaker_FILES = Tweak.xm
ForceSpeaker_CFLAGS = -fobjc-arc
ForceSpeaker_FRAMEWORKS = AVFoundation Foundation UIKit
include $(THEOS_MAKE_PATH)/tweak.mk
after-install::
	install.exec "killall -9 SpringBoard || true"
