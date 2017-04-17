//
//  MPUControlCenterMediaControlsViewController.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPUControlCenterMediaControlsViewController.h"
#import "MPUControlCenterMediaControlsView.h"

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"

#import "Sluthware/Sluthware.h"
#import "Sluthware/SWPrefs.h"
#import "libsw2/SWApplicationLauncher.h"

//#import "MPUTransportControlMediaRemoteController.h"

#import "SBMediaController.h"
#import "MediaRemote/MediaRemote.h"
#import "AVSystemController+SW.h"





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
    
    [self.view layoutSubviews];
}

- (void)viewDidAppear:(BOOL)animated
{
    %orig(animated);
	
    if (!self.acapella && self.acapellaPrefs.enabled) {
        
        [SWAcapella setAcapella:[[SWAcapella alloc] initWithOwner:self
                                                    referenceView:self.mediaControlsView
                                                     viewsToClone:@[self.mediaControlsView.artworkView,
                                                                    self.mediaControlsView.titleLabel,
                                                                    self.mediaControlsView.artistLabel,
                                                                    self.mediaControlsView.albumLabel,
                                                                    self.mediaControlsView.artistAlbumConcatenatedLabel]]
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
    return @"cc";
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
//	[[%c(SBMediaController) sharedInstance] changeTrack:-1];
//  [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:1];
	
	MRMediaRemoteSendCommand(kMRPreviousTrack, nil);
}

%new
- (void)action_nexttrack:(id)arg1
{
//	[[%c(SBMediaController) sharedInstance] changeTrack:1];
//  [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:4];
	
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
//	[[%c(SBMediaController) sharedInstance] togglePlayPause];
//	[self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:3];
	
	MRMediaRemoteSendCommand(kMREndForwardSeek, nil);
	MRMediaRemoteSendCommand(kMREndBackwardSeek, nil);
	MRMediaRemoteSendCommand(kMRTogglePlayPause, nil);
	
	[UIView pulseViews:self.acapella.cloneContainer.viewsToClone];
}

%new
- (void)action_share:(id)arg1
{
    [self transportControlsView:self.mediaControlsView.transportControls tapOnControlType:8];
}

%new
- (void)action_toggleshuffle:(id)arg1
{
//    [[%c(SBMediaController) sharedInstance] toggleShuffle];
	
	MRMediaRemoteSendCommand(kMRToggleShuffle, nil);
}

%new
- (void)action_togglerepeat:(id)arg1
{
//    [[%c(SBMediaController) sharedInstance] toggleRepeat];
	
	MRMediaRemoteSendCommand(kMRToggleRepeat, nil);
}

%new
- (void)action_contextual:(id)arg1
{
}

%new
- (void)action_openapp:(id)arg1
{
	TRY
	
	id nowPlayingController = MSHookIvar<id>(self, "_nowPlayingController");	// MPUNowPlayingController
	NSString *bundleID = MSHookIvar<NSString *>(nowPlayingController, "_currentNowPlayingAppDisplayID");
	
	[%c(SWApplicationLauncher) launchApplicationWithBundleID:bundleID];
	
	CATCH
	TRY_END
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




