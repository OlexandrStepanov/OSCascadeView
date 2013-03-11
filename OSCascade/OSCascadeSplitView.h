//
//  OSCascadeSplitView.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCascadeSplitViewController;
@interface OSCascadeSplitView : UIView {
    UIView* _categoriesView;
    UIView* _cascadeView;
    
    // background
    UIView*     _backgroundView;
    
    // divider
    UIView*     _dividerView;
    UIImage*    _verticalDividerImage;
    CGFloat     _dividerWidth;
}

@property (nonatomic, strong) OSCascadeSplitViewController* splitCascadeViewController;

/*
 * Divider image - image between categories and cascade view
 */
@property (nonatomic, strong) UIImage* verticalDividerImage;

/*
 * Background view - located under cascade view
 */
@property (nonatomic, strong) UIView* backgroundView;

/*
 * Categories view - located on the left, view containing table view
 */
@property (nonatomic, strong) UIView* categoriesView;

/*
 * Cascade content navigator - located on the right, view containing cascade view controllers
 */
@property (nonatomic, strong) UIView* cascadeView;

@end
