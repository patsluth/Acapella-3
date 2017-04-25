




TWEAK_NAME = Acapella3_Springboard

Acapella3_Springboard_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks
Acapella3_Springboard_LDFLAGS += -F$(THEOS)/lib/
Acapella3_Springboard_FILES = \
						../Acapella3.xm \
                    	../SWAcapella.m \
                    	../SWAcapellaCloneContainer.m \
						../SWAcapellaPrefs.xm \
						../AVSystemController.xm \
                    	SBDashBoardScrollGestureController.xm \
                    	MPUControlCenterMediaControlsView.xm \
                    	MPUControlCenterMediaControlsViewController.xm \
                    	MPULockScreenMediaControlsView.xm \
                    	MPULockScreenMediaControlsViewController.xm \

ifeq ($(FINALPACKAGE), 0)
	Acapella3_Springboard_CFLAGS += -Wno-unused-variable -Wno-unused-function
	Acapella3_Springboard_FILES += ../SWAcapellaDebug.xm
endif

Acapella3_Springboard_FRAMEWORKS = CoreFoundation Foundation UIKit CoreGraphics QuartzCore
Acapella3_Springboard_PRIVATE_FRAMEWORKS = MediaRemote
Acapella3_Springboard_WEAK_FRAMEWORKS = Sluthware
Acapella3_Springboard_LIBRARIES = substrate sw2 MobileGestalt

ADDITIONAL_CFLAGS += -I../public
ADDITIONAL_CFLAGS += -Ipublic

INSTALL_TARGET_PROCESSES = backboardd





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/swcommon.mk




