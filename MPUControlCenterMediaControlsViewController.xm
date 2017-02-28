//
//  MPUControlCenterMediaControlsViewController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPUControlCenterMediaControlsViewController.h"
#import "MPUControlCenterMediaControlsView.h"
//#import "MPUTransportControlsView+SW.h"
//#import "MPUMediaControlsTitlesView+SW.h"
//#import "FuseUI/MPUSystemMediaControlsView.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"
//#import "SWAcapellaMediaItemPreviewViewController.h"

#import "libsw/libSluthware/libSluthware.h"
#import "libsw/SWAppLauncher.h"

//#import "MPUTransportControlMediaRemoteController.h"



#define TRY @try {
#define CATCH } @catch (NSException *exception) {
#define CATCH_LOG } @catch (NSException *exception) { NSLog(@"%@", exception);
#define FINALLY } @finally {
#define ENDTRY }





//#define MPU_SYSTEM_MEDIA_CONTROLS_VIEW MSHookIvar<MPUSystemMediaControlsView *>(self, "_mediaControlsView")
//#define MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER MSHookIvar<MPUTransportControlMediaRemoteController \
//                                                            *>(self, "_transportControlMediaRemoteController")





#pragma mark - MPUSystemMediaControlsViewController

%hook MPUControlCenterMediaControlsViewController

%new
- (MPUControlCenterMediaControlsView *)mediaControlsView
{
    return (MPUControlCenterMediaControlsView *)self.view;
}

#pragma mark - Init

- (void)viewWillAppear:(BOOL)animated
{
    %orig(animated);
	
	
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
    
    
//    NSLog(@"PAT 832749238645982365 %@", [self mediaControlsView].volumeView);
    NSLog(@"PAT 832749238645982365 %@", [self mediaControlsView].volumeView);
    
    
//    [self mediaControlsView].timeView.backgroundColor = [UIColor whiteColor];
    
    
    
//    UIView *vvv = MSHookIvar<UIView *>(self.mediaControlsView, "_titleLabel");
//    vvv.backgroundColor = [UIColor blueColor];
//    vvv = MSHookIvar<UIView *>(self.mediaControlsView, "_artistLabel");
//    vvv.backgroundColor = [UIColor blueColor];
//    vvv = MSHookIvar<UIView *>(self.mediaControlsView, "_albumLabel");
//    vvv.backgroundColor = [UIColor blueColor];
//    vvv = MSHookIvar<UIView *>(self.mediaControlsView, "_artistAlbumConcatenatedLabel");
//    vvv.backgroundColor = [UIColor blueColor];
    
    
    
    
//    [self mediaControlsView].transportControls.backgroundColor = [UIColor redColor];
//    [self mediaControlsView].volumeView.backgroundColor = [UIColor yellowColor];
    
    
    
    
    
    NSLog(@"PAT LOL");
    
    
    
    
   
    
    
    
    
    
    
    
    
    
    
    
    
    
    // special case where the pref key prefix is not ready in viewWillAppear, but it will always be ready here
    if (!self.acapellaPrefs) {
        [self viewWillAppear:NO];
    }
    
    
    if (!self.acapella) {
		
        //if (self.acapellaPrefs.enabled) {
        
        self.mediaControlsView.artworkView.clipsToBounds = YES;
        
			[SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                        referenceView:self.mediaControlsView
                                                         viewsToClone:@[self.mediaControlsView.artworkView,
                                                                        self.mediaControlsView.titleLabel,
                                                                        self.mediaControlsView.artistLabel,
                                                                        self.mediaControlsView.albumLabel]]
						  forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
            
        //}
        
    }
	
    if (self.acapella) {
        
        // Show/Hide progress slider
//        if (self.acapellaPrefs.enabled && !self.acapellaPrefs.progressslider) {
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.timeInformationView.layer.opacity = 0.0;
//        } else {
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.timeInformationView.layer.opacity = 1.0;
//        }
//        
//        //Show/Hide volume slider
//        if (self.acapellaPrefs.enabled && !self.acapellaPrefs.volumeslider) {
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.volumeView.layer.opacity = 0.0;
//        } else {
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.volumeView.layer.opacity = 1.0;
//        }
        
        
    } else { //restore original state
		
        // Only reset values for default media center instances
//        NSString *acapellaKeyPrefix = [self acapellaKeyPrefix];
//        if ([acapellaKeyPrefix isEqualToString:@"cc"] || [acapellaKeyPrefix isEqualToString:@"ls"]) {
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.timeInformationView.layer.opacity = 1.0;
//            MPU_SYSTEM_MEDIA_CONTROLS_VIEW.volumeView.layer.opacity = 1.0;
//        }
        
    }
    
    [self.view layoutSubviews];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[SWAcapella removeAcapella:[SWAcapella acapellaForObject:self]];
    self.acapellaPrefs = nil;
    
    %orig(animated);
}

//- (void)viewDidLayoutSubviews
//{
//	%orig();
//}

#pragma mark - Acapella(Helper)

%new
- (NSString *)acapellaKeyPrefix
{
    return @"cc";
//    return @"ls";
}

%new
- (SWAcapella *)acapella
{
    return [SWAcapella acapellaForObject:self];
}

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

#pragma mark - Acapella(Actions)

%new
- (void)action_nil:(id)arg1
{
}

%new
- (void)action_heart:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:6];
}

%new
- (void)action_upnext:(id)arg1
{
}

%new
- (void)action_previoustrack:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:1];
//    
//    MPUTransportControlMediaRemoteController *t = MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER;
//    
//    if (![t.nowPlayingInfo valueForKey:@"kMRMediaRemoteNowPlayingInfoTitle"]) { //wrap around instantly if nothing is playing
//        
//        if ([self.acapella respondsToSelector:@selector(finishWrapAround)]) {
//            [self.acapella performSelector:@selector(finishWrapAround) withObject:nil afterDelay:0.0];
//        }
//        
//    }
}

%new
- (void)action_nexttrack:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:4];
//    
//    MPUTransportControlMediaRemoteController *t = MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER;
//    
//    if (![t.nowPlayingInfo valueForKey:@"kMRMediaRemoteNowPlayingInfoTitle"]) { //wrap around instantly if nothing is playing
//        if ([self.acapella respondsToSelector:@selector(finishWrapAround)]) {
//            [self.acapella performSelector:@selector(finishWrapAround) withObject:nil afterDelay:0.0];
//        }
//    }
}

%new
- (void)action_intervalrewind:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:2];
}

%new
- (void)action_intervalforward:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:5];
}

%new
- (void)action_seekrewind:(id)arg1
{
//    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressBeginOnControlType:1];
//    
//    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    if (originalLPCommand == newLPCommand) { //if the commands havent changed we are seeking, so we should stop seeking
//        [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressEndOnControlType:1];
//    }
}

%new
- (void)action_seekforward:(id)arg1
{
//    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressBeginOnControlType:4];
//    
//    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    if (originalLPCommand == newLPCommand) { //if the commands havent changed we are seeking, so we should stop seeking
//        [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressEndOnControlType:4];
//    }
}

%new
- (void)action_playpause:(id)arg1
{
//    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressEndOnControlType:1];
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView longPressEndOnControlType:4];
//    
//    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    //if the 2 commands are different, then something happened when we told the transportControlView to
//    //stop seeking, meaning we were seeking
//    if (originalLPCommand == newLPCommand) {
//        [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:3];
//    }
//    
//    [self.acapella pulse];
}

%new
- (void)action_share:(id)arg1
{
//    [self transportControlsView:MPU_SYSTEM_MEDIA_CONTROLS_VIEW.transportControlsView tapOnControlType:8];
}

%new
- (void)action_toggleshuffle:(id)arg1
{
}

%new
- (void)action_togglerepeat:(id)arg1
{
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
//    id vc = [MPU_SYSTEM_MEDIA_CONTROLS_VIEW.volumeView valueForKey:@"volumeController"];
//    [vc performSelector:@selector(incrementVolumeInDirection:) withObject:@(-1) afterDelay:0.0];
}

%new
- (void)action_increasevolume:(id)arg1
{
//    id vc = [MPU_SYSTEM_MEDIA_CONTROLS_VIEW.volumeView valueForKey:@"volumeController"];
//    [vc performSelector:@selector(incrementVolumeInDirection:) withObject:@(1) afterDelay:0.0];
}

%new
- (void)action_equalizereverywhere:(id)arg1
{
//    UIView *curView = self.acapella.referenceView.superview;
//    
//    while(curView) {
//        
//        if ([curView isKindOfClass:NSClassFromString(@"SBEqualizerScrollView")]) {
//            UIScrollView *ee = (UIScrollView *)curView;
//            [ee setContentOffset:CGPointMake(CGRectGetWidth(ee.frame), 0.0) animated:YES];
//            curView = nil;
//        } else {
//            curView = curView.superview;
//        }
//        
//    }
}

#pragma mark - Associated Objects

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

%end





//#pragma mark - MPUSystemMediaControlsView
//
//%hook MPUSystemMediaControlsView
//
//- (void)layoutSubviews
//{
//    %orig();
//	
//	
//    // Calcualate centre based on visible controls
//    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
//        
//        CGFloat topGuideline = 0;
//        
//        if (self.timeInformationView.layer.opacity > 0.0) { // Visible
//            topGuideline += CGRectGetMaxY(self.timeInformationView.frame);
//        }
//        
//        
//        CGFloat bottomGuideline = CGRectGetMaxY(self.bounds);
//        
//        if (![self.transportControlsView acapella_hidden]) {
//            bottomGuideline = CGRectGetMinY(self.transportControlsView.frame);
//        } else {
//            if (self.volumeView.layer.opacity > 0.0) { // Visible
//                bottomGuideline = CGRectGetMinY(self.volumeView.frame);
//            }
//        }
//        
//        
//        // The midpoint between the currently visible views. This is where we will place our titles
//        NSInteger midPoint = (topGuideline + (ABS(topGuideline - bottomGuideline) * 0.5));
//		self.trackInformationView.center = CGPointMake(self.trackInformationView.center.x, midPoint);
//		
//    }
//}
//
//%end





%ctor
{
}




