




@interface SBMediaController : NSObject

+ (id)sharedInstance;

- (void)decreaseVolume;
- (void)increaseVolume;

- (void)_commitVolumeChange:(id)arg1;
- (void)_cancelPendingVolumeChange;
- (void)_authenticationStateChanged:(id)arg1;
- (void)_applicationActivityStatusDidChange:(id)arg1;
- (void)_nowPlayingAppIsPlayingDidChange;
- (void)_nowPlayingPIDChanged;
- (void)_nowPlayingInfoChanged;
- (void)_systemMuteChanged:(id)arg1;
- (void)_softMuteChanged:(id)arg1;
- (void)_systemVolumeChanged:(id)arg1;
- (void)_externalScreenChanged:(id)arg1;
- (void)_updateAVRoutes;
- (void)_serverConnectionDied:(id)arg1;
- (void)_unregisterForNotifications;
- (void)_registerForNotifications;
- (id)nameOfPickedRoute;
- (_Bool)isScreenSharing;
- (_Bool)wirelessDisplayRouteIsPicked;
- (_Bool)routeOtherThanHandsetIsAvailable;
- (_Bool)volumeControlIsAvailable;


- (float)_calcButtonRepeatDelay;
- (void)_changeVolumeBy:(float)arg1;
- (_Bool)lastSavedRingerMutedState;
@property(nonatomic, getter=isRingerMuted) _Bool ringerMuted;
- (_Bool)muted;
- (void)setVolume:(float)arg1;
- (float)volume;
- (_Bool)setPlaybackSpeed:(int)arg1;
- (_Bool)toggleShuffle;
- (_Bool)toggleRepeat;
- (_Bool)skipFifteenSeconds:(int)arg1;
- (_Bool)stop;
- (_Bool)togglePlayPause;
- (_Bool)pause;
- (_Bool)play;
- (_Bool)endSeek:(int)arg1;
- (_Bool)beginSeek:(int)arg1;
- (_Bool)changeTrack:(int)arg1;
- (_Bool)_sendMediaCommand:(unsigned int)arg1;


- (_Bool)addTrackToWishList;
- (_Bool)likeTrack;
- (_Bool)banTrack;
- (_Bool)isPaused;
- (_Bool)isPlaying;
- (_Bool)isLastTrack;
- (_Bool)isFirstTrack;
- (_Bool)hasTrack;

@end




