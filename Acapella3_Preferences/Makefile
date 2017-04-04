




TWEAK_NAME = Acapella3_Preferences

Acapella3_Preferences_CFLAGS = -fobjc-arc
Acapella3_Preferences_LDFLAGS += -F$(THEOS)/lib/
Acapella3_Preferences_FILES =  \
								../Acapella3.xm \

ifeq ($(FINALPACKAGE), 0)
	Acapella3_Preferences_CFLAGS += -Wno-unused-variable
endif

Acapella3_Preferences_FRAMEWORKS =
Acapella3_Preferences_PRIVATE_FRAMEWORKS =
Acapella3_Preferences_WEAK_FRAMEWORKS =
Acapella3_Preferences_LIBRARIES =

ADDITIONAL_CFLAGS += -I../public
ADDITIONAL_CFLAGS += -Ipublic





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/swcommon.mk




