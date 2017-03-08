//
//  MPULockScreenMediaControlsViewController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPULockScreenMediaControlsViewController.h"
#import "MPULockScreenMediaControlsView.h"
//#import "MPUTransportControlsView+SW.h"
//#import "MPUMediaControlsTitlesView+SW.h"
//#import "FuseUI/MPUSystemMediaControlsView.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"
//#import "SWAcapellaMediaItemPreviewViewController.h"

#import "libsw/libSluthware/libSluthware.h"
#import "libsw/SWAppLauncher.h"

//#import "MPUTransportControlMediaRemoteController.h"

#import "SBMediaController.h"



#define TRY @try {
#define CATCH } @catch (NSException *exception) {
#define CATCH_LOG } @catch (NSException *exception) { NSLog(@"%@", exception);
#define FINALLY } @finally {
#define ENDTRY }





//#define MPU_SYSTEM_MEDIA_CONTROLS_VIEW MSHookIvar<MPUSystemMediaControlsView *>(self, "_mediaControlsView")
#define MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER(owner) MSHookIvar<MPUTransportControlMediaRemoteController \
                                                            *>(owner, "_transportControlMediaRemoteController")


@interface UIView(SW)

- (UIView *)sb_generateSnapshotViewAsynchronouslyOnQueue:(id)queue completionHandler:(id)completionHandler;

@end



#pragma mark - MPUSystemMediaControlsViewController

//%hook MPUControlCenterMediaControlsViewController
%hook MPULockScreenMediaControlsViewController

%new
- (MPULockScreenMediaControlsView *)mediaControlsView
{
    return (MPULockScreenMediaControlsView *)self.view;
}

#pragma mark - Init

//- (void)testNOtif:(NSNotification)notification
//{
//    NSLog(@"PAT NOTE %@", notification);
//}

- (void)viewWillAppear:(BOOL)animated
{
    %orig(animated);
    
    
//    self.mediaControlsView.transportControls.hidden = YES;
//    self.mediaControlsView.transportControls.layer.opacity = 0.0;
    
	
	
	// Initialize prefs for this instance
    if (self.acapellaKeyPrefix) {
		self.acapellaPrefs = [[SWAcapellaPrefs alloc] initWithKeyPrefix:self.acapellaKeyPrefix];
    }
    
	
	
    //Reload our transport buttons
    //See [self transportControlsView:arg1 buttonForControlType:arg2];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:6];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:1];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:2];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:3];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:4];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:5];
//    [[self mediaControlsView].transportControlsView reloadTransportButtonWithControlType:8];
    
    [self.view layoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    %orig(animated);
    
    
    
    
    
    
    
    
    // special case where the pref key prefix is not ready in viewWillAppear, but it will always be ready here
//    if (!self.acapellaPrefs) {
//        [self viewWillAppear:NO];
//    }
    
    if (!self.acapella && self.acapellaPrefs.enabled) {
        
        [SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                    referenceView:self.mediaControlsView
                                                     viewsToClone:@[self.mediaControlsView.titlesView]]
                      forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    
    BOOL hasAcapella = (self.acapella || (self.acapellaPrefs && self.acapellaPrefs.enabled));
    
    self.mediaControlsView.transportControls.hidden = hasAcapella;
    self.mediaControlsView.transportControls.layer.opacity = (hasAcapella) ? 0.0 : 1.0;
    
    [self.view layoutSubviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[SWAcapella removeAcapella:[SWAcapella acapellaForObject:self]];
    self.acapellaPrefs = nil;
    
    %orig(animated);
}

- (void)viewDidLayoutSubviews
{
    BOOL hasAcapella = (self.acapella || (self.acapellaPrefs && self.acapellaPrefs.enabled));
    
    self.mediaControlsView.transportControls.hidden = hasAcapella;
    self.mediaControlsView.transportControls.layer.opacity = (hasAcapella) ? 0.0 : 1.0;
    
    %orig();
}

#pragma mark - SWAcapellaDelegate

%new
- (SWAcapella *)acapella
{
    return [SWAcapella acapellaForObject:self];
}

%new
- (NSString *)acapellaKeyPrefix
{
    return @"ls";
}

%new
- (SWAcapellaPrefs *)acapellaPrefs
{
    return objc_getAssociatedObject(self, @selector(_acapellaPrefs));
}

%new
- (void)setAcapellaPrefs:(SWAcapellaPrefs *)acapellaPrefs
{
    objc_setAssociatedObject(self, @selector(_acapellaPrefs),
                             acapellaPrefs,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    // Keep a weak reference so our titles view can access our prefs
    //    objc_setAssociatedObject(((MPUControlCenterMediaControlsView *)self.view).titleLabel,
    //                             @selector(_acapellaPrefs),
    //                             acapellaPrefs,
    //                             OBJC_ASSOCIATION_ASSIGN);
}

%new
- (void)acapella_didRecognizeVerticalPanUp:(id)arg1
{
}

- (void)acapella_didRecognizeVerticalPanDown:(id)arg1
{
}

%new
- (void)action_nil:(id)arg1
{
}

%new
- (void)action_heart:(id)arg1
{
    [[%c(SBMediaController) sharedInstance] likeTrack];
}

%new
- (void)action_upnext:(id)arg1
{
}

%new
- (void)action_previoustrack:(id)arg1
{
    //    [[%c(SBMediaController) sharedInstance] changeTrack:-1];
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:1];
    [self.acapella finishWrapAround];
}

%new
- (void)action_nexttrack:(id)arg1
{
    //    [[%c(SBMediaController) sharedInstance] changeTrack:1];
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:4];
    [self.acapella finishWrapAround];
}

%new
- (void)action_intervalrewind:(id)arg1
{
    //    [[%c(SBMediaController) sharedInstance] _sendMediaCommand:2];
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:2];
}

%new
- (void)action_intervalforward:(id)arg1
{
    //    [[%c(SBMediaController) sharedInstance] _sendMediaCommand:5];
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:5];
}

%new
- (void)action_seekrewind:(id)arg1
{
}

%new
- (void)action_seekforward:(id)arg1
{
}

%new
- (void)action_playpause:(id)arg1
{
    //    [[%c(SBMediaController) sharedInstance] togglePlayPause];
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:3];
}

%new
- (void)action_share:(id)arg1
{
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:8];
}

%new
- (void)action_toggleshuffle:(id)arg1
{
    [[%c(SBMediaController) sharedInstance] toggleShuffle];
}

%new
- (void)action_togglerepeat:(id)arg1
{
    [[%c(SBMediaController) sharedInstance] toggleRepeat];
}

%new
- (void)action_contextual:(id)arg1
{
}

%new
- (void)action_openapp:(id)arg1
{
    //    id x = [self valueForKey:@"_nowPlayingController"]; //MPUNowPlayingController
    //    id y = [x valueForKey:@"_currentNowPlayingAppDisplayID"]; //NSString
    //    [%c(SWAppLauncher) launchAppWithBundleIDLockscreenFriendly:y];
}

%new
- (void)action_showratings:(id)arg1
{
}

%new
- (void)action_decreasevolume:(id)arg1
{
    [[%c(SBMediaController) sharedInstance] _changeVolumeBy:-0.1];
}

%new
- (void)action_increasevolume:(id)arg1
{
    [[%c(SBMediaController) sharedInstance] _changeVolumeBy:0.1];
}

%new
- (void)action_equalizereverywhere:(id)arg1
{
}

%end







#pragma mark - MPUSystemMediaControlsViewController

//- (id)transportControlsView:(id)arg1 buttonForControlType:(NSInteger)arg2
//{
//    //THESE CODES ARE DIFFERENT FROM THE MEDIA COMMANDS
//    //6 like/ban
//    //1 rewind
//    //2 interval rewind
//    //3 play/pause
//    //4 forward
//    //5 interval forward
//    //8 share
//    
//    return nil;
//	
//	// Sometimes this won't be ready until the view has appeared, so return nil so the buttons don't flash
//	// once if acapella is enabled
//	if (!self.acapellaPrefs) {
//		return nil;
//	}
//    
//    if (self.acapellaPrefs.enabled) {
//    
//        if (arg2 == 6 && !self.acapellaPrefs.transport_heart) {
//            return nil;
//        }
//        
//        if (arg2 == 1 && !self.acapellaPrefs.transport_previoustrack) {
//            return nil;
//        }
//        
//        if (arg2 == 2 && !self.acapellaPrefs.transport_intervalrewind) {
//            return nil;
//        }
//        
//        if (arg2 == 3 && !self.acapellaPrefs.transport_playpause) {
//            return nil;
//        }
//        
//        if (arg2 == 4 && !self.acapellaPrefs.transport_nexttrack) {
//            return nil;
//        }
//        
//        if (arg2 == 5 && !self.acapellaPrefs.transport_intervalforward) {
//            return nil;
//        }
//        
//        if (arg2 == 8 && !self.acapellaPrefs.transport_share) {
//            return nil;
//        }
//        
//    }
//    
//    
//    return %orig(arg1, arg2);
//}

//%end

%ctor
{
}




