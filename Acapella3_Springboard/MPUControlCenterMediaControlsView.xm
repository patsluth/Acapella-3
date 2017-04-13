//
//  MPUControlCenterMediaControlsView.xm
//  Acapella3
//
//  Created by Pat Sluth on 2017-02-09.
//
//

#import "MPUControlCenterMediaControlsView.h"

#import "SWAcapella.h"





#pragma mark - MPUControlCenterMediaControlsView

%hook MPUControlCenterMediaControlsView

%new
- (UIView /* MPUNowPlayingArtworkView */ *)artworkView
{
	return MSHookIvar<UIView *>(self, "_artworkView");
}

%new
- (UIView *)titleLabel
{
	return MSHookIvar<UIView *>(self, "_titleLabel");
}

%new
- (UIView *)artistLabel
{
	return MSHookIvar<UIView *>(self, "_artistLabel");
}

%new
- (UIView *)albumLabel
{
	return MSHookIvar<UIView *>(self, "_albumLabel");
}

%new
- (UIView *)artistAlbumConcatenatedLabel
{
	return MSHookIvar<UIView *>(self, "_artistAlbumConcatenatedLabel");
}

- (void)layoutSubviews
{
	%orig();
	
	SWAcapella *acapella = [SWAcapella acapellaForObject:self];
	
	if (!acapella) {
		return;
	}
	
	// Show tap to play text
	self.emptyNowPlayingView.shouldShowActionText = YES;
	
	// Calcualate centre based on visible controls
	if (!self.useCompactStyle) {
		
		self.timeView.frame = CGRectMake(CGRectGetMinX(self.timeView.frame),
										 CGRectGetMinX(self.artworkView.frame),
										 CGRectGetWidth(self.timeView.bounds),
										 CGRectGetHeight(self.timeView.bounds));
		

		CGFloat topGuideline = CGRectGetMaxY(self.timeView.frame);
		CGFloat bottomGuideline = CGRectGetMinY(self.volumeView.frame);
		
		CGFloat midPoint = (topGuideline + (ABS(topGuideline - bottomGuideline) * 0.5));
		CGFloat deltaY = ABS(midPoint - CGRectGetMidX(self.artworkView.bounds));
		
		
		self.artworkView.center = CGPointMake(self.artworkView.center.x, midPoint);
		// Move labels down by same ammount as the artworkView was moved
		self.titleLabel.center = CGPointMake(self.titleLabel.center.x, self.titleLabel.center.y + deltaY);
		self.artistLabel.center = CGPointMake(self.artistLabel.center.x, self.artistLabel.center.y + deltaY);
		self.albumLabel.center = CGPointMake(self.albumLabel.center.x, self.albumLabel.center.y + deltaY);
		self.artistAlbumConcatenatedLabel.center = CGPointMake(self.artistAlbumConcatenatedLabel.center.x, self.artistAlbumConcatenatedLabel.center.y + deltaY);
		
	} else {
		
		//		self.emptyNowPlayingView.frame = CGRectMake(CGRectGetMinX(self.emptyNowPlayingView.frame),
		//													CGRectGetMinY(self.emptyNowPlayingView.frame),
		//													CGRectGetMaxX(self.bounds) - CGRectGetMinX(self.emptyNowPlayingView.frame),
		//													CGRectGetMaxY(self.emptyNowPlayingView.bounds));
		
	}
}

%end





%ctor
{
}




