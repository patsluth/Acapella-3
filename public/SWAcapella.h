//
//  SWAcapella.h
//  Acapella2
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

@import UIKit;
@import Foundation;

#import <objc/runtime.h>

#import "SWAcapellaCloneView.h"
#import "SWAcapellaDelegate.h"





typedef NS_ENUM(NSInteger, SWAcapellaTitlesState) {
	SWAcapellaTitlesStateNone,
	SWAcapellaTitlesStatePanning,
	SWAcapellaTitlesStateWaitingToFinishWrapAround,
	SWAcapellaTitlesStateWrappingAround,
	SWAcapellaTitlesStateSnappingToCenter,
	SWAcapellaTitlesStateForceScaling
};





@interface SWAcapella : NSObject <UIGestureRecognizerDelegate, UIDynamicAnimatorDelegate>
{
}


+ (SWAcapella *)acapellaForObject:(id)object;
+ (void)setAcapella:(SWAcapella *)acapella forObject:(id)object withPolicy:(objc_AssociationPolicy)policy;
+ (void)removeAcapella:(SWAcapella *)acapella;


// This is the object which keeps a strong reference to this acapella associated object
@property (weak, nonatomic) UIViewController<SWAcapellaDelegate> *owner;
@property (weak, nonatomic) UIView *referenceView;

@property (strong, nonatomic, readonly) UITapGestureRecognizer *tap;
@property (strong, nonatomic, readonly) UIPanGestureRecognizer *pan;
@property (strong, nonatomic, readonly) UILongPressGestureRecognizer *press;

- (id)initWithOwner:(UIViewController<SWAcapellaDelegate> *)owner referenceView:(UIView *)referenceView viewsToClone:(NSArray<UIView *> *)viewsToClone;

/**
 *  Tell Acapella titles view is ready to wrap around and snap back to centre
 */
- (void)finishWrapAround;
/**
 *  Perform animation that 'pulses' the view. (Increase then decrease in size, like a hearbeat)
 */
- (void)pulse;

- (void)setTitlesCloneVisible:(BOOL)visible;

@end




