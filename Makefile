




FINALPACKAGE = 1
DEBUG = 0
PACKAGE_VERSION = 1.0-1





ifeq ($(DEBUG), 1)
	ARCHS = arm64
else
    ARCHS = armv7 armv7s arm64
endif
TARGET = iphone:clang:latest:7.0







TWEAK_NAME = Acapella3

Acapella3_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks
Acapella3_FILES =   _TtC5Music24MiniPlayerViewController.xm \
                    MusicNowPlayingControlsViewController.xm \
                    MPUControlCenterMediaControlsView.xm \
                    MPUControlCenterMediaControlsViewController.xm \
                    MPULockScreenMediaControlsView.xm \
                    MPULockScreenMediaControlsViewController.xm \
                    SBDashBoardScrollGestureController.xm \
                    SWAcapella.m \
                    SWAcapellaCloneContainer.m \
                    SWAcapellaPrefs.xm

ifeq ($(DEBUG), 1)
	Acapella3_CFLAGS += -Wno-unused-variable
	Acapella3_FILES += SWAcapellaDebug.xm
endif

Acapella3_FRAMEWORKS = CoreFoundation Foundation UIKit CoreGraphics QuartzCore
Acapella3_OTHER_FRAMEWORKS = Sluthware
Acapella3_PRIVATE_FRAMEWORKS = MediaRemote
Acapella3_LIBRARIES = substrate sw packageinfo MobileGestalt

ADDITIONAL_CFLAGS = -Ipublic





BUNDLE_NAME = AcapellaSupport
AcapellaSupport_INSTALL_PATH = /Library/Application Support





SUBPROJECTS += AcapellaPrefs





include theos/makefiles/common.mk
include theos/makefiles/bundle.mk
include theos/makefiles/tweak.mk
include theos/makefiles/aggregate.mk
include theos/makefiles/swcommon.mk





after-install after-uninstall::
	$(ECHO_NOTHING)install.exec "killall -9 Music > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 Podcasts > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 Preferences > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 backboardd > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)




