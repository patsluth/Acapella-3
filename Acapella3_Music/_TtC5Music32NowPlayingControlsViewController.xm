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





#pragma mark - _TtC5Music32NowPlayingControlsViewController

@interface _TtC5Music32NowPlayingControlsViewController : UIViewController <SWAcapellaDelegate>

@property (strong, nonatomic) UIView *timeControl;
@property (strong, nonatomic) UIView *titlesStackView;
@property (strong, nonatomic) UIView *transportControlsStackView;
@property (strong, nonatomic) UIView *volumeSlider;

@end





%hook _TtC5Music32NowPlayingControlsViewController

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

- (void)viewDidAppear:(BOOL)animated
{
	%orig(animated);
	
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
	
	MRMediaRemoteSendCommand(kMREndForwardSeek, nil);
	MRMediaRemoteSendCommand(kMREndBackwardSeek, nil);
	MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
	
	[UIView pulseViews:self.acapella.cloneContainer.viewsToClone];
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

%end





%ctor
{
}




