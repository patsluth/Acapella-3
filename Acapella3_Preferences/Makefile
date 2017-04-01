




TWEAK_NAME = Acapella3_Preferences

Acapella3_Preferences_CFLAGS = -fobjc-arc -Wno-arc-performSelector-leaks
Acapella3_Preferences_LDFLAGS += -F$(THEOS)/lib/
Acapella3_Preferences_FILES = \
                                ../Acapella3.xm \

ifeq ($(DEBUG), 1)
	Acapella3_Preferences_CFLAGS += -Wno-unused-variable
	Acapella3_Preferences_FILES += ../SWAcapellaDebug.xm
endif

Acapella3_Preferences_FRAMEWORKS =
Acapella3_Preferences_PRIVATE_FRAMEWORKS =
Acapella3_Preferences_WEAK_FRAMEWORKS =
Acapella3_Preferences_LIBRARIES = 

ADDITIONAL_CFLAGS = -Ipublic





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/swcommon.mk




