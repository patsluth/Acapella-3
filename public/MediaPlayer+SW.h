




@interface MPRemoteCommandEvent : NSObject

@end





@interface MPRemoteCommand : NSObject

- (void)invokeCommandWithEvent:(id)arg1 completion:(id)arg2;

- (MPRemoteCommandEvent *)newCommandEvent;
- (id)_mediaRemoteCommandInfoOptions;

@end





@interface MPFeedbackCommand : MPRemoteCommand

@end





@interface MPChangePlaybackPositionCommand : MPRemoteCommand

- (MPRemoteCommandEvent *)newCommandEventWithPositionTime:(CGFloat)arg1;

@end





@interface MPChangePlaybackProgressCommand : MPRemoteCommand

- (MPRemoteCommandEvent *)newCommandEventWithPositionTime:(CGFloat)arg1;

@end





@interface MPSkipIntervalCommand : MPRemoteCommand

- (MPRemoteCommandEvent *)newCommandEventWithInterval:(CGFloat)arg1;

@end





@interface MPAdvanceRepeatModeCommand : MPRemoteCommand

- (MPRemoteCommandEvent *)newCommandEventWithPreservesRepeatMode:(BOOL)arg1;

@end





@interface MPAdvanceShuffleModeCommand : MPRemoteCommand

- (MPRemoteCommandEvent *)newCommandEventWithPreservesShuffleMode:(BOOL)arg1;

@end





@interface MPRemoteCommandCenter : NSObject
{
    void *_mediaRemoteCommandHandler;
}

+ (id)sharedCommandCenter;

@property (getter=_activeCommands, nonatomic, readonly) NSArray *activeCommands;
//@property (nonatomic, readonly) MPFeedbackCommand *addItemToLibraryCommand;
//@property (nonatomic, readonly) MPFeedbackCommand *addNowPlayingItemToLibraryCommand;
@property (nonatomic, readonly) MPAdvanceRepeatModeCommand *advanceRepeatModeCommand;
@property (nonatomic, readonly) MPAdvanceShuffleModeCommand *advanceShuffleModeCommand;
//@property (nonatomic, readonly) MPFeedbackCommand *bookmarkCommand;
//@property (nonatomic, readonly) MPPurchaseCommand *buyAlbumCommand;
//@property (nonatomic, readonly) MPPurchaseCommand *buyTrackCommand;
//@property (nonatomic, readonly) MPPurchaseCommand *cancelDownloadCommand;
@property (nonatomic, readonly) MPChangePlaybackPositionCommand *changePlaybackPositionCommand;
@property (nonatomic, readonly) MPChangePlaybackProgressCommand *changePlaybackProgressCommand;
//@property (nonatomic, readonly) MPChangePlaybackRateCommand *changePlaybackRateCommand;
//@property (nonatomic, readonly) MPChangeRepeatModeCommand *changeRepeatModeCommand;
//@property (nonatomic, readonly) MPChangeShuffleModeCommand *changeShuffleModeCommand;
@property (nonatomic, readonly) MPRemoteCommand *createRadioStationCommand;
@property (nonatomic, readonly) MPRemoteCommand *disableLanguageOptionCommand;
@property (nonatomic, readonly) MPFeedbackCommand *dislikeCommand;
@property (nonatomic, readonly) MPRemoteCommand *enableLanguageOptionCommand;
//@property (nonatomic, readonly) MPInsertIntoPlaybackQueueCommand *insertIntoPlaybackQueueCommand;
@property (nonatomic, readonly) MPFeedbackCommand *likeCommand;
@property (nonatomic, readonly) MPRemoteCommand *nextTrackCommand;
@property (nonatomic, readonly) MPRemoteCommand *pauseCommand;
@property (nonatomic, readonly) MPRemoteCommand *playCommand;
//@property (nonatomic, readonly) MPPurchaseCommand *preOrderAlbumCommand;
@property (nonatomic, readonly) MPRemoteCommand *previousTrackCommand;
//@property (nonatomic, readonly) MPRatingCommand *ratingCommand;
@property (nonatomic, readonly) MPRemoteCommand *removeFromPlaybackQueueCommand;
//@property (nonatomic, readonly) MPReorderQueueCommand *reorderQueueCommand;
@property (nonatomic, readonly) MPRemoteCommand *seekBackwardCommand;
@property (nonatomic, readonly) MPRemoteCommand *seekForwardCommand;
//@property (nonatomic, readonly) MPSetPlaybackQueueCommand *setPlaybackQueueCommand;
@property (nonatomic, readonly) MPSkipIntervalCommand *skipBackwardCommand;
@property (nonatomic, readonly) MPSkipIntervalCommand *skipForwardCommand;
@property (nonatomic, readonly) MPRemoteCommand *specialSeekBackwardCommand;
@property (nonatomic, readonly) MPRemoteCommand *specialSeekForwardCommand;
@property (nonatomic, readonly) MPRemoteCommand *stopCommand;
@property (nonatomic, readonly) MPRemoteCommand *togglePlayPauseCommand;

- (void)_pushMediaRemoteCommand:(NSUInteger)arg1 withOptions:(NSDictionary *)arg2;
- (void)_pushMediaRemoteCommand:(NSUInteger)arg1 withOptions:(NSDictionary *)arg2 completion:(id)arg3;

@end





@interface MPCPlayer : NSObject

@property (strong, nonatomic) MPRemoteCommandCenter *commandCenter;

- (void)performCommandEvent:(id)arg1 completion:(id)arg2;

@end





@interface MPCMediaPlayerLegacyPlayer : MPCPlayer

@end





@interface MPVolumeController : NSObject
{
}

@property (nonatomic, readonly) float volumeValue;


- (void)_forcefullySetVolumeValue:(float)arg1;
- (void)_internalSetVolumeValue:(float)arg1;

- (float)setVolumeValue:(float)arg1;

@end




