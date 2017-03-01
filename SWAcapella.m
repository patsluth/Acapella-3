//
//  SWAcapella.m
//  Acapella2
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

#import "SWAcapella.h"
//#import "SWAcapellaPrefs.h"

//#import "libsw/libSluthware/libSluthware.h"
//TODO: REMOVE
//#import "libsw/libSluthware/UISnapBehaviorHorizontal.h"
#import "libsw/libSluthware/NSTimer+SW.h"
//#import "libsw/libSluthware/SWPrefs.h"

#import <CoreGraphics/CoreGraphics.h>
//#import <MobileGestalt/MobileGestalt.h>

#import "SWAcapellaCloneContainer.h"




#define SW_PIRACY ;
//
//#define SW_PIRACY NSURL \
//\
//*url = [NSURL URLWithString:@"https://saurik.sluthware.com"]; \
//NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url \
//														  cachePolicy:NSURLRequestReloadIgnoringCacheData \
//													  timeoutInterval:60.0]; \
//[urlRequest setHTTPMethod:@"POST"]; \
//\
//CFStringRef udid = (CFStringRef)MGCopyAnswer(kMGUniqueDeviceID); \
//NSString *postString = [NSString stringWithFormat:@"udid=%@&packageID=%@", udid, @"org.thebigboss.acapella2"]; \
//[urlRequest setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]]; \
//CFRelease(udid); \
//\
//[NSURLConnection sendAsynchronousRequest:urlRequest \
//								   queue:[NSOperationQueue mainQueue] \
//					   completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) { \
//\
//	if (!connectionError) { \
//	\
//		NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]; \
//		\
//		/*  0 = Purchased */ \
//		/*  1 = Not Purchased */ \
//		/*  X = Cydia Error */ \
//		\
//		if ([dataString isEqualToString:@"1"]) { \
//		\
//			self.cloneContainer.hidden = YES; \
//			self.titles.layer.opacity = 1.0; \
//		\
//		} \
//	} \
//}];





@interface SWAcapella()
{
}

@property (strong, nonatomic, readwrite) SWAcapellaCloneContainer *cloneContainer;
@property (strong, nonatomic, readwrite) NSArray<SWAcapellaCloneView *> *clonedViews;

@property (strong, nonatomic, readwrite) NSLayoutConstraint *titlesCloneCenterXConstraint;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *bAttachment;

@property (strong, nonatomic, readwrite) UITapGestureRecognizer *tap;
@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *pan;
@property (strong, nonatomic, readwrite) UILongPressGestureRecognizer *press;
@property (weak, nonatomic, readwrite) UIGestureRecognizer *forceTouchGestureRecognizer;

@property (strong, nonatomic) NSTimer *wrapAroundFallback;

@end





@implementation SWAcapella

#pragma mark - SWAcapella

- (void)_acapella
{
}

+ (SWAcapella *)acapellaForObject:(id)object
{
    return objc_getAssociatedObject(object, @selector(_acapella));
}

+ (void)setAcapella:(SWAcapella *)acapella forObject:(id)object withPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(object, @selector(_acapella), acapella, policy);
}

+ (void)removeAcapella:(SWAcapella *)acapella
{
    if (acapella) {
		
		[[NSNotificationCenter defaultCenter] removeObserver:acapella];
		
//		for (SWAcapellaCloneView *clonedView in acapella.clonedViews) {
//            clonedView.viewToClone.userInteractionEnabled = YES;
//            clonedView.viewToClone.layer.opacity = 1.0;
//            
//            [clonedView removeFromSuperview];
//        }
        for (UIView *viewToClone in acapella.cloneContainer.viewsToClone) {
            viewToClone.userInteractionEnabled = YES;
            viewToClone.layer.opacity = 1.0;
        }
        for (UIView *subview in acapella.cloneContainer.subviews) {
            [subview removeFromSuperview];
        }
        [acapella.cloneContainer removeFromSuperview];
        acapella.cloneContainer = nil;
        acapella.clonedViews = nil;
		
        [acapella.animator removeAllBehaviors];
		acapella.animator = nil;
		acapella.bAttachment = nil;
		
        [acapella.tap.view removeGestureRecognizer:acapella.tap];
        [acapella.tap removeTarget:nil action:nil];
        acapella.tap = nil;
        
        [acapella.pan.view removeGestureRecognizer:acapella.pan];
        [acapella.pan removeTarget:nil action:nil];
        acapella.pan = nil;
        
        [acapella.press.view removeGestureRecognizer:acapella.press];
        [acapella.press removeTarget:nil action:nil];
        acapella.press = nil;
        
        [acapella.referenceView layoutSubviews];
		
    }
    
//    [SWAcapella setAcapella:nil forObject:acapella.titles withPolicy:OBJC_ASSOCIATION_ASSIGN];
    [SWAcapella setAcapella:nil forObject:acapella.owner withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

#pragma mark - Init

//- (id)initWithOwner:(UIViewController<SWAcapellaDelegate> *)owner
//	  referenceView:(UIView *)referenceView
//			 titles:(UIView *)titles
//{
//	NSAssert(owner != nil, @"SWAcapella owner cannot be nil");
//	NSAssert(referenceView != nil, @"SWAcapella referenceView cannot be nil");
//	NSAssert(titles != nil, @"SWAcapella titles cannot be nil");
//	
//	if (self = [super init]) {
//		
//		self.owner = owner;
//		self.referenceView = referenceView;
//		self.titles = titles;
//		
//		[self initialize];
//		
//	}
//	
//	return self;
//}

- (id)initWithOwner:(UIViewController<SWAcapellaDelegate> *)owner referenceView:(UIView *)referenceView viewsToClone:(NSArray<UIView *> *)viewsToClone
{
    if (self = [super init]) {
        
        self.owner = owner;
        self.referenceView = referenceView;
        
        //	[SWAcapella setAcapella:self forObject:self.titles withPolicy:OBJC_ASSOCIATION_ASSIGN];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        for (SWAcapellaCloneView *clonedView in self.clonedViews) {
            clonedView.viewToClone.userInteractionEnabled = NO;
        }
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
        self.animator.delegate = self;
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        self.tap.delegate = self;
        [self.referenceView addGestureRecognizer:self.tap];
        
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        self.pan.delegate = self;
        self.pan.minimumNumberOfTouches = self.pan.maximumNumberOfTouches = 1;
        [self.referenceView addGestureRecognizer:self.pan];
        
        self.press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onPress:)];
        self.press.delegate = self;
        [self.referenceView addGestureRecognizer:self.press];
        
        
        
        
        
        
        //	self.cloneContainer = [[SWAcapellaCloneView alloc] init];
        //	self.cloneContainer.tag = SWAcapellaTitlesStateNone;
        //	[self.referenceView addSubview:self.cloneContainer];
        
        self.cloneContainer = [[SWAcapellaCloneContainer alloc] initWithViewsToClone:viewsToClone];
        self.clonedViews = [NSArray new];
        
        self.cloneContainer.frame = self.referenceView.bounds;
        self.cloneContainer.tag = SWAcapellaTitlesStateNone;
        
//        for (UIView *viewToClone in self.cloneContainer.viewsToClone) {
//            
//            UIView *snapshotView = [viewToClone snapshotViewAfterScreenUpdates:YES];
//            snapshotView.frame = viewToClone.frame;
//            [self.cloneContainer addSubview:snapshotView];
//            
//            
////            SWAcapellaCloneView *cloneView = [[SWAcapellaCloneView alloc] init];
////            cloneView.frame = viewToClone.frame;
////            self.clonedViews = [self.clonedViews arrayByAddingObject:cloneView];
////            [self.cloneContainer addSubview:cloneView];
////            cloneView.viewToClone = viewToClone;
//        }
        
        [self.referenceView addSubview:self.cloneContainer];
        
        
        
        
        
        //	self.cloneContainerCenterXConstraint = [NSLayoutConstraint constraintWithItem:self.cloneContainer
        //																	 attribute:NSLayoutAttributeCenterX
        //																	 relatedBy:NSLayoutRelationEqual
        //																		toItem:self.referenceView
        //																	 attribute:NSLayoutAttributeCenterX
        //																	multiplier:1.0
        //																	  constant:0.0];
        //	[self.referenceView addConstraint:self.cloneContainerCenterXConstraint];
        //	[self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
        //																   attribute:NSLayoutAttributeCenterY
        //																   relatedBy:NSLayoutRelationEqual
        //																	  toItem:self.titles
        //																   attribute:NSLayoutAttributeCenterY
        //																  multiplier:1.0
        //																	constant:0.0]];
        //	[self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
        //																   attribute:NSLayoutAttributeWidth
        //																   relatedBy:NSLayoutRelationEqual
        //																	  toItem:self.titles
        //																   attribute:NSLayoutAttributeWidth
        //																  multiplier:1.0
        //																	constant:0.0]];
        //	[self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
        //																   attribute:NSLayoutAttributeHeight
        //																   relatedBy:NSLayoutRelationEqual
        //																	  toItem:self.titles
        //																   attribute:NSLayoutAttributeHeight
        //																  multiplier:1.0
        //																	constant:0.0]];
        
        [self.referenceView setNeedsUpdateConstraints];
        [self.referenceView setNeedsLayout];
        
        self.cloneContainer.frame = self.referenceView.bounds;
        [self.cloneContainer setNeedsDisplay];
        
        self.bAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.cloneContainer attachedToAnchor:CGPointZero];
        
    }
    
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    @autoreleasepool {
        
        if (gestureRecognizer == self.tap || gestureRecognizer == self.pan) {
            if ([touch.view isKindOfClass:[UIControl class]]) {
                UIControl *control = (UIControl *)touch.view;
                return !control.isEnabled;
            }
        }
        
        return YES;
        
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self.pan) {
		
		CGPoint panVelocity = [self.pan velocityInView:self.pan.view];
		return (ABS(panVelocity.x) > ABS(panVelocity.y)); // Only accept horizontal pans
		
	}
	
	return YES;
}

#pragma mark - UIGestureRecognizer

- (void)onTap:(UITapGestureRecognizer *)tap
{
	if (!self.cloneContainer.hidden) { // Don't do anything when titles view is hidden (ex when ratings view is visible)
		
		CGFloat xPercentage = [tap locationInView:tap.view].x / CGRectGetWidth(tap.view.bounds);
		//CGFloat yPercentage = [tap locationInView:tap.view].y / CGRectGetHeight(tap.view.bounds);
		
		SEL sel = nil;
		
		if (xPercentage <= 0.25) { // left
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapleft]);
		} else if (xPercentage > 0.75) { // right
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapright]);
		} else { // centre
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapcentre]);
		}
		
		if (sel && [self.owner respondsToSelector:sel]) {
			[self.owner performSelectorOnMainThread:sel withObject:tap waitUntilDone:NO];
		}
		
		SW_PIRACY;
		
	}
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
	 // Don't do anything when titles view is hidden (ex when ratings view is visible)
	if (self.cloneContainer.hidden || CGRectGetWidth(self.cloneContainer.frame) == 0.0 || CGRectGetHeight(self.cloneContainer.frame) == 0.0) {
		return;
	}
	
	CGPoint panLocation = [pan locationInView:pan.view];
    
	if (pan.state == UIGestureRecognizerStateBegan) {
		
		self.wrapAroundFallback = nil;
		[self.animator removeAllBehaviors];
		self.cloneContainer.tag = SWAcapellaTitlesStatePanning;
		[self.cloneContainer.layer removeAllAnimations];
		self.cloneContainer.transform = CGAffineTransformScale(self.cloneContainer.transform, 1.0, 1.0);
        
        
        
        
        
        
        
        
        
        
        
        
        
		[self.cloneContainer setNeedsDisplay];
		self.cloneContainer.velocity = CGPointZero;
		
        self.bAttachment.anchorPoint = CGPointMake(panLocation.x, self.cloneContainer.center.y);
        [self.animator addBehavior:self.bAttachment];
        
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        
        self.bAttachment.anchorPoint = CGPointMake(panLocation.x, self.bAttachment.anchorPoint.y);
        
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        
        [self.animator removeBehavior:self.bAttachment];
        
        //velocity after dragging
        CGPoint velocity = [pan velocityInView:pan.view];
        
        UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.cloneContainer]];
        bDynamicItem.allowsRotation = NO;
        bDynamicItem.resistance = 1.8;
        
        [self.animator addBehavior:bDynamicItem];
        [bDynamicItem addLinearVelocity:CGPointMake(velocity.x, 0.0) forItem:self.cloneContainer];
        
        __unsafe_unretained SWAcapella *weakSelf = self;
        __unsafe_unretained UIDynamicItemBehavior *weakbDynamicItem = bDynamicItem;
		
		CGFloat offScreenRightX = CGRectGetMaxX(self.referenceView.bounds) + CGRectGetMidX(self.cloneContainer.bounds);
		CGFloat offScreenLeftX = CGRectGetMinX(self.referenceView.bounds) - CGRectGetMidX(self.cloneContainer.bounds);
        
        bDynamicItem.action = ^{
			
			weakSelf.cloneContainer.velocity = [weakbDynamicItem linearVelocityForItem:weakSelf.cloneContainer];
            
            if (weakSelf.cloneContainer.center.x < offScreenLeftX) {
                
				[weakSelf.animator removeAllBehaviors];
				weakSelf.cloneContainer.center = CGPointMake(offScreenRightX, weakSelf.cloneContainer.center.y);
//				weakSelf.cloneContainerCenterXConstraint.constant = offScreenRightX - CGRectGetMidX(weakSelf.referenceView.bounds);
				[weakSelf.referenceView setNeedsLayout];
                [weakSelf didWrapAround:-1];
                
            } else if (weakSelf.cloneContainer.center.x > offScreenRightX) {
                
				[weakSelf.animator removeAllBehaviors];
				weakSelf.cloneContainer.center = CGPointMake(offScreenLeftX, weakSelf.cloneContainer.center.y);
//				weakSelf.cloneContainerCenterXConstraint.constant = offScreenLeftX - CGRectGetMidX(weakSelf.referenceView.bounds);
				[weakSelf.referenceView setNeedsLayout];
                [weakSelf didWrapAround:1];
                
            } else {
                
                CGFloat absoluteXVelocity = ABS(weakSelf.cloneContainer.velocity.x);
                
                //snap to center if we are moving to slow
                if (absoluteXVelocity < CGRectGetMidX(weakSelf.referenceView.bounds)) {
                    [weakSelf snapToCenter];
                }
                
            }
            
        };
	}
}

- (void)onPress:(UILongPressGestureRecognizer *)press
{
    if (press.state == UIGestureRecognizerStateBegan) {
        [self pressAtLocation:[press locationInView:press.view] inView:press.view];
    }
}

- (void)pressAtLocation:(CGPoint)location inView:(UIView *)view
{
	if (!self.cloneContainer.hidden) { // Don't do anything when titles view is hidden (ex when ratings view is visible)
		
		CGFloat xPercentage = location.x / CGRectGetWidth(view.bounds);
		//	CGFloat yPercentage = location.y / CGRectGetHeight(view.bounds);
		
		SEL sel = nil;
		
		if (xPercentage <= 0.25) { // left
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_pressleft]);
		} else if (xPercentage > 0.75) { // right
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_pressright]);
		} else { // centre
			//sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_presscentre]);
		}
		
		if (sel && [self.owner respondsToSelector:sel]) {
			if (!self.cloneContainer.hidden) { // Don't do anything when titles view is hidded (ex when ratings view is visible)
				[self.owner performSelectorOnMainThread:sel withObject:self.press waitUntilDone:NO];
			}
		}
		
		SW_PIRACY;
		
	}
}

#pragma mark - UIDynamics

/**
 *  Handle wrap around
 *
 *  @param direction left=(<0) right=(>0)
 */
- (void)didWrapAround:(NSInteger)direction
{
	if (self.cloneContainer.tag == SWAcapellaTitlesStatePanning) {
		
		self.cloneContainer.tag = SWAcapellaTitlesStateWaitingToFinishWrapAround;
//		self.titles.layer.opacity = 0.0;
        for (UIView *viewToClone in self.cloneContainer.viewsToClone) {
            viewToClone.layer.opacity = 0.0;
        }
		
		SEL sel = nil;
		
		if (direction < 0) { // left
            sel = NSSelectorFromString(@"action_nexttrack:");
//			sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_swipeleft]);
        } else if (direction > 0) { // right
            sel = NSSelectorFromString(@"action_previoustrack:");
//			sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_swiperight]);
		}
		
		if (sel && [self.owner respondsToSelector:sel]) {
			[self.owner performSelectorOnMainThread:sel withObject:self.pan waitUntilDone:NO];
		}
		
		
		self.wrapAroundFallback = [NSTimer scheduledTimerWithTimeInterval:1.0
																	block:^{
																		[self finishWrapAround];
																	} repeats:NO];
		
	}
}

- (void)finishWrapAround
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
		@autoreleasepool {
			
			self.wrapAroundFallback = nil;
			
			// Give text time to update
			[[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
			[self.cloneContainer setNeedsDisplay];
			
			if (self.cloneContainer.tag == SWAcapellaTitlesStateWaitingToFinishWrapAround) {
				
				self.cloneContainer.tag = SWAcapellaTitlesStateWrappingAround;
				[self.animator removeAllBehaviors];
				
				//add original velocity
				UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.cloneContainer]];
				[self.animator addBehavior:bDynamicItem];
				
				
				CGFloat horizontalVelocity = self.cloneContainer.velocity.x;
				//clamp horizontal velocity to its own width*(variable) per second
				horizontalVelocity = MIN(ABS(horizontalVelocity), CGRectGetWidth(self.cloneContainer.bounds) * 3.5);
				horizontalVelocity = copysignf(horizontalVelocity, self.cloneContainer.velocity.x);
				
				[bDynamicItem addLinearVelocity:CGPointMake(horizontalVelocity, 0.0) forItem:self.cloneContainer];
				
				
				__unsafe_unretained SWAcapella *weakSelf = self;
				__unsafe_unretained UIDynamicItemBehavior *weakbDynamicItem = bDynamicItem;
				
				bDynamicItem.action = ^{
					
					CGFloat velocity = [weakbDynamicItem linearVelocityForItem:weakSelf.cloneContainer].x;
					
					BOOL toSlow = ABS(velocity) < CGRectGetMidX(weakSelf.referenceView.bounds);
					
					if (toSlow) {
						
						[weakSelf snapToCenter];
						
					} else {
						
						CGFloat distanceFromCenter = weakSelf.cloneContainer.center.x - CGRectGetMidX(self.cloneContainer.superview.bounds);
						
						//if we have a -ve velocity, after we wrap around we will have a positive value for distanceFromCenter
						//once we travel past the center, this value will be -ve as well. This also happens in the other direction
						//except with positive values. So we know we have travelled past the center if our velocity and our distance from
						//the center have the same sign (-ve && -ve || +ve && +ve)
						if (((distanceFromCenter < 0) == (velocity < 0))) {
							//this will cause the toSlow condition to be met much quicker, snapping it to the centre
							weakbDynamicItem.resistance = 60;
						}
						
					}
					
				};
				
				self.cloneContainer.velocity = CGPointZero;
				
			}
			
		}
	});
}

- (void)snapToCenter
{
	dispatch_async(dispatch_get_main_queue(), ^(void) {
	@autoreleasepool {
		
		if (self.cloneContainer.tag == SWAcapellaTitlesStatePanning ||
			self.cloneContainer.tag == SWAcapellaTitlesStateWrappingAround) {
			
			[self.animator removeAllBehaviors];
			
			UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.cloneContainer]];
			bDynamicItem.density = 70.0;
			bDynamicItem.resistance = 5.0;
			bDynamicItem.allowsRotation = NO;
			bDynamicItem.angularResistance = CGFLOAT_MAX;
			bDynamicItem.friction = 1.0;
			[self.animator addBehavior:bDynamicItem];
			
			UISnapBehavior *bSnap = [[UISnapBehavior alloc] initWithItem:self.cloneContainer snapToPoint:CGPointMake(CGRectGetMidX(self.referenceView.bounds), self.cloneContainer.center.y)];
			bSnap.damping = 0.3;
			[self.animator addBehavior:bSnap];
			
			self.cloneContainer.tag = SWAcapellaTitlesStateSnappingToCenter;
			
		}
		
	}
	});
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    //this method will get called if we stop dragging, but still have our finger down
    //check to see if we are dragging to make sure we dont remove all behaviours
	
    if (self.cloneContainer.tag != SWAcapellaTitlesStateSnappingToCenter) {
        return;
    }
	
	self.cloneContainer.tag = SWAcapellaTitlesStateNone;
//	self.cloneContainerCenterXConstraint.constant = 0.0;
	self.cloneContainer.center = CGPointMake(CGRectGetMidX(self.referenceView.bounds), self.cloneContainer.center.y);
    [animator removeAllBehaviors];
}

#pragma mark - Public

- (void)pulse
{
	self.cloneContainer.tag = SWAcapellaTitlesStateNone;
	self.wrapAroundFallback = nil;
	[self.animator removeAllBehaviors];
	self.cloneContainer.velocity = CGPointZero;
	[self.cloneContainer.layer removeAllAnimations];
	self.cloneContainer.frame = self.referenceView.frame;
//	self.cloneContainerCenterXConstraint.constant = 0.0;
	[self.referenceView setNeedsLayout];
	[self.cloneContainer setNeedsDisplay];
	
	[UIView animateWithDuration:0.11
						  delay:0.01
						options:UIViewAnimationOptionBeginFromCurrentState
					 animations:^{
						 
						 self.cloneContainer.transform = CGAffineTransformMakeScale(1.15, 1.15);
					 
					 } completion:^(BOOL finished) {
						 
						 if (finished) {
							 
							 [UIView animateWithDuration:0.11
												   delay:0.0
												 options:UIViewAnimationOptionBeginFromCurrentState
											  animations:^{
												  
												  self.cloneContainer.transform = CGAffineTransformIdentity;
												  
											  } completion:^(BOOL finished) {
												  
												  if (finished) {
													  self.cloneContainer.transform = CGAffineTransformIdentity;
												  }
												  
											  }];
                             
                         }
                         
                     }];

}

- (void)setTitlesCloneVisible:(BOOL)visible
{
	self.cloneContainer.hidden = !visible;
//    for (SWAcapellaCloneView *clonedView in self.clonedViews) {
//        clonedView.viewToClone.layer.opacity = self.cloneContainer.hidden ? 1.0 : 0.0;
//    }
    for (UIView *viewToClone in self.cloneContainer.viewsToClone) {
        viewToClone.layer.opacity = self.cloneContainer.hidden ? 1.0 : 0.0;
    }
}

#pragma mark - NSNotificationCenter

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	// Fix for the titles view displaying the incorrect song if the song changes while the app is in the background
	[self.referenceView setNeedsLayout];
	[self.referenceView layoutIfNeeded];
	
	self.cloneContainer.frame = self.referenceView.frame;
    [self.cloneContainer setNeedsDisplay];
}

#pragma mark - Internal

- (void)setWrapAroundFallback:(NSTimer *)wrapAroundFallback
{
    if (_wrapAroundFallback && !wrapAroundFallback) {
        [_wrapAroundFallback invalidate];
    }
    
    _wrapAroundFallback = wrapAroundFallback;
}

@end




