//
//  MusicNowPlayingViewController.xm
//  Acapella2
//
//  Created by Pat Sluth on 2015-12-27.
//
//







#define TRY @try {
#define CATCH } @catch (NSException *exception) {
#define CATCH_LOG } @catch (NSException *exception) { NSLog(@"%@", exception);
#define FINALLY } @finally {
#define ENDTRY }







#import "MusicNowPlayingViewController+SW.h"
#import "MPUTransportControlsView+SW.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"
//#import "SWAcapellaMediaItemPreviewViewController.h"

#import "libsw/libSluthware/libSluthware.h"

#import "MPUTransportControlMediaRemoteController.h"

#import <objc/runtime.h>

#define MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER MSHookIvar<MPUTransportControlMediaRemoteController \
                                                            *>(self, "_transportControlMediaRemoteController")





#pragma mark - MusicNowPlayingViewController

@interface _TtC5Music24NowPlayingViewController : MusicNowPlayingViewController

@end

@interface MusicNowPlayingControlsViewController : MusicNowPlayingViewController

@property (strong, nonatomic) UIView *timeControl;
@property (strong, nonatomic) UIView *titlesStackView;
@property (strong, nonatomic) UIView *transportControlsStackView;
@property (strong, nonatomic) UIView *volumeSlider;




- (void)printStuff:(id)obj;

@end

%hook MusicNowPlayingControlsViewController

#pragma mark - Init

%new
- (void)printStuff:(id)obj
{
//    unsigned int varCount;
//    
//    Ivar *vars = class_copyIvarList([obj class], &varCount);
//    
//    NSLog(@"\n\n\n");
//    NSLog(@"%@", NSStringFromClass([obj class]));
//    
//    for (int i = 0; i < varCount; i++) {
//        Ivar var = vars[i];
//        
//        const char* name = ivar_getName(var);
//        const char* typeEncoding = ivar_getTypeEncoding(var);
//        
//        NSLog(@"\t\t%s %s", ivar_getName(var), ivar_getTypeEncoding(var));
//    }
//    
//    NSLog(@"\n\n\n");
//    
//    free(vars);
}

- (void)viewWillAppear:(BOOL)animated
{
	%orig(animated);
    
    
    
    
    
    
    
    
    
   
    
    
    
    
    
    
    
    
    
//    [self printStuff:self.timeControl];
//    [self printStuff:self.titlesStackView];
//    [self printStuff:self.transportControlsStackView];
//    [self printStuff:self.volumeSlider];
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // Initialize prefs for this instance
    if (self.acapellaKeyPrefix) {
        self.acapellaPrefs = [[SWAcapellaPrefs alloc] initWithKeyPrefix:self.acapellaKeyPrefix];
    }
    
    
    // Reload our transport buttons
    // See [self transportControlsView:arg1 buttonForControlType:arg2];
    
    TRY
        
    // TOP ROW
//    [self.transportControls reloadTransportButtonWithControlType:6];
//    [self.transportControls reloadTransportButtonWithControlType:1];
//    [self.transportControls reloadTransportButtonWithControlType:2];
//    [self.transportControls reloadTransportButtonWithControlType:3];
//    [self.transportControls reloadTransportButtonWithControlType:4];
//    [self.transportControls reloadTransportButtonWithControlType:5];
//    [self.transportControls reloadTransportButtonWithControlType:7];
//    
//    // BOTTOM ROW
//    [self.secondaryTransportControls reloadTransportButtonWithControlType:8];
//    [self.secondaryTransportControls reloadTransportButtonWithControlType:10];
//    [self.secondaryTransportControls reloadTransportButtonWithControlType:9];
//    [self.secondaryTransportControls reloadTransportButtonWithControlType:11];
//    
//    // PODCAST TOP ROW
//    [self.transportControls reloadTransportButtonWithControlType:12];
//    // PODCAST BOTTOM ROW
//    [self.secondaryTransportControls reloadTransportButtonWithControlType:13];
    
    CATCH_LOG
    ENDTRY
    
    [self viewDidLayoutSubviews];
}

%new
- (id)transportControls
{
    return nil;
}

%new
- (id)secondaryTransportControls
{
    return self.transportControlsStackView;
}

%new
- (id)dismissButton
{
    return nil;
}

%new
- (id)playbackProgressSliderView
{
    return nil;
}

%new
- (id)vibrantEffectView
{
    return nil;
}

%new
- (id)titlesView
{
    return self.titlesStackView;
}

- (void)viewDidAppear:(BOOL)animated
{
    %orig(animated);
    
    
    // Special case where the pref key prefix is not ready in viewWillAppear, but it will always be ready here
    if (!self.acapellaPrefs) {
        [self viewWillAppear:NO];
    }
    
    
    if (!self.acapella) {
        
        if (self.acapellaPrefs.enabled) {
            
			[SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                        referenceView:self.titlesStackView
                                                         viewsToClone:self.titlesStackView.subviews]
                          forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
            
        }
        
    }
	
	[self viewDidLayoutSubviews];
	
}

- (void)viewDidDisappear:(BOOL)animated
{
	%orig(animated);
	
    [SWAcapella removeAcapella:[SWAcapella acapellaForObject:self]];
    self.acapellaPrefs = nil;
}

- (void)viewDidLayoutSubviews
{
	%orig();
    
   
    
    
//    
//    BOOL progressVisible = YES;
//    BOOL volumeVisible = YES;
    
//    if (self.acapellaPrefs && self.acapellaPrefs.enabled) {
//        progressVisible = self.acapellaPrefs.progressslider;
//		volumeVisible = self.acapellaPrefs.volumeslider;
////		self.dismissButton.hidden = YES;
//	} else {
////		self.dismissButton.hidden = NO;
//	}
		
    // Show/Hide sliders
//    self.timeControl.hidden = YES;//!progressVisible;
//    self.volumeSlider.hidden = YES;//!volumeVisible;
    
    
    
    
    return;
    
    
    
    
    
    
    // Intelligently calcualate centre based on visible controls, which we dont want to do on iPad
    if ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)) { return; }
    
    
    CGFloat topGuideline = CGRectGetMinY(self.titlesStackView.frame);
    
    if (!self.volumeSlider.hidden) { // Visible
        topGuideline += CGRectGetHeight(self.titlesStackView.bounds);
    }
    
    
    CGFloat bottomGuideline = CGRectGetMinY(self.transportControlsStackView.frame); // Top of primary transport controls
    
    
    if (self.transportControlsStackView.hidden) {//[self.transportControlsStackView acapella_hidden]) {
        
        bottomGuideline = CGRectGetMinY(self.volumeSlider.frame); // Top of volume slider
        
        if (self.volumeSlider.hidden) { // Hidden
            
//            bottomGuideline = CGRectGetMinY(self.secondaryTransportControls.frame); // Top of transport secondary controls
            
//            if ([self.secondaryTransportControls acapella_hidden]) {
                bottomGuideline = CGRectGetMaxY(self.titlesView.superview.bounds); // Bottom of screen
//            }
            
        }
        
    }
	
	
	// The midpoint between the currently visible views. This is where we will place our titles
	NSInteger midPoint = (topGuideline + (ABS(topGuideline - bottomGuideline) / 2.0));
	self.titlesView.center = CGPointMake(self.titlesView.center.x, midPoint);
	
}

#pragma mark - Acapella(Helper)

%new
- (NSString *)acapellaKeyPrefix
{
	@autoreleasepool {
//
//		UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
//		
//		if (%c(MusicTabBarController) && [rootVC class] == %c(MusicTabBarController)) { // Music App
			return @"musicnowplaying";
//		} else if (%c(MTMusicTabController) && [rootVC class] == %c(MTMusicTabController)) { // Podcast App
//			return @"podcastsnowplaying";
//		}
//		
	}

    return nil;
}

%new
- (SWAcapella *)acapella
{
    return [SWAcapella acapellaForObject:self];
}



%new
- (BOOL)lyricsViewVisible
{
//	NSString *classString = NSStringFromClass([self.presentedDetailViewController class]);
//	if ([classString isEqualToString:@"MusicNowPlayingLyricsViewController"]) {
//		return YES;
//	}
	
	return NO;
}

#pragma mark - MusicNowPlayingViewController

- (id)transportControlsView:(id)arg1 buttonForControlType:(NSInteger)arg2
{
    // TRANSPORT CONTROL TYPES
    // THESE CODES ARE DIFFERENT FROM THE MEDIA COMMANDS
    
    // TOP ROW
    // 6 like/ban
    // 1 rewind
    // 2 interval rewind
    // 3 play/pause
    // 4 forward
    // 5 interval forward
    // 7 present up next
    
    // BOTTOM ROW
    // 8 share
    // 10 shuffle
    // 9 repeat
    // 11 contextual
    
    // PODCAST TOP ROW
    // 12 playback rate (1x, 2x etc. )
    // PODCAST BOTTOM ROW
    // 13 sleep timer
	
	
	// Sometimes this won't be ready until the view has appeared, so return nil so the buttons don't flash
	// once if acapella is enabled
	if (!self.acapellaPrefs) {
		return nil;
	}
	
    
    if (self.acapellaPrefs.enabled) {
        
        // TOP ROW
        if (arg2 == 6 && !self.acapellaPrefs.transport_heart) {
            return nil;
        }
        
        if (arg2 == 1 && !self.acapellaPrefs.transport_previoustrack) {
            return nil;
        }
        
        if (arg2 == 2 && !self.acapellaPrefs.transport_intervalrewind) {
            return nil;
        }
        
        if (arg2 == 3 && !self.acapellaPrefs.transport_playpause) {
            return nil;
        }
        
        if (arg2 == 4 && !self.acapellaPrefs.transport_nexttrack) {
            return nil;
        }
        
        if (arg2 == 5 && !self.acapellaPrefs.transport_intervalforward) {
            return nil;
        }
        
        if (arg2 == 7 && !self.acapellaPrefs.transport_upnext) {
            return nil;
        }
        
        // BOTTOM ROW
        if (arg2 == 8 && !self.acapellaPrefs.transport_share) {
            return nil;
        }
        
        if (arg2 == 10 && !self.acapellaPrefs.transport_shuffle) {
            return nil;
        }
        
        if (arg2 == 9 && !self.acapellaPrefs.transport_repeat) {
            return nil;
        }
        
        if (arg2 == 11 && !self.acapellaPrefs.transport_contextual) {
            return nil;
        }
        
        // PODCAST TOP ROW
        if (arg2 == 12 && !self.acapellaPrefs.transport_playbackrate) {
            return nil;
        }

        // PODCAST BOTTOM ROW
        if (arg2 == 13 && !self.acapellaPrefs.transport_sleeptimer) {
            return nil;
        }
        
    }
    
    
    return %orig(arg1, arg2);
}

//- (void)_handleTapGestureRecognizerAction:(UITapGestureRecognizer *)arg1 //tap on artwork
//{
//	if (self.acapella) {
//		
//		// touch is on the artwork view
//		if (![[arg1.view hitTest:[arg1 locationInView:arg1.view] withEvent:nil]
//			  isDescendantOfView:self.currentItemViewControllerContainerView]) {
//			return;
//		}
//	}
//	
//	%orig(arg1);
//}

/**
 *  Called when dismissing the UpNext view controller
 *
 *  @param arg1
 */
- (void)dismissDetailViewController:(id)arg1
{
	%orig(arg1);
	
	@try {
		[self _setRatingsVisible:NO];
	} @catch (NSException *exception) {
		NSLog(@"%@", exception);
	} @finally {
		[self.acapella setTitlesCloneVisible:YES];
	}
}

- (void)_showUpNext
{
	[self.acapella setTitlesCloneVisible:NO];
	
    %orig();
}

- (void)_showUpNext:(id)arg1
{
	[self.acapella setTitlesCloneVisible:NO];
	
	%orig(arg1);
}

- (void)_setRatingsVisible:(BOOL)arg1		// No longer available on iOS 9.3.3
{
	%orig(arg1);
	
	// Hide Acapella if Ratings are visible
	[self.acapella setTitlesCloneVisible:!arg1];
}

#pragma mark - Acaplla(Actions)

%new
- (void)action_nil:(id)arg1
{
}

%new
- (void)action_heart:(id)arg1
{
    TRY
    [self transportControlsView:self.transportControls tapOnControlType:6];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_upnext:(id)arg1
{
    TRY
    
    [self transportControlsView:self.transportControls tapOnControlType:7];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_previoustrack:(id)arg1
{
    TRY
    
    [self transportControlsView:self.transportControls tapOnControlType:1];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_nexttrack:(id)arg1
{
    TRY
    
//    for (UIView *subview in self.titlesStackView.subviews) {
//        UIView *snapshotView = [subview snapshotViewAfterScreenUpdates:YES];
//        [self.titlesStackView.superview addSubview:snapshotView];
//    }
    
//    [self transportControlsView:self.transportControls tapOnControlType:4];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_intervalrewind:(id)arg1
{
    TRY
    
    [self transportControlsView:self.transportControls tapOnControlType:2];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_intervalforward:(id)arg1
{
    TRY
    
    [self transportControlsView:self.transportControls tapOnControlType:5];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_seekrewind:(id)arg1
{
    TRY
    
    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
    
    [self transportControlsView:self.transportControls longPressBeginOnControlType:1];
    
    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
    
    if (originalLPCommand == newLPCommand) { //if the commands havent changed we are seeking, so we should stop seeking
        [self transportControlsView:self.transportControls longPressEndOnControlType:1];
    }
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_seekforward:(id)arg1
{
    TRY
    
    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
    
    [self transportControlsView:self.transportControls longPressBeginOnControlType:4];
    
    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
    
    if (originalLPCommand == newLPCommand) { //if the commands havent changed we are seeking, so we should stop seeking
        [self transportControlsView:self.transportControls longPressEndOnControlType:4];
    }
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_playpause:(id)arg1
{
    TRY
    
//    unsigned int originalLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    [self transportControlsView:self.transportControls longPressEndOnControlType:1];
//    [self transportControlsView:self.transportControls longPressEndOnControlType:4];
//    
//    unsigned int newLPCommand = MSHookIvar<unsigned int>(MPU_TRANSPORT_MEDIA_REMOTE_CONTROLLER, "_runningLongPressCommand");
//    
//    //if the 2 commands are different, then something happened when we told the transportControlView to
//    //stop seeking, meaning we were seeking
//    if (originalLPCommand == newLPCommand) {
        [self transportControlsView:self.transportControls tapOnControlType:3];
    //}
    
    [self.acapella pulse];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_share:(id)arg1
{
    TRY
    
    [self transportControlsView:self.secondaryTransportControls tapOnControlType:8];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_toggleshuffle:(id)arg1
{
    TRY
    
    [self transportControlsView:self.secondaryTransportControls tapOnControlType:10];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_togglerepeat:(id)arg1
{
    TRY
    
    [self transportControlsView:self.secondaryTransportControls tapOnControlType:9];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_contextual:(id)arg1
{
    TRY
    
    [self transportControlsView:self.secondaryTransportControls tapOnControlType:11];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_openapp:(id)arg1
{
}

%new
- (void)action_showratings:(id)arg1
{
    TRY
    
    // iOS <= 9.0.2
    [self _setRatingsVisible:self.ratingControl.hidden];
    
    CATCH_LOG
    
    TRY
    
    // iOS 9.0.3 shows the ratings view in the lyrics view now
    // Hide the lyrics view if it is visible
    [self _setLyricsVisible:![self lyricsViewVisible]];
    
    CATCH_LOG
    ENDTRY
    
    ENDTRY
}

%new
- (void)action_decreasevolume:(id)arg1
{
    TRY
    
    id vc = [self.volumeSlider valueForKey:@"volumeController"];
    [vc performSelector:@selector(incrementVolumeInDirection:) withObject:@(-1) afterDelay:0.0];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_increasevolume:(id)arg1
{
    TRY
    
    id vc = [self.volumeSlider valueForKey:@"volumeController"];
    [vc performSelector:@selector(incrementVolumeInDirection:) withObject:@(1) afterDelay:0.0];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_equalizereverywhere:(id)arg1
{
}

#pragma mark - UIViewControllerPreviewing

//%new // peek
//- (UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
//{
//    if (!self.acapella || self.presentedViewController) {
//        return nil;
//    }
//    
//    // Show the entire media control area as the source rect, not just the titles view
//    CGRect sourceRect = self.playbackProgressSliderView.frame;
//    sourceRect.size.height = CGRectGetHeight(self.view.bounds) - sourceRect.origin.y;
//    previewingContext.sourceRect = sourceRect;
//    
//    if (CGRectContainsPoint(sourceRect, location)) { // Don't allow previewing if outside the media control area
//        
//        SWAcapellaMediaItemPreviewViewController *previewViewController = [[SWAcapellaMediaItemPreviewViewController alloc] initWithDelegate:self];
//        [previewViewController configureWithCurrentNowPlayingInfo];
//        
//        
//        CGFloat xPercentage = location.x / CGRectGetWidth(self.view.bounds);
//        
//        if (xPercentage <= 0.25) { // left
//            
//            previewViewController.popAction = self.acapellaPrefs.gestures_popactionleft;
//            previewViewController.acapellaPreviewActionItems = @[[previewViewController intervalRewindAction],
//                                                                 [previewViewController seekRewindAction]];
//            
//        } else if (xPercentage > 0.75) { // right
//            
//            previewViewController.popAction = self.acapellaPrefs.gestures_popactionright;
//            previewViewController.acapellaPreviewActionItems = @[[previewViewController intervalForwardAction],
//                                                                 [previewViewController seekForwardAction]];
//            
//        } else { // centre
//            
//            previewViewController.popAction = self.acapellaPrefs.gestures_popactioncentre;
//            previewViewController.acapellaPreviewActionItems = @[[previewViewController heartAction],
//                                                                 [previewViewController upNextAction],
//                                                                 [previewViewController shareAction],
//                                                                 [previewViewController contextualAction],
//                                                                 [previewViewController showRatingsAction]];
//            
//        }
//        
//        
//        return previewViewController;
//        
//    }
//    
//    
//    return nil;
//}
//
//%new // pop
//- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext
//commitViewController:(SWAcapellaMediaItemPreviewViewController *)viewControllerToCommit
//{
//    dispatch_async(dispatch_get_main_queue(), ^(void) {
//        
//        SEL sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", viewControllerToCommit.popAction]);
//        
//        if (sel && [self respondsToSelector:sel]) {
//            [self performSelectorOnMainThread:sel withObject:nil waitUntilDone:NO];
//        }
//        
//    });
//}

#pragma mark - Associated Objects

%new
- (SWAcapellaPrefs *)acapellaPrefs
{
    return objc_getAssociatedObject(self, @selector(_acapellaPrefs));
}

%new
- (void)setAcapellaPrefs:(SWAcapellaPrefs *)acapellaPrefs
{
    objc_setAssociatedObject(self, @selector(_acapellaPrefs), acapellaPrefs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

%end




