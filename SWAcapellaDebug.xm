//
//  SWAcapellaDebug.xm
//  Acapella3
//
//  Created by Pat Sluth on 2015-12-27.
//  Copyright © 2016 Pat Sluth. All rights reserved.
//

#import "SWAcapella.h"

#import "Sluthware/Sluthware.h"

#import <objc/runtime.h>







//%hook SBDashBoardViewController
//
////- (BOOL)allowSystemGestureAtLocation:(CGPoint)arg1
////{
////	SWLogMethod_Start
////	NSLog(@"arg1:[%@]", NSStringFromCGPoint(arg1));
////	SWLogMethod_End
////
////	return %orig(arg1);
////}
//
//- (NSString *)description
//{
//	return @"pat";
//}
//
//%end
//
//
//
//%hook SBDashBoardScrollModifier
//
//(void)scrollViewWillEndDragging:(id)arg1
//withVelocity:(CGPoint)arg2
//targetContentOffset:(inout CGPoint *)arg3
//{
//	SWLogMethod_Start
//	SWLogMethod_End
//	
//	%orig;
//}
//
//- (CGPoint)scrollView:(id)arg1
//adjustedOffsetForOffset:(CGPoint)arg2
//translation:(CGPoint)arg3
//startPoint:(CGPoint)arg4
//locationInView:(CGPoint)arg5
//horizontalVelocity:(inout double *)arg6
//verticalVelocity:(inout double *)arg7
//{
//	SWLogMethod_Start
//	SWLogMethod_End
//	
//	%orig;
//}
//
//- (void)scrollViewWillBeginDragging:(id)arg1
//{
//	SWLogMethod_Start
//	SWLogMethod_End
//	
//	%orig(arg1);
//}
//
//- (BOOL)recognized
//{
//	SWLogMethod_Start
//	SWLogMethod_End
//	
//	return NO;//%orig();
//}
//
//%end







%hook SBLockScreenView

//- (void)presentingController:(id)arg1 willHandleGesture:(id)arg2
//{
//	
//}

- (_Bool)presentingController:(id)arg1 gestureRecognizerShouldBegin:(id)arg2
{
	SWLogMethod_Start
	NSLog(@"arg1:[%@]", arg1);
	NSLog(@"arg2:[%@]", arg2);
	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

- (_Bool)presentingController:(id)arg1 gestureRecognizer:(id)arg2 shouldReceiveTouch:(id)arg3
{
	SWLogMethod_Start
	NSLog(@"arg1:[%@]", arg1);
	NSLog(@"arg2:[%@]", arg2);
	NSLog(@"arg3:[%@]", arg3);
	SWLogMethod_End
	
	return %orig(arg1, arg2, arg3);
}

//- (void)reenableGestureRecognizer:(id)arg1;
//- (void)cancelGestureRecognizer:(id)arg1;

%end




%hook SBLockScreenViewController

- (BOOL)gestureRecognizerShouldBegin:(id)arg1
{
	SWLogMethod_Start
	NSLog(@"arg1:[%@]", arg1);
	SWLogMethod_End
	
	return %orig(arg1);
}

- (BOOL)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2
{
	SWLogMethod_Start
	NSLog(@"arg1:[%@]", arg1);
	NSLog(@"arg2:[%@]", arg2);
	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

- (BOOL)gestureRecognizer:(id)arg1 shouldReceiveTouch:(id)arg2
{
	SWLogMethod_Start
	NSLog(@"arg1:[%@]", arg1);
	NSLog(@"arg2:[%@]", arg2);
	SWLogMethod_End
	
	return %orig(arg1, arg2);
}

%end









//
//%hook SBUIController
//
//- (BOOL)promptUnlockForAppActivation:(id)arg1 withCompletion:(id)arg2
//{
//	SWLogMethod_Start
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", arg2);
//	SWLogMethod_End
//
//
//
//
//
//
//
//	return %orig(arg1, arg2);
//}
//
//%end
//
//%hook SBLockScreenManager
//
//- (BOOL)unlockWithRequest:(id)arg1 completion:(/*^block*/id)arg2
//{
//	SWLogMethod_Start
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", arg2);
//	SWLogMethod_End
//	
//	for (int i = 0; i < 10; i += 1) {
//		SBLockScreenUnlockRequest *a = [%c(SBLockScreenUnlockRequest) new];
//		a.source = i;
//		a.intent = i;
//		NSLog(@"aaaa:[%@]", arg1);
//	}
//	
//	return %orig(arg1, arg2);
//}
//
//%end


//
//
//
//%hook SBMainWorkspace
//
//- (BOOL)_attemptUnlockToApplication:(id)arg1 showPasscode:(BOOL)arg2 origin:(id)arg3 completion:(/*^block*/id)arg4
//{
//	SWLogMethod_Start
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", arg3);
//	NSLog(@"arg4:[%@]", arg4);
//	SWLogMethod_End
//	
//	
//
//	
//	return %orig(arg1, arg2, arg3, arg4);
//}
//
//%end




//%hook CCUIControlCenterLabel
//
//- (void)setText:(id)arg1
//{
//	%orig(arg1);
//	
//	SWLogMethod_Start
//	NSLog(@"arg1:[%@]", arg1);
//	SWLogMethod_End
//}
//
//%end




//@interface NSObject (Private)
//    -(id)_ivarDescription;
//    -(id)_shortMethodDescription;
//    -(id)_methodDescription;
//@end
//
//
//
//
//
//
//@interface _TtC5Music8SongCell : NSObject
//
//- (id)_viewControllerForAncestor;
//
//@end
//
//@interface _TtGC5Music30BrowseCollectionViewControllerCSo16UICollectionView_ : UIViewController
//
//@end
//
//@interface _TtC5Music19SongsViewController : UIViewController
//
//@end
//
//
//
//%hook _TtC5Music8SongCell
//
//- (void)setTitle:(id)arg1
//{
//    
//    
//    
//    
//}
//
//- (void)touchesBegan:(id)touches withEvent:(id)event
//{
////    id vc = [self _viewControllerForAncestor];
////    NSLog(@"PAT %@", vc);
////    NSLog(@"PAT %s", object_getClassName(vc));
////    
////    NSBundle *b = [NSBundle bundleForClass:[vc class]];
////    
////    NSLog(@"PAT %@", b);
////    //NSLog(@"PAT %@", b.sharedFrameworksURL);
////    //NSLog(@"PAT %@", b.privateFrameworksURL);
////    //NSLog(@"PAT %@", [NSBundle allFrameworks]);
////    
////    
////    
////    
////    NSLog(@"PAT %@", %c(_TtGC5Music30BrowseCollectionViewControllerCSo16UICollectionView_));
////    NSLog(@"PAT %@", %c(_TtC5Music19SongsViewController));
////    
////    
////    
////    TRY
////    
////    NSLog(@"PAT 2 %@", [(NSObject *)vc _ivarDescription]);
////    NSLog(@"PAT 3 %@", [(NSObject *)vc _methodDescription]);
////    
////   
////    
////    CATCH_LOG
////    TRY_END
////    
////    
////     NSLog(@"PAT 4 %s", @encode(typeof(vc)));
//    
//    
//    
//    
//    
//    %orig(touches, event);
//}
//
//%end







/*
%hook _TtC5Music19SongsViewController

- (void)viewWillAppear:(BOOL)arg1
{
    NSLog(@"PAT viewWillAppear %@", [self class]);
    
    %orig(arg1);
}

- (void)configure:(id)arg1 forItem:(id)arg2 at:(id)arg3
{
    SWLogMethod_Start
    NSLog(@"arg1:[%@]", arg1);
    NSLog(@"arg2:[%@]", arg2);
    NSLog(@"arg3:[%@]", arg3);
    SWLogMethod_End
    
    %orig(arg1, arg2, arg3);
}

+ (id)songProperties
{
    id returnVal = %orig();
    
    SWLogMethod_Start
    NSLog(@"returnVal:[%@]", returnVal);
    SWLogMethod_End
    
    return returnVal;
}

%end
*/



//@interface UIViewController ()
//- (id)modelResponse;
//
//@end
//
//%hook UIViewController
//
//- (void)viewWillAppear:(BOOL)arg1
//{
//    NSLog(@"PAT viewWillAppear %@", [self class]);
//    
//    TRY
//        NSLog(@"%@", [self modelResponse]);
//    CATCH_LOG
//    TRY_END
//    
//    %orig(arg1);
//}
//
//- (void)collectionView:(id)arg1 willDisplayCell:(id)arg2 forItemAtIndexPath:(id)arg3
//{
//    if ([self class] == objc_getClass("Music.SongsViewController")) {
//        SWLogMethod_Start
//        NSLog(@"arg1:[%@]", arg1);
//        NSLog(@"arg2:[%@]", arg2);
//        NSLog(@"arg3:[%@]", arg3);
//        SWLogMethod_End
//    }
//    
//    
//    
//    %orig(arg1, arg2, arg3);
//}
//
//%end






// WORKING!!!!
/*

%hook AnyRandomNameHere

- (void)viewWillAppear:(BOOL)arg1
{
    NSLog(@"PAT viewWillAppear %@", [self class]);
    
    %orig(arg1);
}

%end

%ctor {
    %init(AnyRandomNameHere = objc_getClass("Music.MiniPlayerViewController"));
}

*/









//%hook AnyRandomNameHere
//
//- (void)configure:(id)arg1 forItem:(id)arg2 at:(id)arg3
//{
//    SWLogMethod_Start
//    NSLog(@"arg1:[%@]", arg1);
//    NSLog(@"arg2:[%@]", arg2);
//    NSLog(@"arg3:[%@]", arg3);
//    SWLogMethod_End
//    
//    %orig(arg1, arg2, arg3);
//}
//
//%end
//
//%ctor {
//    %init(AnyRandomNameHere = objc_getClass("Music.JSMenuViewController"));
//    
//    
//    NSLog(@"PAT PAT %@", objc_getClass("Music.SongsViewController"));
//}















//@interface _TtC5Music32CompositeCollectionViewCountData : NSObject
//{
//    id componentGroups;
//}
//
//@end
//
//@interface _TtC5Music33CompositeCollectionViewController : UICollectionViewController
//{
//    _TtC5Music32CompositeCollectionViewCountData *countData;
//}
//
//@end
//
//
//%hook _TtC5Music33CompositeCollectionViewController
//
//- (void)viewDidAppear:(BOOL)animated
//{
//    %orig(animated);
//    
//    LOG_METHOD_START
//    _TtC5Music32CompositeCollectionViewCountData *countData = MSHookIvar<_TtC5Music32CompositeCollectionViewCountData *>(self, "countData");
//    NSLog(@"countData:[%@]", countData);
//    id componentGroups = MSHookIvar<id>(countData, "componentGroups");
//    NSLog(@"componentGroups:[%@]", componentGroups);
//    LOG_METHOD_END
//}
//
//%end










//%hook UIPreviewForceInteractionProgress
//
//- (id)_initWithObservable:(id)arg1 targetState:(int)arg2 minimumRequiredState:(int)arg3
//{
//	id orig = %orig(arg1, arg2, arg3);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", @(arg3));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (id)_initWithObservable:(id)arg1 targetState:(int)arg2 minimumRequiredState:(int)arg3 useLinearClassifier:(BOOL)arg4
//{
//	id orig = %orig(arg1, arg2, arg3, arg4);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", @(arg3));
//	NSLog(@"arg4:[%@]", @(arg3));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (id)_initWithView:(id)arg1 targetState:(int)arg2 minimumRequiredState:(int)arg3 useLinearClassifier:(BOOL)arg4
//{
//	id orig = %orig(arg1, arg2, arg3, arg4);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", @(arg3));
//	NSLog(@"arg4:[%@]", @(arg4));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//
//	return orig;
//}
//
//- (id)initWithView:(id)arg1 targetState:(int)arg2
//{
//	id orig = %orig(arg1, arg2);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (id)initWithView:(id)arg1 targetState:(int)arg2 minimumRequiredState:(int)arg3
//{
//	id orig = %orig(arg1, arg2, arg3);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", @(arg3));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (id)initWithGestureRecognizer:(id)arg1 minimumRequiredState:(long long)arg2
//{
//	id orig = %orig(arg1, arg2);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (void)_forceLevelClassifier:(id)arg1 didUpdateProgress:(double)arg2 toForceLevel:(long long)arg3
//{
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	NSLog(@"arg3:[%@]", @(arg3));
//	LOG_METHOD_END
//	
//	%orig(arg1, arg2, arg3);
//}
//
//- (void)_forceLevelClassifier:(id)arg1 currentForceLevelDidChange:(int)arg2
//{
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	
//	
//	
//	LOG_METHOD_END
//	
//	%orig(arg1, arg2);
//}
//
//- (void)_forceLevelClassifierDidReset:(id)arg1
//{
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	LOG_METHOD_END
//	
//	%orig(arg1);
//}
//
//%end





//%hook UIPreviewInteractionController
//
//- (id)init
//{
//	id orig = %orig();
//	
//	LOG_METHOD_START
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (void)initGestureRecognizers
//{
//	%orig();
//	
//	LOG_METHOD_START
//	LOG_METHOD_END
//}
//
//- (void)interactionProgressDidUpdate:(id)arg1
//{
//	%orig();
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	LOG_METHOD_END
//}
//
//- (BOOL)_previewingIsPossibleForView:(id)arg1
//{
//	BOOL orig = %orig(arg1);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"retunVal:[%@]", NSStringFromBool(orig));
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (BOOL)startInteractivePreviewAtLocation:(CGPoint)arg1 inView:(id)arg2
//{
//	BOOL orig = %orig(arg1, arg2);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", NSStringFromCGPoint(arg1));
//	NSLog(@"arg2:[%@]", arg2);
//	NSLog(@"retunVal:[%@]", NSStringFromBool(orig));
//	LOG_METHOD_END
//	
//	return orig;
//
//}
//
//- (BOOL)startInteractivePreviewWithGestureRecognizer:(id)arg1
//{
//	BOOL orig = %orig(arg1);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"retunVal:[%@]", NSStringFromBool(orig));
//	LOG_METHOD_END
//	
//	return orig;
//}
//
//- (void)setTouchSelectionWorkaroundSnapshotView:(UIView *)arg1
//{
//	%orig();
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	LOG_METHOD_END
//}
//
//- (id)_insertTouchSelectionWorkaroundSnapshotViewToView:(id)arg1 presentationController:(id)arg2
//{
//	id orig = %orig(arg1, arg2);
//	
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", arg2);
//	NSLog(@"retunVal:[%@]", orig);
//	LOG_METHOD_END
//	
//	return nil;
//}
//
//%end





// Disable snapshot effects
//%hook UIPreviewPresentationController
//
//+ (BOOL)_shouldApplyVisualEffectsToPresentingView
//{
//	LOG_METHOD_START
//	return NO;
//}
//
//- (BOOL)_shouldDisableInteractionDuringTransitions
//{
//	LOG_METHOD_START
//	return YES;
//}
//
//- (BOOL)_shouldSavePresentedViewControllerForStateRestoration
//{
//	LOG_METHOD_START
//	return NO;
//}
//
//- (BOOL)_sourceViewSnapshotAndScaleTransformSuppressed
//{
//	LOG_METHOD_START
//	return YES;
//}
//
//%end





//%hook _UIPreviewTransitionController
//
//+(void)performCommitTransitionWithDelegate:(id)arg1
//forViewController:(id)arg2
//previewViewController:(id)arg3
//previewInteractionController:(id)arg4
//completion:(/*^block*/id)arg5
//{
//	
//}
//
//%end





//%hook MusicNowPlayingViewController
//
//- (void)transportControlsView:(id)arg1 tapOnControlType:(NSInteger)arg2
//{
//	LOG_METHOD_START
//	NSLog(@"arg1:[%@]", arg1);
//	NSLog(@"arg2:[%@]", @(arg2));
//	LOG_METHOD_END
//	
//    %orig(arg1, arg2);
//}
//
//%end




