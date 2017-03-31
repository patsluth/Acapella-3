




@interface SBDashBoardScrollGestureController : NSObject // <SBSystemGestureRecognizerDelegate, BSDescriptionProviding, SBDashBoardEventHandling>
{
//    SBSystemGestureManager *_systemGestureManager;
//    SBPagedScrollView *_scrollView;
//    SBDashBoardView *_dashBoardView;
    UIGestureRecognizer /* SBScreenEdgePanGestureRecognizer */ *_screenEdgeGestureRecognizer;
    UIGestureRecognizer /* SBSwallowingGestureRecognizer */  *_swallowGestureRecognizer;
    UIGestureRecognizer *_scrollViewGestureRecognizer;
    UIGestureRecognizer /* SBHorizontalScrollFailureRecognizer */  *_horizontalFailureGestureRecognizer;
}

@property (weak, nonatomic) id /*<SBDashBoardScrollGestureControllerDelegate>*/ delegate;
@property (nonatomic) long long scrollingStrategy;

- (id)initWithDashBoardView:(id)arg1 systemGestureManager:(id)arg2;

- (void)_registerGestures:(unsigned long long)arg1;
- (void)_unregisterGestures:(unsigned long long)arg1;
- (void)_updateForScrollingStrategy:(long long)arg1 fromScrollingStrategy:(long long)arg2;

- (void)_horizontalScrollFailureGestureRecognizerChanged:(id)arg1;
- (_Bool)gestureRecognizerShouldBegin:(id)arg1;
- (_Bool)gestureRecognizer:(id)arg1 shouldBeRequiredToFailByGestureRecognizer:(id)arg2;
- (_Bool)gestureRecognizer:(id)arg1 shouldRequireFailureOfGestureRecognizer:(id)arg2;
- (_Bool)gestureRecognizer:(id)arg1 shouldRecognizeSimultaneouslyWithGestureRecognizer:(id)arg2;

@end
