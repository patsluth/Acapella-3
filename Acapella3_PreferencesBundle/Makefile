




BUNDLE_NAME = Acapella3_PreferencesBundle

Acapella3_PreferencesBundle_INSTALL_PATH = /Library/PreferenceBundles

Acapella3_PreferencesBundle_CFLAGS = -fobjc-arc
Acapella3_PreferencesBundle_LDFLAGS += -F$(THEOS)/lib/
Acapella3_PreferencesBundle_FILES =  \
                                SWAcapellaBasePSListController.mm \
                        		SWAcapellaPSListController.mm \
                        		SWAPSListController_Gestures.mm \
                        		SWAPSListController_Instance.mm \
                        		SWAPSListController_Transport.mm \
                        		SWAPSListItemsController_Actions.mm \

ifeq ($(FINALPACKAGE), 0)
	Acapella3_PreferencesBundle_CFLAGS += -Wno-unused-variable
endif

Acapella3_PreferencesBundle_FRAMEWORKS = UIKit
Acapella3_PreferencesBundle_PRIVATE_FRAMEWORKS = Preferences
Acapella3_PreferencesBundle_WEAK_FRAMEWORKS = Sluthware
Acapella3_PreferencesBundle_LIBRARIES = sw2

ADDITIONAL_CFLAGS += -I../public
ADDITIONAL_CFLAGS += -Ipublic





include $(THEOS)/makefiles/common.mk
include $(THEOS)/makefiles/bundle.mk
include $(THEOS)/makefiles/swcommon.mk





before-stage::
	$(ECHO_NOTHING)pwd >> temp.txt; echo SWAcapellaPSListController >> temp.txt; cat temp.txt | tr '\n' ';' | ./exportPrefs; rm -r -f temp.txt;$(ECHO_END)





internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/Acapella3_PreferencesBundle.plist$(ECHO_END)




