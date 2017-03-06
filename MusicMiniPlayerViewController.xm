//
//  MusicMiniPlayerViewController.xm
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


#import "MusicMiniPlayerViewController+SW.h"
#import "_TtC5Music19ApplicationDelegate+SW.h"
#import "MediaPlayer+SW.h"
#import "MPUTransportControlsView+SW.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"
//#import "SWAcapellaMediaItemPreviewViewController.h"

#import "libsw/libSluthware/libSluthware.h"

#import "MPUTransportControlMediaRemoteController.h"
#import "MusicTabBarController.h"





#pragma mark - MusicMiniPlayerViewController

@interface _TtC5Music24MiniPlayerViewController : MusicMiniPlayerViewController

@property (strong, nonatomic) UIView *artworkView;
@property (strong, nonatomic) UIView *nowPlayingItemTitleLabel;
@property (strong, nonatomic) UIView *transportControlsStack;

@property (strong, nonatomic) UIButton *miniPlayerButton;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;

@end





%hook _TtC5Music24MiniPlayerViewController

#pragma mark - Init

- (void)viewWillAppear:(BOOL)animated
{
    
    
    
    
    
    
    
    
    
    
    
    %orig(animated);
    
    
    // Initialize prefs for this instance
    if (self.acapellaKeyPrefix) {
        self.acapellaPrefs = [[SWAcapellaPrefs alloc] initWithKeyPrefix:self.acapellaKeyPrefix];
    }
    
    
    
    
    TRY
    
    
    //Reload our transport buttons
    //See [self transportControlsView:arg1 buttonForControlType:arg2];
    
    //LEFT SECTION
//    [self.transportControlsView reloadTransportButtonWithControlType:1];
//    [self.transportControlsView reloadTransportButtonWithControlType:3];
//    [self.transportControlsView reloadTransportButtonWithControlType:4];
//    
//    //RIGHT SECTION
//    [self.secondaryTransportControlsView reloadTransportButtonWithControlType:7];
//    [self.secondaryTransportControlsView reloadTransportButtonWithControlType:11];
    
    CATCH_LOG
    ENDTRY
    
    [self viewDidLayoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    %orig(animated);
    
    
    // special case where the pref key prefix is not ready in viewWillAppear, but it will always be ready here
    if (!self.acapellaPrefs) {
        [self viewWillAppear:NO];
    }
    
    
    
//    [self.miniPlayerButton removeFromSuperview];
//
    
    
    
    
    
    if (!self.acapella && self.acapellaPrefs.enabled) {
        
        [SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                    referenceView:self.view
                                                     viewsToClone:@[self.nowPlayingItemTitleLabel]]
                      forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    
    self.miniPlayerButton.enabled = (!self.acapella);
    
    if (self.acapella) {
        
//        [self.panGestureRecognizer requireGestureRecognizerToFail:self.acapella.pan];
        
    }
    
    [self viewDidLayoutSubviews];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [SWAcapella removeAcapella:[SWAcapella acapellaForObject:self]];
    self.acapellaPrefs = nil;
    
    %orig(animated);
}

- (void)viewDidLayoutSubviews
{
	%orig();
    
//    if (self.acapella) {
//        
//        [self.acapella.cloneContainer setNeedsDisplay];
//        
//    }
    
    
    
    
    
    
    
    
    
    TRY
    
    
    
    
    
    
//    self.artworkView.hidden = YES;
//    self.nowPlayingItemTitleLabel.backgroundColor = [UIColor redColor];
//    self.transportControlsStack.backgroundColor = [UIColor yellowColor];
    
    
	
	
//	// Show/Hide progress slider
//	if (self.acapellaPrefs && self.acapellaPrefs.enabled && !self.acapellaPrefs.progressslider) {
//		self.playbackProgressView.layer.opacity = 0.0;
//	} else {
//		self.playbackProgressView.layer.opacity = 1.0;
//	}
//	
//	
//	// Update titles constraints
//    CGRect titlesFrame = self.titlesView.frame;
//    
//    //intelligently calcualate titles frame based on visible transport controls
//    if ([self.transportControlsView acapella_hidden]) {
//        titlesFrame.origin.x = 0.0;
//        titlesFrame.size.width = self.secondaryTransportControlsView.frame.origin.x;
//    }
//    
//    if ([self.secondaryTransportControlsView acapella_hidden]) {
//        titlesFrame.size.width = CGRectGetWidth(self.titlesView.superview.bounds) - titlesFrame.origin.x;
//    }
//	
//    self.titlesView.frame = titlesFrame;
    
    CATCH_LOG
    ENDTRY
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
    return @"musicmini";
}

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

%new
- (void)acapella_didRecognizeVerticalPanUp:(id)arg1
{
    TRY
    
    [self.miniPlayerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    CATCH_LOG
    ENDTRY
}

- (void)acapella_didRecognizeVerticalPanDown:(id)arg1
{
}

%new
- (void)action_nil:(id)arg1
{
    TRY
    
    //if tap and action is set to nil, perform the original tap action
    [self.miniPlayerButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_heart:(id)arg1
{
}

%new
- (void)action_upnext:(id)arg1
{
    TRY
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self transportControlsView:self.secondaryTransportControlsView tapOnControlType:7];
        
    } else {
        
        UIViewController<SWAcapellaDelegate> *nowPlayingViewController;
        nowPlayingViewController = [(MusicTabBarController *)self.parentViewController nowPlayingViewController];
        
        [self.parentViewController presentViewController:nowPlayingViewController
                                                animated:YES
                                              completion:^() {
                                                  
                                                  [nowPlayingViewController action_upnext:nil];
                                                  
                                              }];
        
    }
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_previoustrack:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.previousTrackCommand newCommandEvent];
    [delegate.player performCommandEvent:commandEvent completion:^{
        [self.acapella.cloneContainer refreshClones];
        [self.acapella finishWrapAround];
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_nexttrack:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.nextTrackCommand newCommandEvent];
    [delegate.player performCommandEvent:commandEvent completion:^{
        [self.acapella.cloneContainer refreshClones];
        [self.acapella finishWrapAround];
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_intervalrewind:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.skipBackwardCommand newCommandEventWithInterval:20.0];
    [delegate.player performCommandEvent:commandEvent completion:^{
        
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_intervalforward:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.skipForwardCommand newCommandEventWithInterval:20.0];
    [delegate.player performCommandEvent:commandEvent completion:^{
        
    }];
    
    CATCH_LOG
    ENDTRY
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
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.togglePlayPauseCommand newCommandEvent];
    [delegate.player performCommandEvent:commandEvent completion:^{
        
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_share:(id)arg1
{
}

%new
- (void)action_toggleshuffle:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.advanceShuffleModeCommand newCommandEventWithPreservesShuffleMode:NO];
    [delegate.player performCommandEvent:commandEvent completion:^{
        
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_togglerepeat:(id)arg1
{
    TRY
    
    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
    MPRemoteCommandEvent *commandEvent = [commandCenter.advanceRepeatModeCommand newCommandEventWithPreservesRepeatMode:NO];
    [delegate.player performCommandEvent:commandEvent completion:^{
        
    }];
    
    CATCH_LOG
    ENDTRY
}

%new
- (void)action_contextual:(id)arg1
{
    TRY
    
    [self transportControlsView:self.secondaryTransportControlsView tapOnControlType:11];
    
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
}

%new
- (void)action_decreasevolume:(id)arg1
{
    @autoreleasepool {
        
        TRY
        
        MPVolumeController *volumeController = [%c(MPVolumeController) new];
        [volumeController setVolumeValue:volumeController.volumeValue - 0.1];
        volumeController = nil;
        
        CATCH_LOG
        ENDTRY
        
    }
}

%new
- (void)action_increasevolume:(id)arg1
{
    @autoreleasepool {
        
        TRY
        
        MPVolumeController *volumeController = [%c(MPVolumeController) new];
        [volumeController setVolumeValue:volumeController.volumeValue + 0.1];
        volumeController = nil;
        
        CATCH_LOG
        ENDTRY
        
    }
}

%new
- (void)action_equalizereverywhere:(id)arg1
{
}






#pragma mark - MusicMiniPlayerViewController

//- (id)transportControlsView:(id)arg1 buttonForControlType:(NSInteger)arg2
//{
//    //THESE CODES ARE DIFFERENT FROM THE MEDIA COMMANDS
//    
//    //LEFT SECTION
//    //1 rewind (IPAD)
//    //3 play/pause
//    //4 forward (IPAD)
//    
//    //RIGHT SECTION
//    //7 present up next (IPAD)
//    //11 contextual
//	
//	
//	// Sometimes this won't be ready until the view has appeared, so return nil so the buttons don't flash
//	// once if acapella is enabled
//	if (!self.acapellaPrefs) {
//		return nil;
//	}
//	
//	
//    if (self.acapellaPrefs.enabled) {
//        
//        //LEFT SECTION
//        if (arg2 == 1 && !self.acapellaPrefs.transport_previoustrack) {
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
//        //RIGHT SECTION
//        if (arg2 == 7 && !self.acapellaPrefs.transport_upnext) {
//            return nil;
//        }
//        
//        if (arg2 == 11 && !self.acapellaPrefs.transport_contextual) {
//            return nil;
//        }
//        
//    }
//    
//    
//    return %orig(arg1, arg2);
//}

%end





%ctor
{
}




