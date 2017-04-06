//
//  SBLockScreenHintManager.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-12-27.
//  Copyright (c) 2015 Pat Sluth. All rights reserved.
//

@import UIKit;
@import Foundation;





#import "SBDashBoardScrollGestureController.h"

#import "SWAcapella.h"

#import "Sluthware/Sluthware.h"





%hook SBDashBoardScrollGestureController

- (id)initWithDashBoardView:(id)arg1 systemGestureManager:(id)arg2
{
    if ((self = %orig())) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAcapellaCreated:)
                                                     name:onAcapellaCreatedNotificationName()
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onAcapellaDestroyed:)
                                                     name:onAcapellaDestroyedNotificationName()
                                                   object:nil];
    }
    
    return self;
}

- (void)_horizontalScrollFailureGestureRecognizerChanged:(id)arg1
{
//	SWLogMethod_Start
//	NSLog(@"arg1: %@", [arg1 class]);
//	SWLogMethod_End
	
	%orig(arg1);
}

- (_Bool)gestureRecognizerShouldBegin:(id)arg1
{
	//id x = [SWAcapella acapellaForObject:self];
	
//	SWLogMethod_Start
//	NSLog(@"arg1: %@", [arg1 class]);
//	//NSLog(@"arg2: %@", x);
//	SWLogMethod_End
	
	return %orig(arg1);
}

- (_Bool)gestureRecognizer:(id)arg1 shouldBeRequiredToFailByGestureRecognizer:(id)arg2
{
//	SWLogMethod_Start
//	NSLog(@"arg1: %@", [arg1 class]);
//	NSLog(@"arg1: %@", [arg2 class]);
//	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

- (_Bool)gestureRecognizer:(id)arg1 shouldRequireFailureOfGestureRecognizer:(id)arg2
{
//	SWLogMethod_Start
//	NSLog(@"arg1: %@", [arg1 class]);
//	NSLog(@"arg1: %@", [arg2 class]);
//	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

- (_Bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2
{
//	SWLogMethod_Start
//	NSLog(@"arg1: %@", [arg1 class]);
//	NSLog(@"arg1: %@", [arg2 class]);
//	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

%new
- (void)onAcapellaCreated:(NSNotification *)notification
{
    SWLogMethod_Start
    SWLogMethod_End
    
    AUTO_RELEASE_POOL

    if ([notification.object isKindOfClass:[SWAcapella class]]) {
		
        SWAcapella *acapella = notification.object;
        UIGestureRecognizer *gestureRecognizer;
		
		
//		[SWAcapella setAcapella:acapella forObject:self withPolicy:OBJC_ASSOCIATION_ASSIGN];
		
		
        
        gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_screenEdgeGestureRecognizer");
		[gestureRecognizer requireGestureRecognizerToFail:acapella.tap];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.press];
		
		gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_swallowGestureRecognizer");
		[gestureRecognizer requireGestureRecognizerToFail:acapella.tap];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.press];
		
		gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_scrollViewGestureRecognizer");
		[gestureRecognizer requireGestureRecognizerToFail:acapella.tap];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.press];
		
		gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_horizontalFailureGestureRecognizer");
		[gestureRecognizer requireGestureRecognizerToFail:acapella.tap];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
		[gestureRecognizer requireGestureRecognizerToFail:acapella.press];
    }
    
    AUTO_RELEASE_POOL_END
}

%new
- (void)onAcapellaDestroyed:(NSNotification *)notification
{
}

%end





%ctor
{
    
}




