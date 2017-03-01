//
//  SWAcapellaCloneContainer.h
//  testtest
//
//  Created by Pat Sluth on 2017-02-27.
//  Copyright © 2017 patsluth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWAcapellaCloneContainer : UIView

- (id)initWithViewsToClone:(NSArray<UIView *> *)viewsToClone;

@property (strong, nonatomic, readonly) NSArray<UIView *> *viewsToClone;
@property (nonatomic) CGPoint velocity;

@end
