//
//  OSCascadeSegmentedView.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OSCascadeSegmentedView : UIView {
    
    UIView* _headerView;
    UIView* _footerView;
    UIView* __weak _contentView;
    UIView* _roundedCornersView;
    
    UIView* _shadowViewLeft;
    UIView* _shadowViewRight;
    
    BOOL _showRoundedCorners;
    UIRectCorner _rectCorner;
}

/*
 * Header view - located on the top of view
 */
@property (nonatomic, strong) IBOutlet UIView* headerView;

/*
 * Footer view - located on the bottom of view
 */
@property (nonatomic, strong) IBOutlet UIView* footerView;

/*
 * Content view - located between header and footer view
 */
@property (nonatomic, weak) IBOutlet UIView* contentView;

/*
 * The width of the shadow
 */
@property (nonatomic, assign) CGFloat shadowWidth;

/*
 * The offset of the shadow in X-axis. Default 0.0
 */
@property (nonatomic, assign) CGFloat shadowOffset;

/*
 * Set YES if you want rounded corners. Default NO.
 */
@property (nonatomic, assign) BOOL showRoundedCorners;

/*
 * Type of rect corners. Default UIRectCornerAllCorners.
 */
@property (nonatomic, assign) UIRectCorner rectCorner;

/*
 * Returns view's load status within container's hierarchy
 */
@property (nonatomic, readonly) BOOL isLoaded;

/*
 * Specify what shadows have this view
 */
@property (nonatomic) BOOL haveLeftShadow;
@property (nonatomic) BOOL haveRightShadow;


@end
