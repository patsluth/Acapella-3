//
//  SBLockScreenHintManager.xm
//  Acapella2
//
//  Created by Pat Sluth on 2015-12-27.
//
//

@import UIKit;
@import Foundation;




@interface SBLockScreenViewController

- (BOOL)gestureRecognizerShouldBegin:(id)arg1;
- (BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;
- (BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2;
- (BOOL)allowSystemGestureAtLocation:(struct CGPoint)arg1;

@end

%hook SBLockScreenViewController

- (BOOL)gestureRecognizerShouldBegin:(id)arg1
{
    NSLog(@"PAT SEX 1 %@", arg1);
    
    return %orig(arg1);
}

- (BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2
{
    NSLog(@"PAT SEX 2 %@", arg1);
    NSLog(@"PAT SEX 2 %@", arg2);
    
    return %orig(arg1, arg2);
}

- (BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2
{
    NSLog(@"PAT SEX 3 %@", arg1);
    
    return %orig(arg1, arg2);
}

- (BOOL)allowSystemGestureAtLocation:(struct CGPoint)arg1
{
    NSLog(@"PAT SEX 4");
    
    return %orig(arg1);
}

%end




















%hook SBLockScreenView

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)arg1 shouldReceiveTouch:(UITouch *)arg2
{
    NSLog(@"PAT SEX 111 %@", arg1);
    
    if ([arg2.view isKindOfClass:%c(MPUMediaRemoteViewController)]) {
        return NO;
    }
    
    return %orig(arg1, arg2);
}

- (BOOL)presentingController:(id)arg1 gestureRecognizerShouldBegin:(id)arg2
{
    NSLog(@"PAT SEX 222 %@", arg1);
    NSLog(@"PAT SEX 222 %@", arg2);
    
//    if ([arg3.view isKindOfClass:%c(MPUMediaRemoteViewController)]) {
//        return NO;
//    }
    
    return %orig(arg1, arg2);
}

- (BOOL)presentingController:(id)arg1 gestureRecognizer:(UIGestureRecognizer *)arg2 shouldReceiveTouch:(UITouch *)arg3
{
    NSLog(@"PAT SEX 333 %@", arg1);
    NSLog(@"PAT SEX 333 %@", arg2);
    
    if ([arg3.view isKindOfClass:%c(MPUMediaRemoteViewController)]) {
        return NO;
    }
    
    return %orig(arg1, arg2, arg3);
}

%end



















%hook SBLockScreenManager

- (BOOL)presentingController:(id)arg1 gestureRecognizer:(UIGestureRecognizer *)arg2 shouldReceiveTouch:(UITouch *)arg3
{
    NSLog(@"PAT SEX 5 %@", arg1);
    
    if ([arg3.view isKindOfClass:%c(MPUMediaRemoteViewController)]) {
        return NO;
    }
    
    return %orig(arg1, arg2, arg3);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)arg1 shouldReceiveTouch:(UITouch *)arg2
{
    NSLog(@"PAT SEX 6 %@", arg1);
    
    if ([arg2.view isKindOfClass:%c(MPUMediaRemoteViewController)]) {
        return NO;
    }
    
    return %orig(arg1, arg2);
}

%end




%ctor //syncronize acapella default prefs
{
}
