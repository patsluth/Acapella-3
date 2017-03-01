//
//  SWAcapellaCloneContainer.m
//  testtest
//
//  Created by Pat Sluth on 2017-02-27.
//  Copyright © 2017 patsluth. All rights reserved.
//

#import "SWAcapellaCloneContainer.h"





@interface SWAcapellaCloneContainer()

@property (strong, nonatomic, readwrite) NSArray<UIView *> *viewsToClone;

@end

@interface UIView(SW)

- (UIView *)sb_generateSnapshotViewAsynchronouslyOnQueue:(id)queue completionHandler:(id)completionHandler;

@end





@implementation SWAcapellaCloneContainer

- (id)initWithViewsToClone:(NSArray<UIView *> *)viewsToClone
{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        
        self.viewsToClone = viewsToClone;
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
//        [subview setNeedsDisplay];
        [subview removeFromSuperview];
    }
    
    for (UIView *viewToClone in self.viewsToClone) {
        
        CGRect viewToCloneFrame = viewToClone.frame;
        viewToClone.frame = CGRectOffset(viewToCloneFrame, 10000, 10000);
        viewToClone.layer.opacity = 1.0;
        
        if ([viewToClone respondsToSelector:@selector(sb_generateSnapshotViewAsynchronouslyOnQueue:completionHandler:)]) {
            
            [viewToClone sb_generateSnapshotViewAsynchronouslyOnQueue:dispatch_get_main_queue()
                                                    completionHandler:^(UIView *snapshotView) {
                                                        snapshotView.frame = viewToCloneFrame;
                                                        [self addSubview:snapshotView];
                                                        viewToClone.layer.opacity = 0.0;
                                                        viewToClone.frame = viewToCloneFrame;
                                                    }];
            
        } else {
            
            UIView *snapshotView = [viewToClone snapshotViewAfterScreenUpdates:YES];
            snapshotView.frame = viewToCloneFrame;
            [self addSubview:snapshotView];
            viewToClone.layer.opacity = 0.0;
            viewToClone.frame = viewToCloneFrame;
            
        }
        
        
        
        
        
        
        
    }
}

@end
