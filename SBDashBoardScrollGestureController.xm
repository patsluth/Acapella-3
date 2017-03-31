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

%new
- (void)onAcapellaCreated:(NSNotification *)notification
{
    SWLogMethod_Start
    SWLogMethod_End
    
    AUTO_RELEASE_POOL

    if ([notification.object isKindOfClass:[SWAcapella class]]) {
        SWAcapella *acapella = notification.object;
        UIGestureRecognizer *gestureRecognizer;
        
        gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_screenEdgeGestureRecognizer");
        [gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
        
        gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_swallowGestureRecognizer");
        [gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
        
        gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_scrollViewGestureRecognizer");
        [gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
        
        gestureRecognizer = MSHookIvar<UIGestureRecognizer *>(self, "_horizontalFailureGestureRecognizer");
        [gestureRecognizer requireGestureRecognizerToFail:acapella.pan];
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




