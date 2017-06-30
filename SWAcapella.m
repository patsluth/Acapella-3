//
//  SWAcapella.m
//  Acapella2
//
//  Created by Pat Sluth on 2015-07-08.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

#import "SWAcapella.h"
#import "SWAcapellaPrefs.h"

#import "Sluthware/Sluthware.h"

#import <CoreGraphics/CoreGraphics.h>
#import <MediaRemote/MediaRemote.h>
//#import <MobileGestalt/MobileGestalt.h>




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

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIAttachmentBehavior *bAttachment;

@property (strong, nonatomic, readwrite) UITapGestureRecognizer *tap;
@property (strong, nonatomic, readwrite) UIPanGestureRecognizer *pan;
@property (strong, nonatomic, readwrite) UILongPressGestureRecognizer *press;

@property (strong, nonatomic) NSTimer *wrapAroundFallback;

@property (strong, nonatomic) NSMutableArray *kvoObservers;

- (void)setupKVO;
- (void)teardownKVO;

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
        
        acapella.cloneContainer.tag = SWAcapellaCloneContainerStateNone;    // Reset views and constraints
		for (UIView *viewToClone in acapella.cloneContainer.viewsToClone) {
			viewToClone.userInteractionEnabled = NO;
		}
		[acapella teardownKVO];
		
        [NSObject cancelPreviousPerformRequestsWithTarget:acapella selector:@selector(finishWrapAround) object:nil];
        [acapella.cloneContainer removeFromSuperview];
        acapella.cloneContainer = nil;
		
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
		
		for (UIGestureRecognizer *gestureRecognizer in acapella.referenceView.gestureRecognizers) {
			gestureRecognizer.enabled = NO;
		}
		
		acapella.kvoObservers = nil;
        
        [acapella.referenceView layoutSubviews];
		[acapella.referenceView setNeedsDisplay];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:onAcapellaDestroyedNotificationName()
                                                            object:acapella];
    }
    
    [SWAcapella setAcapella:nil forObject:acapella.referenceView withPolicy:OBJC_ASSOCIATION_ASSIGN];
    [SWAcapella setAcapella:nil forObject:acapella.owner withPolicy:OBJC_ASSOCIATION_RETAIN_NONATOMIC];
}

#pragma mark - Init

- (id)initWithOwner:(UIViewController<SWAcapellaDelegate> *)owner referenceView:(UIView *)referenceView viewsToClone:(NSArray<UIView *> *)viewsToClone
{
    if (self = [super init]) {
        
        self.owner = owner;
        self.referenceView = referenceView;
        
        [SWAcapella setAcapella:self forObject:self.referenceView withPolicy:OBJC_ASSOCIATION_ASSIGN];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        
        self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.referenceView];
        self.animator.delegate = self;
		
		for (UIGestureRecognizer *gestureRecognizer in referenceView.gestureRecognizers) {
			gestureRecognizer.enabled = NO;
		}
        
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
		
		self.kvoObservers = [NSMutableArray new];
        
        
        self.cloneContainer = [[SWAcapellaCloneContainer alloc] initWithViewsToClone:viewsToClone];
		for (UIView *viewToClone in self.cloneContainer.viewsToClone) {
			viewToClone.userInteractionEnabled = NO;
		}
        [self.referenceView addSubview:self.cloneContainer];
        [self.referenceView sendSubviewToBack:self.cloneContainer];
        
        
        self.cloneContainer.centerXConstraint = [NSLayoutConstraint constraintWithItem:self.cloneContainer
                                                                            attribute:NSLayoutAttributeCenterX
                                                                            relatedBy:NSLayoutRelationEqual
                                                                               toItem:self.referenceView
                                                                            attribute:NSLayoutAttributeCenterX
                                                                           multiplier:1.0
                                                                             constant:0.0];
        [self.referenceView addConstraint:self.cloneContainer.centerXConstraint];
        [self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.referenceView
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0
                                                                        constant:0.0]];
        [self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
                                                                       attribute:NSLayoutAttributeWidth
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.referenceView
                                                                       attribute:NSLayoutAttributeWidth
                                                                      multiplier:1.0
                                                                        constant:0.0]];
        [self.referenceView addConstraint:[NSLayoutConstraint constraintWithItem:self.cloneContainer
                                                                       attribute:NSLayoutAttributeHeight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.referenceView
                                                                       attribute:NSLayoutAttributeHeight
                                                                      multiplier:1.0
                                                                        constant:0.0]];
        
        [self.referenceView setNeedsLayout];
        [self.referenceView setNeedsDisplay];
        
        
        self.bAttachment = [[UIAttachmentBehavior alloc] initWithItem:self.cloneContainer attachedToAnchor:CGPointZero];
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:onAcapellaCreatedNotificationName()
                                                            object:self];
    }
    
    return self;
}

#pragma mark - KVO

static void *kvoContext_AttributedText = &kvoContext_AttributedText;
static void *kvoContext_Text = &kvoContext_Text;

- (void)setupKVO
{
	for (UIView *subview in self.cloneContainer.subviews) {
		[subview recurseSubviewsWithBlock:^(UIView *view) {
			if (view && ![self.kvoObservers containsObject:view]) {
				[self.kvoObservers addObject:view];
				[view addObserver:self forKeyPath:@"attributedText"
						  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
						  context:kvoContext_AttributedText];
				[view addObserver:self forKeyPath:@"text"
						  options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
						  context:kvoContext_Text];
				return YES;
			}
			return NO;
		}];
	}
}

- (void)teardownKVO
{
	for (UIView *kvoView in self.kvoObservers) {
		if (kvoView) {
			[kvoView removeObserver:self
						 forKeyPath:@"attributedText"
							context:kvoContext_AttributedText];
			[kvoView removeObserver:self
						 forKeyPath:@"text"
							context:kvoContext_Text];
		}
	}
	
	[self.kvoObservers removeAllObjects];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
//	SWLogMethod_Start
//	NSLog(@"arg1:[%@]", keyPath);
//	NSLog(@"arg2:[%@]", [object class]);
	
    if (self.cloneContainer.tag == SWAcapellaCloneContainerStateWaitingToFinishWrapAround) {
        
		if (context == kvoContext_AttributedText || context == kvoContext_Text) {
			
			id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
			id newValue = [change objectForKey:NSKeyValueChangeNewKey];
			
			if (oldValue && [oldValue isKindOfClass:[NSAttributedString class]]) {
				oldValue = ((NSAttributedString *)oldValue).string;
			}
			if (newValue && [newValue isKindOfClass:[NSAttributedString class]]) {
				newValue = ((NSAttributedString *)newValue).string;
			}
			
//			NSLog(@"oldValue: %@", oldValue);
//			NSLog(@"newValue: %@", newValue);
			
			if (![newValue respondsToSelector:@selector(compare:)] || ![oldValue respondsToSelector:@selector(compare:)]) {
				return;
			}
			
			if (!oldValue || (oldValue && [newValue compare:oldValue] != NSOrderedSame)) {
				[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishWrapAround) object:nil];
				[self performSelector:@selector(finishWrapAround) withObject:nil afterDelay:0.1];
			}
		}
	}
	
//	SWLogMethod_End
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (gestureRecognizer == self.tap || gestureRecognizer == self.pan) {
        if ([touch.view isKindOfClass:[UIControl class]]) {
            UIControl *control = (UIControl *)touch.view;
            return (!control.isEnabled || touch.view.layer.opacity <= 0.0);
        } else {
            if ([touch.view isKindOfClass:objc_getClass("UITableViewCellContentView")] ||
                [touch.view isKindOfClass:[UITableViewCell class]] ||
                [touch.view isKindOfClass:[UITableView class]] ||
                [touch.view isKindOfClass:[UICollectionViewCell class]] ||
                [touch.view isKindOfClass:[UICollectionView class]]) {
                return NO;
            }
        }
    }
    
    return YES;
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
	if (gestureRecognizer == self.pan) {
		
		CGPoint panVelocity = [self.pan velocityInView:self.pan.view];
        
        BOOL isHorizontal = (ABS(panVelocity.x) > ABS(panVelocity.y));
        BOOL isVertical = (ABS(panVelocity.y) > ABS(panVelocity.x));
        
        if (isVertical) {
            SEL sel = (panVelocity.y <= 0.0) ? @selector(acapella_didRecognizeVerticalPanUp:) : @selector(acapella_didRecognizeVerticalPanDown:);
            if ([self.owner respondsToSelector:sel]) {
                if (!self.cloneContainer.hidden) {
                    [self.owner performSelectorOnMainThread:sel withObject:gestureRecognizer waitUntilDone:NO];
                }
            }
        }
        
		return isHorizontal;
		
	}
	
	return YES;
}

#pragma mark - UIGestureRecognizer

- (void)onTap:(UITapGestureRecognizer *)tap
{
    CGFloat xPercentage = [tap locationInView:tap.view].x / CGRectGetWidth(tap.view.bounds);
    //CGFloat yPercentage = [tap locationInView:tap.view].y / CGRectGetHeight(tap.view.bounds);
    
    SEL sel = nil;
    
    if (xPercentage <= 0.25) { // left
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapleft]);
    } else if (xPercentage > 0.75) { // right
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapright]);
    } else { // centre
        sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_tapcentre]);
    }
    
    if (sel && [self.owner respondsToSelector:sel]) {
        if (!self.cloneContainer.hidden) {
            [self.owner performSelectorOnMainThread:sel withObject:tap waitUntilDone:NO];
        }
    }
    
    SW_PIRACY;
}

- (void)onPan:(UIPanGestureRecognizer *)pan
{
    // Don't do anything when titles view is hidden (ex when ratings view is visible)
    if (self.cloneContainer.hidden || CGRectGetWidth(self.cloneContainer.frame) == 0.0 || CGRectGetHeight(self.cloneContainer.frame) == 0.0) {
        return;
    }
    
    CGPoint panLocation = [pan locationInView:pan.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        
        self.referenceView.clipsToBounds = YES;
		[self teardownKVO];
        self.wrapAroundFallback = nil;
        [self.animator removeAllBehaviors];
        self.cloneContainer.tag = SWAcapellaCloneContainerStatePanning;
        [self.cloneContainer.layer removeAllAnimations];
        self.cloneContainer.transform = CGAffineTransformScale(self.cloneContainer.transform, 1.0, 1.0);
        self.cloneContainer.velocity = CGPointZero;
        self.bAttachment.anchorPoint = CGPointMake(panLocation.x, self.cloneContainer.center.y);
        __unsafe_unretained SWAcapella *weakSelf = self;
        self.bAttachment.action = ^{
            weakSelf.cloneContainer.centerXConstraint.constant = weakSelf.cloneContainer.center.x - CGRectGetMidX(weakSelf.referenceView.bounds);
            [weakSelf.referenceView setNeedsLayout];
        };
        
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
//                weakSelf.cloneContainer.center = CGPointMake(offScreenRightX, weakSelf.cloneContainer.center.y);
                weakSelf.cloneContainer.centerXConstraint.constant = offScreenRightX - CGRectGetMidX(weakSelf.referenceView.bounds);
                [weakSelf.referenceView setNeedsLayout];
                [weakSelf didWrapAround:-1];
                
            } else if (weakSelf.cloneContainer.center.x > offScreenRightX) {
                
                [weakSelf.animator removeAllBehaviors];
//                weakSelf.cloneContainer.center = CGPointMake(offScreenLeftX, weakSelf.cloneContainer.center.y);
                weakSelf.cloneContainer.centerXConstraint.constant = offScreenLeftX - CGRectGetMidX(weakSelf.referenceView.bounds);
                [weakSelf.referenceView setNeedsLayout];
                [weakSelf didWrapAround:1];
                
            } else {
                
                CGFloat absoluteXVelocity = ABS(weakSelf.cloneContainer.velocity.x);
                
                weakSelf.cloneContainer.centerXConstraint.constant = weakSelf.cloneContainer.center.x - CGRectGetMidX(weakSelf.referenceView.bounds);
                [weakSelf.referenceView setNeedsLayout];
                
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
        
        CGPoint location = [press locationInView:press.view];
        CGFloat xPercentage = location.x / CGRectGetWidth(press.view.bounds);
        //	CGFloat yPercentage = location.y / CGRectGetHeight(press.view.bounds);
        
        SEL sel = nil;
        
        if (xPercentage <= 0.25) { // left
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_pressleft]);
        } else if (xPercentage > 0.75) { // right
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_pressright]);
        } else { // centre
            sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_presscentre]);
        }
        
        if (sel && [self.owner respondsToSelector:sel]) {
            if (!self.cloneContainer.hidden) {
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
	if (self.cloneContainer.tag == SWAcapellaCloneContainerStatePanning) {
		
		[self setupKVO];
		
		self.wrapAroundFallback = [NSTimer scheduledTimerWithTimeInterval:0.75
																	block:^{
																		[self finishWrapAround];
																	} repeats:NO];
		
		self.cloneContainer.tag = SWAcapellaCloneContainerStateWaitingToFinishWrapAround;
		SEL sel = nil;
		
		if (direction < 0) { // left
			sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_swipeleft]);
        } else if (direction > 0) { // right
			sel = NSSelectorFromString([NSString stringWithFormat:@"%@:", self.owner.acapellaPrefs.gestures_swiperight]);
		}
		
		if (sel && [self.owner respondsToSelector:sel]) {
            if (!self.cloneContainer.hidden) {
                [self.owner performSelectorOnMainThread:sel withObject:self.pan waitUntilDone:NO];
            }
		}
	}
}

- (void)finishWrapAround
{
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
		return;
	}
	
    AUTO_RELEASE_POOL
	
    // Give text time to update
	//[[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate:[NSDate date]];
	//[self.cloneContainer refreshClones];
    
    if (self.cloneContainer.tag == SWAcapellaCloneContainerStateWaitingToFinishWrapAround) {
		
		[self teardownKVO];
		self.wrapAroundFallback = nil;
        
        self.cloneContainer.tag = SWAcapellaCloneContainerStateWrappingAround;
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
            
            weakSelf.cloneContainer.centerXConstraint.constant = weakSelf.cloneContainer.center.x - CGRectGetMidX(weakSelf.referenceView.bounds);
            [weakSelf.referenceView setNeedsLayout];
            
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
    
    AUTO_RELEASE_POOL_END
}

- (void)snapToCenter
{
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:_cmd withObject:nil waitUntilDone:NO];
		return;
	}
	
    AUTO_RELEASE_POOL
            
    if (self.cloneContainer.tag == SWAcapellaCloneContainerStatePanning ||
        self.cloneContainer.tag == SWAcapellaCloneContainerStateWrappingAround) {
        
        [self.animator removeAllBehaviors];
        self.cloneContainer.tag = SWAcapellaCloneContainerStateSnappingToCenter;
        
        UIDynamicItemBehavior *bDynamicItem = [[UIDynamicItemBehavior alloc] initWithItems:@[self.cloneContainer]];
        
        __unsafe_unretained SWAcapella *weakSelf = self;
        bDynamicItem.action = ^{
            weakSelf.cloneContainer.centerXConstraint.constant = weakSelf.cloneContainer.center.x - CGRectGetMidX(weakSelf.referenceView.bounds);
            [weakSelf.referenceView setNeedsLayout];
        };
        
        
        bDynamicItem.density = 70.0;
        bDynamicItem.resistance = 5.0;
        bDynamicItem.allowsRotation = NO;
        bDynamicItem.angularResistance = CGFLOAT_MAX;
        bDynamicItem.friction = 1.0;
        [self.animator addBehavior:bDynamicItem];
        
        CGPoint snapPoint = CGPointMake(CGRectGetMidX(self.referenceView.bounds), self.cloneContainer.center.y);
        UISnapBehavior *bSnap = [[UISnapBehavior alloc] initWithItem:self.cloneContainer snapToPoint:snapPoint];
        bSnap.damping = 0.3;
        [self.animator addBehavior:bSnap];
        
    }
    
    AUTO_RELEASE_POOL_END
}

- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    //this method will get called if we stop dragging, but still have our finger down
    //check to see if we are dragging to make sure we dont remove all behaviours
    if (self.cloneContainer.tag != SWAcapellaCloneContainerStateSnappingToCenter) {
        return;
    }
    
    [animator removeAllBehaviors];
    
    self.cloneContainer.center = CGPointMake(CGRectGetMidX(self.referenceView.bounds), self.cloneContainer.center.y);
    self.cloneContainer.centerXConstraint.constant = CGRectGetMidX(self.referenceView.bounds) - self.cloneContainer.center.x;
    [self.referenceView setNeedsLayout];
    
    self.cloneContainer.tag = SWAcapellaCloneContainerStateNone;
}

#pragma mark - NSNotificationCenter

- (void)applicationDidBecomeActive:(NSNotification *)notification
{
	// Fix for the titles view displaying the incorrect song if the song changes while the app is in the background
	[self.referenceView setNeedsLayout];
	[self.referenceView layoutIfNeeded];
	
    self.cloneContainer.centerXConstraint.constant = CGRectGetMidX(self.referenceView.bounds) - self.cloneContainer.center.x;
    [self.cloneContainer setNeedsDisplay];
	
	if (self.owner.acapellaPrefs) {
		[self.owner.acapellaPrefs refreshPrefs];
	}
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




