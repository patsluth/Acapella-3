




#import "MPUMediaRemoteControlsView.h"

#import "MPUEmptyNowPlayingView.h"





@interface MPUControlCenterMediaControlsView : MPUMediaRemoteControlsView
{
}
    
@property (strong, nonatomic) UIView /* MPUNowPlayingArtworkView */ *artworkView;

@property (strong, nonatomic) UIView *titleLabel;
@property (strong, nonatomic) UIView *artistLabel;
@property (strong, nonatomic) UIView *albumLabel;
@property (strong, nonatomic) UIView *artistAlbumConcatenatedLabel;

@property (nonatomic, readonly) MPUEmptyNowPlayingView *emptyNowPlayingView;

@property (nonatomic) BOOL useCompactStyle;


/*
_contentSizeInterpolator --- @"MPULayoutInterpolator"
_marginLayoutInterpolator --- @"MPULayoutInterpolator"
_landscapeMarginLayoutInterpolator --- @"MPULayoutInterpolator"
_artworkNormalContentSizeLayoutInterpolator --- @"MPULayoutInterpolator"
_artworkLargeContentSizeLayoutInterpolator --- @"MPULayoutInterpolator"
_artworkLandscapePhoneLayoutInterpolator --- @"MPULayoutInterpolator"
_labelsLeadingHeightPhoneLayoutInterpolator --- @"MPULayoutInterpolator"
_transportControlsWidthStandardLayoutInterpolator --- @"MPULayoutInterpolator"
_transportControlsWidthCompactLayoutInterpolator --- @"MPULayoutInterpolator"
_volumeView --- @"MPUMediaControlsVolumeView"
_transportControls --- @"MPUTransportControlsView"
_timeView --- @"MPUControlCenterTimeView"
_routingContainerView --- @"UIView"
_titleLabel --- @"MPUControlCenterMetadataView"
_artistLabel --- @"MPUControlCenterMetadataView"
_albumLabel --- @"MPUControlCenterMetadataView"
_artistAlbumConcatenatedLabel --- @"MPUControlCenterMetadataView"
_unknownApplication --- B
_useCompactStyle --- B
_animating --- B
_delegate --- @"<MPUControlCenterMediaControlsViewDelegate>"
_layoutStyle --- Q
_pickedRoute --- @"MPAVRoute"
_routingView --- @"UIView"
_artworkView --- @"MPUNowPlayingArtworkView"
_pickedRouteHeaderView --- @"MPUAVRouteHeaderView"
_emptyNowPlayingView --- @"MPUEmptyNowPlayingView"
_displayMode --- Q
*/

@end




