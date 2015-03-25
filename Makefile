SDKVERSION = 7.0
ARCHS = armv7 arm64

BUNDLE_NAME = FLEXibleFS
FLEXibleFS_FILES = Switch.xm
FLEXibleFS_LIBRARIES = flipswitch
FLEXibleFS_INSTALL_PATH = /Library/Switches

SUBPROJECTS += FLEXibleToggle

include theos/makefiles/common.mk
include $(THEOS_MAKE_PATH)/aggregate.mk
include $(THEOS_MAKE_PATH)/bundle.mk
