//
//  SWAcapella.h
//  Acapella3
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

@import UIKit;
@import Foundation;

#import <objc/runtime.h>

#import "SWAcapellaCloneContainer.h"
#import "SWAcapellaDelegate.h"





@interface SWAcapella : NSObject <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>
{
}

+ (SWAcapella *)acapellaForObject:(id)object;
+ (void)setAcapella:(SWAcapella *)acapella forObject:(id)object withPolicy:(objc_AssociationPolicy)policy;
+ (void)removeAcapella:(SWAcapella *)acapella;

- (id)initWithOwner:(UIViewController<SWAcapellaDelegate> *)owner referenceView:(UIView *)referenceView viewsToClone:(NSArray<UIView *> *)viewsToClone;

@property (weak, nonatomic) UIViewController<SWAcapellaDelegate> *owner;    // The object which acapella will set a strong associated object to
@property (weak, nonatomic) UIView *referenceView;

@property (strong, nonatomic, readonly) SWAcapellaCloneContainer *cloneContainer;

@property (strong, nonatomic, readonly) UITapGestureRecognizer *tap;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *pan;
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *press;

- (void)finishWrapAround;

@end





static inline NSNotificationName onAcapellaCreatedNotificationName()
{
    return (NSNotificationName)@"onAcapellaCreatedNotificationName";
}

static inline NSNotificationName onAcapellaDestroyedNotificationName()
{
    return (NSNotificationName)@"onAcapellaDestroyedNotificationName";
}




