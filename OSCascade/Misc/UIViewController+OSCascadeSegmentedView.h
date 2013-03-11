//
//  UIViewController+CLSegmentedView.h
//  Cascade
//
//  Created by Emil Wojtaszek on 11-05-07.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OSCascadeSegmentedView;

@interface UIViewController (UIViewController_OSCascadeSegmentedView)

@property (nonatomic, retain, readonly) UIView* headerView;
@property (nonatomic, retain, readonly) UIView* footerView;
@property (nonatomic, retain, readonly) UIView* contentView;

@property (nonatomic, retain) OSCascadeSegmentedView* segmentedView;
- (void)configureForSegmentedView;  //  Called when page is pushing, and segmentedView property is already not nil

@end

