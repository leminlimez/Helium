ARCHS := arm64e
TARGET := iphone:clang:15.0
INSTALL_TARGET_PROCESSES := XXTAssistiveTouch

TARGET_CC := $(shell xcrun --sdk iphoneos --find clang)
TARGET_CXX := $(shell xcrun --sdk iphoneos --find clang++)
TARGET_LD := $(shell xcrun --sdk iphoneos --find clang++)

include $(THEOS)/makefiles/common.mk
APPLICATION_NAME = XXTAssistiveTouch

$(APPLICATION_NAME)_USE_MODULES := 0
$(APPLICATION_NAME)_FILES += $(wildcard *.mm *.m) $(wildcard *.swift)
$(APPLICATION_NAME)_CFLAGS += -fobjc-arc -Iinclude
$(APPLICATION_NAME)_CFLAGS += -include hud-prefix.pch -Wno-deprecated-declarations 

$(APPLICATION_NAME)_CCFLAGS += -DNOTIFY_LAUNCHED_HUD=\"com.leemin.notification.hud.launched\"
$(APPLICATION_NAME)_CCFLAGS += -DNOTIFY_DISMISSAL_HUD=\"com.leemin.notification.hud.dismissal\"
$(APPLICATION_NAME)_CCFLAGS += -DNOTIFY_RELOAD_HUD=\"com.leemin.notification.hud.reload\"

$(APPLICATION_NAME)_FRAMEWORKS += CoreGraphics QuartzCore UIKit Foundation
$(APPLICATION_NAME)_PRIVATE_FRAMEWORKS += BackBoardServices GraphicsServices IOKit SpringBoardServices

ifeq ($(TARGET_CODESIGN),ldid)
$(APPLICATION_NAME)_CODESIGN_FLAGS += -Sent.plist
else
$(APPLICATION_NAME)_CODESIGN_FLAGS += --entitlements ent.plist $(TARGET_CODESIGN_FLAGS)
endif

include $(THEOS_MAKE_PATH)/application.mk

after-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cp -rp $(THEOS_STAGING_DIR)/Applications/XXTAssistiveTouch.app $(THEOS_STAGING_DIR)/Payload$(ECHO_END)
	$(ECHO_NOTHING)cd $(THEOS_STAGING_DIR); zip -qr XXTAssistiveTouch.tipa Payload; cd -;$(ECHO_END)
