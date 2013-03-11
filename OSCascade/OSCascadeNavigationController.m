//
//  OSCascadeNavigationController.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "OSCascadeNavigationController.h"

@interface OSCascadeNavigationController()

//- (void) addPagesRoundedCorners;
//- (void) addRoundedCorner:(UIRectCorner)rectCorner toPageAtIndex:(NSInteger)index;
- (void) popPagesFromLastIndexTo:(NSInteger)toIndex animated:(BOOL)animated;

@end

@implementation OSCascadeNavigationController


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)loadView {
    _cascadeView = [[OSCascadeView alloc] initWithFrame:CGRectZero];
    _cascadeView.delegate = (id<OSCascadeViewDelegate>)self;
    _cascadeView.dataSource = (id<OSCascadeViewDataSource>)self;
    
    self.view = _cascadeView;
    [self.view setBackgroundColor: [UIColor clearColor]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [_cascadeView removeFromSuperview];
    _cascadeView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


- (void)willAnimateRotationToInterfaceOrientation:( UIInterfaceOrientation )interfaceOrientation
                                         duration:( NSTimeInterval )duration {
    [_cascadeView updateContentLayoutToInterfaceOrientation:interfaceOrientation
                                                   duration:duration ];
}


#pragma mark -
#pragma mark Setters & getters


#pragma mark -
#pragma marl test

- (UIViewController*) rootViewController {
    if ([self.childViewControllers count] > 0) {
        return [self.childViewControllers objectAtIndex: 0];
    }
    return nil;
}


- (UIViewController*) lastCascadeViewController {
    return [self.childViewControllers lastObject];
}

- (UIViewController*) firstVisibleViewController {
    NSInteger index = [_cascadeView indexOfFirstVisibleView];
    
    if (index != NSNotFound) {
        return [self.childViewControllers objectAtIndex: index];
    }
    
    return nil;
}


#pragma mark -
#pragma marl OSCascadeViewDataSource

- (UIView*) cascadeView:(OSCascadeView*)cascadeView pageAtIndex:(NSInteger)index {
    return [[self.childViewControllers objectAtIndex:index] view];
}


- (NSInteger) numberOfPagesInCascadeView:(OSCascadeView*)cascadeView {
    return [self.childViewControllers count];
}


#pragma mark -
#pragma marl OSCascadeViewDelegate


- (void) cascadeView:(OSCascadeView*)cascadeView didAddPageAtIndex:(NSInteger)index {
    
//    In most cases Categories VC is interested in such solutions
    UIViewController *categoriesVC = [self.splitCascadeViewController categoriesViewController];
    if ([categoriesVC respondsToSelector:@selector(didAddViewController:)]) {
        [(id<OSCascadeNavigationControllerDelegate>)categoriesVC didAddViewController:[self.childViewControllers objectAtIndex:index]];
    }
}


- (void) cascadeView:(OSCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index {
    if (index >= [self.childViewControllers count])
        return;
    
    UIViewController* __strong viewController = [self.childViewControllers objectAtIndex:index];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    
    //    In most cases Categories VC is interested in such solutions
    UIViewController *categoriesVC = [self.splitCascadeViewController categoriesViewController];
    if ([categoriesVC respondsToSelector:@selector(didPopViewController:)]) {
        [(id<OSCascadeNavigationControllerDelegate>)categoriesVC didPopViewController:viewController];
    }
}


- (void) cascadeView:(OSCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index {
    if (index >= [self.childViewControllers count])
        return;
    
//    Check were view unloaded, and uf yes - load it again
    UIViewController* viewController = [self.childViewControllers objectAtIndex:index];
    OSCascadeSegmentedView *segmentedView = viewController.segmentedView;
    if (!segmentedView.contentView) {
        segmentedView.contentView = viewController.view;
    }
    
//    [self addPagesRoundedCorners];
}


//- (void) cascadeView:(OSCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index {
//    if (index >= [self.childViewControllers count])
//        return;
//    [self addPagesRoundedCorners];
//}


#pragma mark -
#pragma mark Calss methods


- (void) setRootViewController:(UIViewController*)viewController
                     withWidth:(float)pageWidth
                      animated:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated: NO];
    // add root view controller
    [self addViewController:viewController sender:nil withWidth:pageWidth animated:animated];
}


- (void) addViewController:(UIViewController*)viewController
                    sender:(UIViewController*)sender
                 withWidth:(float)pageWidth
                  animated:(BOOL)animated {
    // if in not sent from categoirs view
    if (sender) {
        
        // get index of sender
        NSInteger indexOfSender = [self.childViewControllers indexOfObject:sender];
        // if sender is not last view controller
        if (indexOfSender != NSNotFound) {
            [self popPagesFromLastIndexTo:indexOfSender+1 animated:NO];
        }
    }
    
    [self addChildViewController:viewController];
    
    // push view
    [_cascadeView pushPage:[viewController view]
                  fromPage:[sender view]
                 withWidth:pageWidth
                  animated:animated];
    [viewController configureForSegmentedView];
    
    [viewController didMoveToParentViewController:self];
}

- (void)popAllViewControllers:(BOOL)animated {
    // pop all pages
    [_cascadeView popAllPagesAnimated:animated];
}



#pragma mark -
#pragma mark Private

- (void) popPagesFromLastIndexTo:(NSInteger)toIndex animated:(BOOL)animated {
    NSUInteger count = [self.childViewControllers count];
    
    if (!(toIndex>=0 && toIndex<count)) {
        return;
    }
    
    [_cascadeView popAllPagesToIndex:toIndex animated:animated];
}


//- (void) addRoundedCorner:(UIRectCorner)rectCorner toPageAtIndex:(NSInteger)index {
//    
//    if (index != NSNotFound) {
//        UIViewController* firstVisibleController = [self.childViewControllers objectAtIndex: index];
//        
//        OSCascadeSegmentedView* view = firstVisibleController.segmentedView;
//        [view setShowRoundedCorners: YES];
//        [view setRectCorner: rectCorner];
//    }
//}
//
//
//- (void) addPagesRoundedCorners {
//    
//    // unload all rounded corners
//    for (id item in [_cascadeView visiblePages]) {
//        if (item != [NSNull null]) {
//            if ([item isKindOfClass:[OSCascadeSegmentedView class]]) {
//                OSCascadeSegmentedView* view = (OSCascadeSegmentedView*)item;
//                [view setShowRoundedCorners: NO];
//            }
//        }
//    }
//    
//    NSInteger indexOfFirstVisiblePage = [_cascadeView indexOfFirstVisibleView];
//    NSInteger indexOfLastVisiblePage = [_cascadeView indexOfLastVisibleView];
//    
//    if (indexOfLastVisiblePage == indexOfFirstVisiblePage) {
//        [self addRoundedCorner:UIRectCornerAllCorners toPageAtIndex: indexOfFirstVisiblePage];
//        
//    } else {
//        
//        [self addRoundedCorner:UIRectCornerTopLeft | UIRectCornerBottomLeft toPageAtIndex:indexOfFirstVisiblePage];
//        
//        if (indexOfLastVisiblePage == [self.childViewControllers count] -1) {
//            [self addRoundedCorner:UIRectCornerTopRight | UIRectCornerBottomRight toPageAtIndex:indexOfLastVisiblePage];
//        }
//    }
//}


@end
