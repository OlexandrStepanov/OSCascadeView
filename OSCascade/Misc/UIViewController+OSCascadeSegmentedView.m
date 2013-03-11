//
//  UIViewController+CLSegmentedView.m
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+OSCascadeSegmentedView.h"
#import "OSCascade.h"


@implementation UIViewController (UIViewController_OSCascadeSegmentedView)

@dynamic segmentedView;
@dynamic headerView;
@dynamic footerView;
@dynamic contentView;


///////////////////////////////////////////////////////////////////////////////////////////////////
- (OSCascadeSegmentedView*) segmentedView {
    UIView *contentView = [self.view superview];
    OSCascadeSegmentedView *result = (OSCascadeSegmentedView*)[contentView superview];
    return ([result isKindOfClass:[OSCascadeSegmentedView class]] ? result : nil);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) headerView {

    if (!self.segmentedView)
        return nil;
    
    OSCascadeSegmentedView* view_ = (OSCascadeSegmentedView*)self.segmentedView;
    return view_.headerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) footerView {

    if (!self.segmentedView)
        return nil;
    
    OSCascadeSegmentedView* view_ = (OSCascadeSegmentedView*)self.segmentedView;
    return view_.footerView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIView*) contentView {
    if (!self.segmentedView)
        return nil;

    OSCascadeSegmentedView* view_ = (OSCascadeSegmentedView*)self.segmentedView;
    return view_.contentView;
}

- (void)configureForSegmentedView {
    
}

@end
