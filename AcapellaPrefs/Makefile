




BUNDLE_NAME = AcapellaPrefs3
AcapellaPrefs3_INSTALL_PATH = /Library/PreferenceBundles

AcapellaPrefs3_CFLAGS = -fobjc-arc
AcapellaPrefs3_LDFLAGS += -F$(THEOS)/lib/
AcapellaPrefs3_FILES =  SWAcapellaBasePSListController.mm \
                        SWAcapellaPSListController.mm \
                        SWAPSListController_Gestures.mm \
                        SWAPSListController_Instance.mm \
                        SWAPSListController_Transport.mm \
                        SWAPSListItemsController_Actions.mm \

AcapellaPrefs3_FRAMEWORKS = UIKit Sluthware
AcapellaPrefs3_PRIVATE_FRAMEWORKS = Preferences
AcapellaPrefs3_LIBRARIES = sw

ADDITIONAL_CFLAGS += -Ipublic





include theos/makefiles/common.mk
include theos/makefiles/bundle.mk
include theos/makefiles/aggregate.mk
include theos/makefiles/swcommon.mk





before-stage::
	$(ECHO_NOTHING)pwd >> temp.txt; echo SWAcapellaPSListController >> temp.txt; cat temp.txt | tr '\n' ';' | ./exportPrefs; rm -r -f temp.txt;$(ECHO_END)





internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/AcapellaPrefs3.plist$(ECHO_END)




