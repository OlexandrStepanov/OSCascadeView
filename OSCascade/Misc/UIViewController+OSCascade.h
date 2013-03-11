//
//  UIViewController+OSCascade.h
//  Cascade
//
//  Created by Błażej Biesiada on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OSCascadeNavigationController;
@class OSCascadeSplitViewController;

@interface UIViewController (OSCascade)

@property(nonatomic, readonly, retain) OSCascadeSplitViewController *splitCascadeViewController;
@property(nonatomic, readonly, retain) OSCascadeNavigationController *cascadeNavigationController;

@end
