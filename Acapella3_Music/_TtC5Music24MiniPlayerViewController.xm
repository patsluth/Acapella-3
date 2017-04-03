//
//  MusicMiniPlayerViewController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-12-27.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "_TtC5Music19ApplicationDelegate+SW.h"
#import "MediaPlayer+SW.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"
//#import "SWAcapellaMediaItemPreviewViewController.h"

//#import "libsw/libSluthware/libSluthware.h"
#import "Sluthware/Sluthware.h"

#import "MPUTransportControlMediaRemoteController.h"
#import "MusicTabBarController.h"


#import "SWAcapella.h"
#import "_TtC5Music19ApplicationDelegate+SW.h"
#import "MediaPlayer+SW.h"
#import "SWAcapellaPrefs.h"

#import "Sluthware/Sluthware.h"

#import "MPUTransportControlMediaRemoteController.h"

#import <objc/runtime.h>

#import "MediaRemote.h"
#import "AVSystemController+SW.h"





#pragma mark - _TtC5Music24MiniPlayerViewController

@interface _TtC5Music24MiniPlayerViewController : UIViewController <SWAcapellaDelegate>

@property (strong, nonatomic) UIView *artworkView;
@property (strong, nonatomic) UIView *nowPlayingItemTitleLabel;
@property (strong, nonatomic) UIView *transportControlsStack;

@property (strong, nonatomic) UIButton *miniPlayerButton;

@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UILongPressGestureRecognizer *playbackCancellationGesture;

@end





%hook _TtC5Music24MiniPlayerViewController

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
    
    
    
    
    
    
    self.transportControlsStack.hidden = YES;
    
    
    
    NSMutableArray<NSLayoutConstraint *> *constraintsToDeactivate = [NSMutableArray new];
    for (NSLayoutConstraint *constraint in self.view.constraints) {
        if (constraint.firstItem == self.nowPlayingItemTitleLabel && constraint.secondItem == self.transportControlsStack) {
            if (constraint.firstAttribute == NSLayoutAttributeTrailing && constraint.secondAttribute == NSLayoutAttributeLeading) {
                [constraintsToDeactivate addObject:constraint];
            }
        }
    }
    [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate.copy];
    
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.nowPlayingItemTitleLabel
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0.0]];

}

- (void)viewWillAppear:(BOOL)animated
{
    %orig(animated);
    
    // Initialize prefs for this instance
    if (self.acapellaKeyPrefix) {
        self.acapellaPrefs = [[SWAcapellaPrefs alloc] initWithKeyPrefix:self.acapellaKeyPrefix];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    %orig(animated);
    
    
    // special case where the pref key prefix is not ready in viewWillAppear, but it will always be ready here
    if (!self.acapellaPrefs) {
        [self viewWillAppear:NO];
    }
    
    
    
    
    
    if (!self.acapella && self.acapellaPrefs.enabled) {
        
        [SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                    referenceView:self.view
                                                     viewsToClone:@[self.nowPlayingItemTitleLabel]]
                      forObject:self withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
    }
    
    self.miniPlayerButton.enabled = (!self.acapella);
    
    if (self.acapella) {
        
        [self.panGestureRecognizer requireGestureRecognizerToFail:self.acapella.pan];
        [self.playbackCancellationGesture requireGestureRecognizerToFail:self.acapella.pan];
        [self.playbackCancellationGesture requireGestureRecognizerToFail:self.acapella.press];
        
    }
    
    [self viewDidLayoutSubviews];
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
    TRY_END
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
    TRY_END
}

%new
- (void)action_heart:(id)arg1
{
}

%new
- (void)action_upnext:(id)arg1
{
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
    
//    [self transportControlsView:self.secondaryTransportControlsView tapOnControlType:11];
    
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
    //%init(ClassToHook = objc_getClass("Music.MiniPlayerViewController"));
    //%init(ClassToHook = "_TtC5Music24MiniPlayerViewController");
}




