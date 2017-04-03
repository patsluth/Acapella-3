




export FINALPACKAGE = 1
export DEBUG = 0
PACKAGE_VERSION = 1.0-4





ifeq ($(DEBUG), 1)
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
include $(THEOS)/makefiles/bundle.mk
include $(THEOS)/makefiles/aggregate.mk
include $(THEOS)/makefiles/swcommon.mk





after-install after-uninstall::
	$(ECHO_NOTHING)install.exec "killall -9 backboardd > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 Music > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)
	$(ECHO_NOTHING)install.exec "killall -9 Preferences > /dev/null 2> /dev/null"; echo -n '';$(ECHO_END)




