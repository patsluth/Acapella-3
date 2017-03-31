




FINALPACKAGE = 0
DEBUG = 1
PACKAGE_VERSION = 1.0-3





ifeq ($(DEBUG), 1)
	ARCHS = arm64
else
    ARCHS = armv7 armv7s arm64
endif
TARGET = iphone:clang:latest:8.0







TWEAK_NAME = Acapella3

Acapella3_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks
Acapella3_LDFLAGS += -F$(THEOS)/lib/
Acapella3_FILES = \
                        Acapella3.xm \
                    	SWAcapella.m \
                    	SWAcapellaCloneContainer.m \
                    	SWAcapellaPrefs.xm \
                    	SBDashBoardScrollGestureController.xm \
                    	MPUControlCenterMediaControlsView.xm \
                    	MPUControlCenterMediaControlsViewController.xm \
                    	MPULockScreenMediaControlsView.xm \
                    	MPULockScreenMediaControlsViewController.xm \

ifeq ($(DEBUG), 1)
	Acapella3_CFLAGS += -Wno-unused-variable
	Acapella3_FILES += SWAcapellaDebug.xm
endif

Acapella3_FRAMEWORKS = CoreFoundation Foundation UIKit CoreGraphics QuartzCore
Acapella3_PRIVATE_FRAMEWORKS = MediaRemote
Acapella3_WEAK_FRAMEWORKS = Sluthware
Acapella3_LIBRARIES = substrate sw MobileGestalt

ADDITIONAL_CFLAGS = -Ipublic





BUNDLE_NAME = AcapellaSupport
AcapellaSupport_INSTALL_PATH = /Library/Application Support





SUBPROJECTS += Acapella3_Music
SUBPROJECTS += Acapella3_Preferences
SUBPROJECTS += Acapella3_PreferencesBundle





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/aggregate.mk
include $(THEOS)/makefiles/swcommon.mk





after-install after-uninstall::
	$(ECHO_NOTHING)install.exec "killall -9 Music > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 backboardd > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)




