




#import "SWAcapellaDelegate.h"

@class MPUControlCenterMediaControlsView;





@interface MPUControlCenterMediaControlsViewController : UIViewController

//_delegate --- @"<CCUIControlCenterPageContentViewControllerDelegate>"
//_routingController --- @"MPAVRoutingController"
//_routingViewController --- @"MPAVRoutingViewController"
//_routingViewVisible --- B
//_viewHasAppeared --- B
//_controlCenterPageIsVisible --- B
//_controlCenterPageVisibilityUpdateTimer --- @"MPWeakTimer"
//_pendingRouteStateTimer --- @"MPWeakTimer"

@end





@interface MPUControlCenterMediaControlsViewController(SW) <SWAcapellaDelegate>
{
}

@property (weak, nonatomic, readonly) MPUControlCenterMediaControlsView *mediaControlsView;

@end




