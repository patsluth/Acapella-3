//
//  MusicNowPlayingControlsViewController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-12-27.
//
//

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"

#import "Sluthware/Sluthware.h"

#import "_TtC5Music19ApplicationDelegate+SW.h"
#import "MediaPlayer+SW.h"
#import "MusicTabBarController.h"

#import <objc/runtime.h>

#import "MediaRemote/MediaRemote.h"
#import "AVSystemController+SW.h"





#pragma mark - MusicNowPlayingControlsViewController

@interface MusicNowPlayingControlsViewController : UIViewController <SWAcapellaDelegate>

@property (strong, nonatomic) UIView *timeControl;
@property (strong, nonatomic) UIView *titlesStackView;
@property (strong, nonatomic) UIView *transportControlsStackView;
@property (strong, nonatomic) UIView *volumeSlider;

@end










%hook MusicNowPlayingControlsViewController

#pragma mark - Init

- (void)viewDidLoad
{
    %orig();
    

    
    if (self.acapellaKeyPrefix) {
        self.acapellaPrefs = [[SWAcapellaPrefs alloc] initWithKeyPrefix:self.acapellaKeyPrefix];
    }
    BOOL hasAcapella = (self.acapella || (self.acapellaPrefs && self.acapellaPrefs.enabled));
    if (!hasAcapella) {
        return;
    }
    
    
    
    
    self.transportControlsStackView.hidden = YES;
    
    
    // Remove titlesStackView current vertical position constraint
    NSMutableArray<NSLayoutConstraint *> *constraintsToDeactivate = [NSMutableArray new];
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.titlesStackView) {
            if (constraint.firstAttribute == NSLayoutAttributeFirstBaseline) {
                [constraintsToDeactivate addObject:constraint];
            }
        }
    }
    [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate.copy];
    
    
    // Placeholder view to vertically align titlesStackView
    UIView *titlesAlignmentView = [UIView new];
    titlesAlignmentView.userInteractionEnabled = NO;
    titlesAlignmentView.backgroundColor = [UIColor clearColor];
    titlesAlignmentView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:titlesAlignmentView];
    [self.view sendSubviewToBack:titlesAlignmentView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titlesAlignmentView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titlesAlignmentView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titlesAlignmentView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.timeControl
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titlesAlignmentView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.volumeSlider
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    
    // Add new titlesStackView vertical position constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.titlesStackView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:titlesAlignmentView
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
}

- (void)viewWillAppear:(BOOL)animated
{
    %orig(animated);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
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
    TRY_END
    
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
    
    
    if (!self.acapella && self.acapellaPrefs.enabled) {
        
        [SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                    referenceView:self.titlesStackView.superview
                                                     viewsToClone:@[self.titlesStackView]]
                      forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
}

- (void)viewDidDisappear:(BOOL)animated
{
    [SWAcapella removeAcapella:[SWAcapella acapellaForObject:self]];
    self.acapellaPrefs = nil;
    
    %orig(animated);
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
    return @"musicnowplaying";
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
    TRY
    //    [self transportControlsView:self.transportControls tapOnControlType:6];
    
    CATCH_LOG
    TRY_END
}

%new
- (void)action_upnext:(id)arg1
{
    TRY
    
    //    [self transportControlsView:self.transportControls tapOnControlType:7];
    
    CATCH_LOG
    TRY_END
}

%new
- (void)action_previoustrack:(id)arg1
{
	//	_TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
	//	MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
	//	MPRemoteCommandEvent *commandEvent = [commandCenter.nextTrackCommand newCommandEvent];
	//	[delegate.player performCommandEvent:commandEvent completion:^{
	//	}];
	
	MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
}

%new
- (void)action_nexttrack:(id)arg1
{
	//	_TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
	//	MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
	//	MPRemoteCommandEvent *commandEvent = [commandCenter.nextTrackCommand newCommandEvent];
	//	[delegate.player performCommandEvent:commandEvent completion:^{
	//	}];
	
	MRMediaRemoteSendCommand(kMRNextTrack, nil);
}

%new
- (void)action_intervalrewind:(id)arg1
{
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		
		NSDictionary *resultDict = (__bridge NSDictionary *)result;
		
		if (resultDict) {
			double elapsedTime = [[resultDict valueForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] doubleValue];
			MRMediaRemoteSetElapsedTime(elapsedTime - 20.0);
		}
		resultDict = nil;
	});
}

%new
- (void)action_intervalforward:(id)arg1
{
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		
		NSDictionary *resultDict = (__bridge NSDictionary *)result;
		
		if (resultDict) {
			double elapsedTime = [[resultDict valueForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoElapsedTime] doubleValue];
			MRMediaRemoteSetElapsedTime(elapsedTime + 20.0);
		}
		resultDict = nil;
	});
}

%new
- (void)action_seekrewind:(id)arg1
{
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		
		NSDictionary *resultDict = (__bridge NSDictionary *)result;
		
		if (resultDict) {
			int playbackRate = [[resultDict valueForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate] integerValue];
			MRMediaRemoteSendCommand((playbackRate == 1) ? kMRStartBackwardSeek : kMREndBackwardSeek, nil);
		}
		resultDict = nil;
	});
}

%new
- (void)action_seekforward:(id)arg1
{
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		
		NSDictionary *resultDict = (__bridge NSDictionary *)result;
		
		if (resultDict) {
			int playbackRate = [[resultDict valueForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate] integerValue];
			MRMediaRemoteSendCommand((playbackRate == 1) ? kMRStartForwardSeek : kMREndForwardSeek, nil);
		}
		resultDict = nil;
	});
}

%new
- (void)action_playpause:(id)arg1
{
	//    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
	//    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
	//    MPRemoteCommandEvent *commandEvent = [commandCenter.togglePlayPauseCommand newCommandEvent];
	//    [commandCenter dispatchCommandEvent:commandEvent completion:^{
	//
	//    }];
	
	MRMediaRemoteGetNowPlayingInfo(dispatch_get_main_queue(), ^(CFDictionaryRef result) {
		
		NSDictionary *resultDict = (__bridge NSDictionary *)result;
		BOOL wasSeeking = NO;
		
		if (resultDict) {
			int playbackRate = [[resultDict valueForKey:(__bridge NSString *)kMRMediaRemoteNowPlayingInfoPlaybackRate] integerValue];
			wasSeeking = (playbackRate != 1 && playbackRate != 0);
		}
		resultDict = nil;
		
		if (wasSeeking) {
			
			MRMediaRemoteSendCommand(kMREndForwardSeek, nil);
			MRMediaRemoteSendCommand(kMREndBackwardSeek, nil);
		} else {
			
			MRMediaRemoteGetNowPlayingApplicationIsPlaying(dispatch_get_main_queue(), ^(Boolean isPlaying) {
				
				MRMediaRemoteSendCommand(isPlaying ? kMRPause : kMRPlay, nil);
			});
		}
		
	});
	
	[self.acapella pulse];
}

%new
- (void)action_share:(id)arg1
{
    TRY
    
    //    [self transportControlsView:self.secondaryTransportControls tapOnControlType:8];
    
    CATCH_LOG
    TRY_END
}

%new
- (void)action_toggleshuffle:(id)arg1
{
//    TRY
//    
//    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
//    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
//    MPRemoteCommandEvent *commandEvent = [commandCenter.advanceShuffleModeCommand newCommandEventWithPreservesShuffleMode:NO];
//    [delegate.player performCommandEvent:commandEvent completion:^{
//        
//    }];
//    
//    CATCH_LOG
//    TRY_END
	
	MRMediaRemoteSendCommand(kMRToggleShuffle, nil);
}

%new
- (void)action_togglerepeat:(id)arg1
{
//    TRY
//    
//    _TtC5Music19ApplicationDelegate *delegate = (_TtC5Music19ApplicationDelegate *)[UIApplication sharedApplication].delegate;
//    MPRemoteCommandCenter *commandCenter = delegate.player.commandCenter;
//    MPRemoteCommandEvent *commandEvent = [commandCenter.advanceRepeatModeCommand newCommandEventWithPreservesRepeatMode:NO];
//    [delegate.player performCommandEvent:commandEvent completion:^{
//        
//    }];
//    
//    CATCH_LOG
//    TRY_END
	
	MRMediaRemoteSendCommand(kMRToggleRepeat, nil);
}

%new
- (void)action_contextual:(id)arg1
{
    TRY
    
    //    [self transportControlsView:self.secondaryTransportControls tapOnControlType:11];
    
    CATCH_LOG
    TRY_END
}

%new
- (void)action_openapp:(id)arg1
{
}

%new
- (void)action_showratings:(id)arg1
{
    TRY
    
    CATCH_LOG
    TRY_END
}

%new
- (void)action_decreasevolume:(id)arg1
{
	TRY
	[%c(AVSystemController) acapellaChangeVolume:-1];
	CATCH_LOG
	TRY_END
}

%new
- (void)action_increasevolume:(id)arg1
{
	TRY
	[%c(AVSystemController) acapellaChangeVolume:1];
	CATCH_LOG
	TRY_END
}

%new
- (void)action_equalizereverywhere:(id)arg1
{
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
    
    //	@try {
    //		[self _setRatingsVisible:NO];
    //	} @catch (NSException *exception) {
    //		NSLog(@"%@", exception);
    //	} @finally {
    //        self.acapella.cloneContainer.hidden = NO;
    //	}
}

%end





%ctor
{
    //if (SYSTEM_VERSION_EQUAL_TO(@"10.1.1")) {
      //  %init(ClassToHook = objc_getClass("Music.NowPlayingControlsViewController"));
    //} else
        //if (SYSTEM_VERSION_EQUAL_TO(@"10.2")) {
//        %init(ClassToHook = MusicNowPlayingControlsViewController);
    //}
}




