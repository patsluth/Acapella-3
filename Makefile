




export FINALPACKAGE = 1
PACKAGE_VERSION = 1.0-14





ifeq ($(FINALPACKAGE), 0)
	export ARCHS = arm64
else
    export ARCHS = armv7 armv7s arm64
endif
export TARGET = iphone:clang:latest:8.0





BUNDLE_NAME = AcapellaSupport
AcapellaSupport_INSTALL_PATH = /Library/Application Support





SUBPROJECTS += Acapella3_Springboard
SUBPROJECTS += Acapella3_Music
SUBPROJECTS += Acapella3_Preferences
SUBPROJECTS += Acapella3_PreferencesBundle





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/tweak.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS)/makefiles/aggregate.mk
include $(THEOS)/makefiles/swcommon.mk




