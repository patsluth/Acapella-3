




#import "MPUMediaRemoteViewController.h"

#import "SWAcapellaDelegate.h"

@class MPULockScreenMediaControlsView;





@interface MPULockScreenMediaControlsViewController : MPUMediaRemoteViewController

@end





@interface MPULockScreenMediaControlsViewController(SW) <SWAcapellaDelegate>
{
}

@property (weak, nonatomic, readonly) MPULockScreenMediaControlsView *mediaControlsView;

@end




