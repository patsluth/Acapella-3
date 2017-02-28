//
//  MPUControlCenterMediaControlsView.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPUControlCenterMediaControlsView.h"

#import "libsw/libSluthware/libSluthware.h"
#import "libsw/SWAppLauncher.h"


#define TRY @try {
#define CATCH } @catch (NSException *exception) {
#define CATCH_LOG } @catch (NSException *exception) { NSLog(@"%@", exception);
#define FINALLY } @finally {
#define ENDTRY }


#pragma mark - MPUControlCenterMediaControlsView

%hook MPUControlCenterMediaControlsView

%new
- (UIView /* MPUNowPlayingArtworkView */ *)artworkView
{
    return MSHookIvar<UIView *>(self, "_artworkView");
}

%new
- (UIView *)titleLabel
{
    return MSHookIvar<UIView *>(self, "_titleLabel");
}

%new
- (UIView *)artistLabel
{
    return MSHookIvar<UIView *>(self, "_artistLabel");
}

%new
- (UIView *)albumLabel
{
    return MSHookIvar<UIView *>(self, "_albumLabel");
}

%new
- (UIView *)artistAlbumConcatenatedLabel
{
    return MSHookIvar<UIView *>(self, "_artistAlbumConcatenatedLabel");
}

%end





%ctor
{
}




