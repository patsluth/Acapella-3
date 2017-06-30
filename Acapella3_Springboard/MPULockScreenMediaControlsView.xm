//
//  MPULockScreenMediaControlsView.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPULockScreenMediaControlsView.h"

#import "SWAcapella.h"





@interface MPULockScreenMediaControlsView (APACE)

- (void)apace;

@end





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
	
	if ([self respondsToSelector:@selector(apace)]) {
		return;
	}
    
    SWAcapella *acapella = [SWAcapella acapellaForObject:self];
    
    if (!acapella) {
        return;
    }
        
    CGFloat topGuideline = 0.0;
    
    if (!self.timeView.hidden && self.timeView.layer.opacity > 0.0) {
        topGuideline += CGRectGetMaxY(self.timeView.frame);
    }
    
    CGFloat bottomGuideline = CGRectGetMaxY(self.bounds);
    
    if (!self.transportControls.hidden && self.transportControls.layer.opacity > 0.0) {
        bottomGuideline = CGRectGetMinY(self.transportControls.frame);
    } else if (!self.volumeView.hidden && self.volumeView.layer.opacity > 0.0) {
        bottomGuideline = CGRectGetMinY(self.volumeView.frame);
    }
    
    CGFloat midPoint = (topGuideline + (ABS(topGuideline - bottomGuideline) * 0.5));
    self.titlesView.center = CGPointMake(self.titlesView.center.x, midPoint);
}

%end





%ctor
{
}




