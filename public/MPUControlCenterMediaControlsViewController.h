




#import "MPUMediaRemoteViewController.h"

#import "SWAcapellaDelegate.h"

@class MPUControlCenterMediaControlsView;





@interface MPUControlCenterMediaControlsViewController : MPUMediaRemoteViewController

@end





@interface MPUControlCenterMediaControlsViewController(SW) <SWAcapellaDelegate>
{
}

@property (weak, nonatomic, readonly) MPUControlCenterMediaControlsView *mediaControlsView;

@end




