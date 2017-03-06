//
//  SWAcapellaCloneContainer.m
//  SWAcapella3
//
//  Created by Pat Sluth on 2017-02-27.
//  Copyright © 2017 patsluth. All rights reserved.
//

#import "SWAcapellaCloneContainer.h"

#import <objc/runtime.h>





@interface SWAcapellaCloneContainer()

@property (strong, nonatomic, readwrite) NSArray<UIView *> *viewsToClone;

@end





@implementation SWAcapellaCloneContainer

#pragma mark - Init

- (id)initWithViewsToClone:(NSArray<UIView *> *)viewsToClone
{
    if (self = [super init]) {
        
        self.tag = SWAcapellaCloneContainerStateNone;
        
        self.backgroundColor = [UIColor clearColor];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        self.userInteractionEnabled = NO;
        self.clipsToBounds = YES;
        
        self.viewsToClone = viewsToClone;
    }
    
    return self;
}

- (void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    
    [self refreshClones];
}

#pragma mark 

- (void)refreshClones
{
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(refreshClones) withObject:nil waitUntilDone:NO];
        return;
    }
    
    
    if (self.tag == SWAcapellaCloneContainerStateNone) {
        
        for (UIView *viewToClone in self.viewsToClone) {
            if (viewToClone.superview == self) {
                
                // Add view back to original subview
                CGRect viewToCloneFrame = viewToClone.frame;
                [self.superview addSubview:viewToClone];
                viewToClone.frame = viewToCloneFrame;
                
                // Remove our translated constraints and activate previously deactivated constraints
                NSArray<NSLayoutConstraint *> *constraintsToActivate = objc_getAssociatedObject(viewToClone, @selector(_constraintsToDeactivate));
                NSMutableArray<NSLayoutConstraint *> *constraintsToDeactivate = [NSMutableArray new];
                for (NSLayoutConstraint *constraint in self.constraints) {
                    if (constraint.firstItem == viewToClone) {
                        [constraintsToDeactivate addObject:constraint];
                    }
                }
                [NSLayoutConstraint activateConstraints:constraintsToActivate.copy];
                [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate.copy];
                
                objc_setAssociatedObject(viewToClone, @selector(layoutSubviews), NULL, OBJC_ASSOCIATION_RETAIN);
            }
        }
        
        return;
    }
    
    
    for (UIView *viewToClone in self.viewsToClone) {
        if (viewToClone.superview != self) {
            
            // Add view to self
            CGRect viewToCloneFrame = viewToClone.frame;
            [self addSubview:viewToClone];
            viewToClone.frame = viewToCloneFrame;
            
            // Deactivate constraints affecting viewToClone
            NSMutableArray<NSLayoutConstraint *> *constraintsToDeactivate = [NSMutableArray new];
            for (NSLayoutConstraint *constraint in self.superview.constraints) {
                if (constraint.firstItem == viewToClone) {
                    [constraintsToDeactivate addObject:constraint];
                }
            }
            // Save deactivated constraints so we can re-activate later on
            objc_setAssociatedObject(viewToClone, @selector(_constraintsToDeactivate), constraintsToDeactivate.copy, OBJC_ASSOCIATION_RETAIN);
            [NSLayoutConstraint deactivateConstraints:constraintsToDeactivate.copy];
            
            
            // Translate deactivated constraints to use self
            [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToClone
                                                             attribute:NSLayoutAttributeLeft
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:CGRectGetMinX(viewToCloneFrame)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToClone
                                                             attribute:NSLayoutAttributeRight
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeLeft
                                                            multiplier:1.0
                                                              constant:CGRectGetMaxX(viewToCloneFrame)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToClone
                                                             attribute:NSLayoutAttributeTop
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:CGRectGetMinY(viewToCloneFrame)]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:viewToClone
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1.0
                                                              constant:CGRectGetMaxY(viewToCloneFrame)]];
            
        }
    }
}

- (void)_constraintsToDeactivate
{
}

@end




