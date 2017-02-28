//
//  SWAcapellaCloneContainer.m
//  testtest
//
//  Created by Pat Sluth on 2017-02-27.
//  Copyright © 2017 patsluth. All rights reserved.
//

#import "SWAcapellaCloneContainer.h"

@implementation SWAcapellaCloneContainer

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

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    for (UIView *subview in self.subviews) {
        [subview setNeedsDisplay];
    }
}

@end
