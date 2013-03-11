//
//  OSCascadeView.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol OSCascadeViewDataSource;
@protocol OSCascadeViewDelegate;
@class OSCascadeScrollView;

@interface OSCascadeView : UIView <UIGestureRecognizerDelegate> {
}

@property(nonatomic, weak) id<OSCascadeViewDelegate> delegate;
@property(nonatomic, weak) id<OSCascadeViewDataSource> dataSource;



- (void) pushPage:(UIView*)newPage
         fromPage:(UIView*)fromPage
        withWidth:(float)width animated:(BOOL)animated;

- (void) popAllPagesToIndex:(NSInteger)index animated:(BOOL)animated;
- (void) popAllPagesAnimated:(BOOL)animated;

//- (UIView*) loadPageAtIndex:(NSInteger)index;
- (NSInteger) indexOfFirstVisibleView;
- (NSInteger) indexOfLastVisibleView;
- (NSArray*) visiblePages;

- (void) updateContentLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration;

@end

@protocol OSCascadeViewDataSource <NSObject>
@required
- (UIView*) cascadeView:(OSCascadeView*)cascadeView pageAtIndex:(NSInteger)index;
- (NSInteger) numberOfPagesInCascadeView:(OSCascadeView*)cascadeView;
@end

@protocol OSCascadeViewDelegate <NSObject>
@optional
- (void) cascadeView:(OSCascadeView*)cascadeView didAddPageAtIndex:(NSInteger)index;
- (void) cascadeView:(OSCascadeView*)cascadeView didPopPageAtIndex:(NSInteger)index;

/*
 * Called when page will slide in CascadeView bounds after disappearing
 */
- (void) cascadeView:(OSCascadeView*)cascadeView pageDidAppearAtIndex:(NSInteger)index;
/*
 * Called when page slide out CascadeView bounds (disappears)
 */
- (void) cascadeView:(OSCascadeView*)cascadeView pageDidDisappearAtIndex:(NSInteger)index;

@end
