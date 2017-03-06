//
//  SBLockScreenHintManager.xm
//  Acapella2
//
//  Created by Pat Sluth on 2015-12-27.
//
//

@import UIKit;
@import Foundation;





#import "SBDashBoardScrollGestureController.h"

#import "SWAcapella.h"

#import "libsw/libSluthware/libSluthware.h"





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
    LOG_METHOD_START
    LOG_METHOD_END
    
    @autoreleasepool {

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
    
    }
}

%new
- (void)onAcapellaDestroyed:(NSNotification *)notification
{
}

%end





%ctor
{
}




