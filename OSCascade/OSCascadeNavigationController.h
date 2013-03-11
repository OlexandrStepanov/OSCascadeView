//
//  OSCascadeNavigationController.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OSCascade.h"

@interface OSCascadeNavigationController : UIViewController <OSCascadeViewDataSource, OSCascadeViewDelegate> {
    // view containing all views on stack
    OSCascadeView* _cascadeView;
}

@property (nonatomic, strong, readonly) OSCascadeView* cascadeView;


/*
 * Set and push root view controller
 */
- (void) setRootViewController:(UIViewController*)viewController
                     withWidth:(float)pageWidth
                      animated:(BOOL)animated;

/*
 * Push new view controller from sender.
 * If sender is not last, then controller pop next controller and push new view from sender
 */
- (void) addViewController:(UIViewController*)viewController
                    sender:(UIViewController*)sender
                 withWidth:(float)pageWidth
                  animated:(BOOL)animated;

/*
 * Remove all from navigation
 */
- (void)popAllViewControllers:(BOOL)animated;

/*
 First in hierarchy CascadeViewController (opposite to lastCascadeViewController)
 */
- (UIViewController*) rootViewController;

/*
 Last in hierarchy CascadeViewController (opposite to rootViewController)
 */
- (UIViewController*) lastCascadeViewController;

/*
 Return first visible view controller (load if needed)
 */
- (UIViewController*) firstVisibleViewController;


@end


@protocol OSCascadeNavigationControllerDelegate <NSObject>

@optional
- (void) didAddViewController:(UIViewController*)pageController;
- (void) didPopViewController:(UIViewController*)pageController;

@end
