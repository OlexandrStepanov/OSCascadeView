//
//  UIViewController+OSCascade.m
//  Cascade
//
//  Created by Błażej Biesiada on 5/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+OSCascade.h"
#import "OSCascade.h"

@implementation UIViewController (OSCascade)

///////////////////////////////////////////////////////////////////////////////////////////////////
- (OSCascadeSplitViewController *)splitCascadeViewController {
    UIViewController *parent = self.parentViewController;
    
    if ([parent isKindOfClass:[OSCascadeSplitViewController class]]) {
        return (OSCascadeSplitViewController*)parent;
    }
    else if (parent) {
        return parent.splitCascadeViewController;
    }
    else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (OSCascadeNavigationController *)cascadeNavigationController {
    UIViewController *parent = self.parentViewController;
    
    if ([parent isKindOfClass:[OSCascadeNavigationController class]]) {
        return (OSCascadeNavigationController *)parent;
    }
    else if (parent) {
        return parent.cascadeNavigationController;
    }
    else {
        return nil;
    }
}

@end
