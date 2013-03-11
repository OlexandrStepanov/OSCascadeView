//
//  OSCascadeSplitViewController.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCascadeNavigationController;
@interface OSCascadeSplitViewController : UIViewController {
    UIViewController*               _categoriesViewController;
    OSCascadeNavigationController*  _cascadeNavigationController;
    UIViewController*               _backgroundViewController;
}

@property (nonatomic, strong) IBOutlet UIViewController* categoriesViewController;
@property (nonatomic, strong) IBOutlet UIViewController* backgroundViewController;
@property (nonatomic, readonly) OSCascadeNavigationController* cascadeNavigationController; 

- (id) initWithNavigationController:(OSCascadeNavigationController*)navigationController;

- (void) setDividerImage:(UIImage*)image;


@end
