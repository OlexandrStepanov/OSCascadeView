//
//  OSCascadeSplitViewController.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "OSCascadeSplitViewController.h"
#import "OSCascade.h"

@interface OSCascadeSplitViewController ()

@end

@implementation OSCascadeSplitViewController

- (id) initWithNavigationController:(OSCascadeNavigationController*)navigationController {
    self = [super init];
    if (self) {
        self.cascadeNavigationController = navigationController;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


#pragma mark - View lifecycle

- (void) loadView {
    NSString *nib = self.nibName;
    if (nib) {
        NSBundle *bundle = self.nibBundle;
        if(!bundle) bundle = [NSBundle mainBundle];
        
        NSString *path = [bundle pathForResource:nib ofType:@"nib"];
        
        if(path) {
            self.view = [[bundle loadNibNamed:nib owner:self options:nil] objectAtIndex: 0];
            OSCascadeSplitView* view_ = (OSCascadeSplitView*)self.view;
            [view_ setCategoriesView: self.categoriesViewController.view];
            [view_ setCascadeView: self.cascadeNavigationController.view];
            
            return;
        }
    }
    
    OSCascadeSplitView* view_ = [[OSCascadeSplitView alloc] init];
    self.view = view_;
    
    [view_ setCategoriesView: self.categoriesViewController.view];
    [view_ setCascadeView: self.cascadeNavigationController.view];
    [view_ setSplitCascadeViewController:self];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    
    self.cascadeNavigationController = nil;
    self.categoriesViewController = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    if ([_cascadeNavigationController respondsToSelector:@selector(willAnimateRotationToInterfaceOrientation:duration:)]) {
        [_cascadeNavigationController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
    }
}

#pragma mark -
#pragma mark Class methods

- (void) setDividerImage:(UIImage*)image {
    [(OSCascadeSplitView*)self.view setVerticalDividerImage: image];
}


#pragma mark -
#pragma mark Setters

- (void) setCategoriesViewController:(UIViewController *)viewController {
    if (viewController != _categoriesViewController) {
        _categoriesViewController = viewController;
        [(OSCascadeSplitView*)self.view setCategoriesView:viewController.view];
        
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
}


- (void) setCascadeNavigationController:(OSCascadeNavigationController *)viewController {
    if (viewController != _cascadeNavigationController) {
        _cascadeNavigationController = viewController;
        [(OSCascadeSplitView*)self.view setCascadeView:viewController.view];
        
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
}

- (void)setBackgroundViewController:(UIViewController *)viewController {
    if (viewController != _backgroundViewController) {
        _backgroundViewController = viewController;
        [(OSCascadeSplitView*)self.view setBackgroundView: _backgroundViewController.view];
        
        [self addChildViewController:viewController];
        [viewController didMoveToParentViewController:self];
    }
}


@end
