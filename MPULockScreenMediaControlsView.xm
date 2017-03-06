//
//  MPULockScreenMediaControlsView.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPULockScreenMediaControlsView.h"

#import "libsw/libSluthware/libSluthware.h"
#import "libsw/SWAppLauncher.h"





#pragma mark - MPULockScreenMediaControlsView

%hook MPULockScreenMediaControlsView

%new
- (UIView *)titlesView
{
    return MSHookIvar<UIView *>(self, "_titlesView");
}

- (void)layoutSubviews
{
    %orig();
    
    
    // Calcualate centre based on visible controls
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        
        CGFloat topGuideline = 0.0;
        
        if (self.timeView.layer.opacity > 0.0) {
            topGuideline += CGRectGetMaxY(self.timeView.frame);
        }
        
        CGFloat bottomGuideline = CGRectGetMaxY(self.bounds);
        
        if (!self.transportControls.hidden && self.transportControls.layer.opacity > 0.0) {
            bottomGuideline = CGRectGetMinY(self.transportControls.frame);
        } else {
            if (self.volumeView.layer.opacity > 0.0) { // Visible
                bottomGuideline = CGRectGetMinY(self.volumeView.frame);
            }
        }
        
        
        // The midpoint between the currently visible views. This is where we will place our titles
        NSInteger midPoint = (topGuideline + (ABS(topGuideline - bottomGuideline) * 0.5));
        self.titlesView.center = CGPointMake(self.titlesView.center.x, midPoint);
        
    }
}

%end





%ctor
{
}




