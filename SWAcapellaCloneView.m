//
//  SWAcapellaCloneView.m
//  Acapella2
//
//  Created by Pat Sluth on 2015-07-18.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

#import "SWAcapellaCloneView.h"





@interface SWAcapellaCloneView()

@end





@implementation SWAcapellaCloneView

#pragma mark - Init

- (id)init
{
	if (self = [super init]) {
		
        self.backgroundColor = [UIColor clearColor];
		self.translatesAutoresizingMaskIntoConstraints = NO;
		self.userInteractionEnabled = NO;
		
	}
	
	return self;
}

- (void)setHidden:(BOOL)hidden
{
	[super setHidden:hidden];
	
	[self setNeedsDisplay];
}

- (void)setViewToClone:(UIView *)viewToClone
{
	_viewToClone = viewToClone;
	
	[self setNeedsDisplay];
}

#pragma mark Rendering

- (void)drawRect:(CGRect)rect
{
	if (self.viewToClone && !self.hidden) {
		
		CALayer *layer = self.viewToClone.layer.modelLayer;
		
		if (!layer) {
			layer = self.viewToClone.layer;
		}
		
		if (layer) {
			
			// make titles layer visible and render in the clone
			layer.opacity = 1.0;
			
			CGContextSetInterpolationQuality(UIGraphicsGetCurrentContext(), kCGInterpolationDefault);
			[layer renderInContext:UIGraphicsGetCurrentContext()];
			
			layer.opacity = 0.0;
			
		}
	}
}

@end



