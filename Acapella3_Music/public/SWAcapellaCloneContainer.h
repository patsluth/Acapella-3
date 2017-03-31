//
//  SWAcapellaCloneContainer.h
//  testtest
//
//  Created by Pat Sluth on 2017-02-27.
//  Copyright © 2017 patsluth. All rights reserved.
//

#import <UIKit/UIKit.h>





typedef NS_ENUM(NSInteger, SWAcapellaCloneContainerState) {
    SWAcapellaCloneContainerStateNone,
    SWAcapellaCloneContainerStatePanning,
    SWAcapellaCloneContainerStateWaitingToFinishWrapAround,
    SWAcapellaCloneContainerStateWrappingAround,
    SWAcapellaCloneContainerStateSnappingToCenter,
    SWAcapellaCloneContainerStateAnimating
};





@interface SWAcapellaCloneContainer : UIView

- (id)initWithViewsToClone:(NSArray<UIView *> *)viewsToClone;

@property (strong, nonatomic, readonly) NSArray<UIView *> *viewsToClone;
@property (strong, nonatomic) NSLayoutConstraint *centerXConstraint;
@property (nonatomic) CGPoint velocity;

- (void)refreshClones;

@end
