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

%end





%ctor
{
}




