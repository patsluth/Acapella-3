




TWEAK_NAME = Acapella3_Music

Acapella3_Music_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks
Acapella3_Music_LDFLAGS += -F$(THEOS)/lib/
Acapella3_Music_FILES = \
			../Acapella3.xm \
                    	../SWAcapella.m \
                    	../SWAcapellaCloneContainer.m \
                    	../SWAcapellaPrefs.xm \
                    	_TtC5Music24MiniPlayerViewController.xm \
                   	 MusicNowPlayingControlsViewController.xm \

ifeq ($(DEBUG), 1)
	Acapella3_CFLAGS += -Wno-unused-variable
endif

Acapella3_Music_FRAMEWORKS = CoreFoundation Foundation UIKit CoreGraphics QuartzCore
Acapella3_Music_PRIVATE_FRAMEWORKS = MediaRemote
Acapella3_Music_WEAK_FRAMEWORKS = Sluthware
Acapella3_Music_LIBRARIES = substrate MobileGestalt

ADDITIONAL_CFLAGS = -Ipublic





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/swcommon.mk





after-install after-uninstall::
	$(ECHO_NOTHING)install.exec "killall -9 Music > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)




