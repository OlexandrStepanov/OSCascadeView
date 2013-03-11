//
//  OSCascadeView.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "OSCascadeView.h"
#import "OSCascade.h"


@interface OSCascadeView() {

    NSMutableArray*     pages;
    
    UIView *            panningPage;
    CGPoint             panningPageStartOrigin;
}

- (OSCascadeSegmentedView *)createPageFromView:(UIView*)view withWidth:(float)pageWidth;
- (void) unloadInvisibleAndLoadVisiblePages;

@end

@implementation OSCascadeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        pages = [[NSMutableArray alloc] init];
                //        Add pan gesture
        UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(panningAction:)];
        gesture.maximumNumberOfTouches = 1;
        gesture.delegate = self;
        [self addGestureRecognizer:gesture];
        
        
        [self setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight];
    }
    return self;
}



#pragma mark Touch Events

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = nil;
    
    NSEnumerator *enumerator = [pages reverseObjectEnumerator];
    UIView *page;
    while (page = [enumerator nextObject]) {
        CGRect rect = page.frame;
        
        if (CGRectContainsPoint(rect, point)) {
            CGPoint newPoint = [self convertPoint:point toView:page];
            result = [page hitTest:newPoint withEvent:event];
            break;
        }
    }
    
    return result;
}

#pragma mark Public methods

- (void) pushPage:(UIView*)newPage
         fromPage:(UIView*)fromPage
        withWidth:(float)pageWidth animated:(BOOL)animated {
    
    OSCascadeSegmentedView *newPageContainer = [self createPageFromView:newPage withWidth:pageWidth];
    
    CGSize size = newPageContainer.bounds.size;
    CGRect pageFrame = CGRectMake(0, 0, size.width, size.height);
    NSInteger insertionIndex;
    
    if (fromPage == nil) {
        insertionIndex = 0;
    }
    else {
//        Try to find fromPage in _pages
        insertionIndex = [pages count];
        NSEnumerator *enumerator = [pages reverseObjectEnumerator];
        OSCascadeSegmentedView *page;
        while (page = [enumerator nextObject]) {
            if (page.contentView == fromPage)
                break;
            else
                insertionIndex--;
        }
    }
//    Called in OSCascadeNavigationController 
//    [self popAllPagesToIndex:insertionIndex animated:NO];
    UIView *lastPage = [pages lastObject];
    if (lastPage) {
        pageFrame.origin.x = lastPage.frame.origin.x+lastPage.frame.size.width;
    }
    
//    Analyze proposed frame, and move all pages left if needed
    CGFloat overhead = 0.f;
    CGFloat newPageRightEdge = pageFrame.origin.x+pageFrame.size.width;
    if (newPageRightEdge > self.bounds.size.width) {
        overhead = newPageRightEdge - self.bounds.size.width;
        pageFrame.origin.x -= overhead;
    }
    
    // add page to array of pages
    [pages addObject: newPageContainer];
    [self addSubview: newPageContainer];
    [self sendSubviewToBack:newPageContainer];
    
    // animation, from left to right
    void (^pagesMove)(void) = ^() {
        [newPageContainer setFrame:pageFrame];
        if (overhead>0) {
//            Move all other pages
            for (int i=0; i<[pages count]-1; i++) {
                UIView *page = [pages objectAtIndex:i];
                page.frame = CGRectOffset(page.frame, -overhead, 0);
            }
        }
    };
    
    void (^animationComplete)(BOOL finished) = ^(BOOL finished) {
//        if (overhead) {
//            [self unloadInvisibleAndLoadVisiblePages];
//        }
    };
    
    if (animated) {
        CGRect startRect = pageFrame;
        startRect.origin.x -= pageFrame.size.width;
        [newPageContainer setFrame: startRect];
        [UIView animateWithDuration:OSCascade_PUSHING_ANIMATION_DURATION delay:0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:pagesMove
                         completion:animationComplete];
    } else {
        pagesMove();
        animationComplete(YES);
    }
    
    if ([_delegate respondsToSelector:@selector(cascadeView:didAddPageAtIndex:)]) {
        [_delegate cascadeView:self didAddPageAtIndex:insertionIndex];
    }
}

- (void) popAllPagesToIndex:(NSInteger)index
                   animated:(BOOL)animated {
    if (index >=0 && index < [pages count]) {
        UIView *nextPage = [pages objectAtIndex:index];
        CGPoint firstPageOrigin = nextPage.frame.origin;
        [self popAllPagesToIndex:index animated:animated startPoint:firstPageOrigin animationLength:OSCascade_PUSHING_ANIMATION_DURATION];
    }
}

- (void) popAllPagesToIndex:(NSInteger)index
                    animated:(BOOL)animated
                 startPoint:(CGPoint)firstPageOrigin
            animationLength:(float)animLength {
    
    if (index < [pages count]) {
        void (^actualRemove)(BOOL finished) = ^(BOOL finished) {
            while ([pages count] > index) {
                UIView *nextPage = [pages lastObject];
                [nextPage removeFromSuperview];
                if ([_delegate respondsToSelector:@selector(cascadeView:didPopPageAtIndex:)]) {
                    [_delegate cascadeView:self didPopPageAtIndex:[pages count]-1];
                }
                [pages removeLastObject];
            }
        };
        void (^moveNotVisiblePages)(void) = ^() {
            if (index>0) {
                UIView *firstVisiblePage = [pages objectAtIndex:index-1];
                CGFloat firstVisiblePageRigthEdge = firstVisiblePage.frame.origin.x + firstVisiblePage.frame.size.width;
                CGFloat rightEmptySpace = MAX(self.bounds.size.width - firstVisiblePageRigthEdge, 0.f);
                UIView *firstPage = [pages objectAtIndex:0];
                CGFloat backOverhead = rightEmptySpace - MAX(0, rightEmptySpace + firstPage.frame.origin.x);
                if (backOverhead > 0.f) {
                    for (int i=0; i<index; i++) {
                        UIView *nextPage = [pages objectAtIndex:i];
                        nextPage.frame = CGRectOffset(nextPage.frame, backOverhead, 0);
                    }
//                    [self unloadInvisibleAndLoadVisiblePages];
                }
            }
        };
        
        if (animated) {
            [UIView animateWithDuration:animLength
                                  delay:0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 UIView *nextPage = [pages objectAtIndex:index];
                                 CGPoint firstPageOrigin = nextPage.frame.origin;
                                 for (int i=index; i<[pages count]; i++) {
                                     nextPage = [pages objectAtIndex:i];
                                     CGRect nextPageFrame = nextPage.frame;
                                     nextPageFrame.origin = CGPointMake(firstPageOrigin.x - nextPage.bounds.size.width, firstPageOrigin.y);
                                     nextPage.frame = nextPageFrame;
                                 }
                                 moveNotVisiblePages();
                             }
                             completion:actualRemove];
        }
        else {
            moveNotVisiblePages();
            actualRemove(YES);
        }
    }
}

- (void) popAllPagesAnimated:(BOOL)animated {
    [self popAllPagesToIndex:0 animated:animated];
}

- (void) unloadInvisibleAndLoadVisiblePages {
    for (int i=[pages count]-1; i>=0; i--) {
        UIView *page = [pages objectAtIndex:i];
        CGRect intersect = CGRectIntersection(self.bounds, page.frame);
        
        if (CGRectIsNull(intersect)) {
            if ([page superview]) {
                [page removeFromSuperview];
                if ([_delegate respondsToSelector:@selector(cascadeView:pageDidDisappearAtIndex:)]) {
                    [_delegate cascadeView:self pageDidDisappearAtIndex:i];
                }
            }
        }
        else {
            if (![page superview]) {
                [self addSubview:page];
                [self bringSubviewToFront:page];
                if ([_delegate respondsToSelector:@selector(cascadeView:pageDidAppearAtIndex:)]) {
                    [_delegate cascadeView:self pageDidAppearAtIndex:i];
                }
            }
        }
    }
}

- (void) updateContentLayoutToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
                                          duration:(NSTimeInterval)duration {
//    Nothing ???
}

#pragma mark Private methods

- (OSCascadeSegmentedView *)createPageFromView:(UIView*)view
                                     withWidth:(float)pageWidth {
    
    OSCascadeSegmentedView *page = [[OSCascadeSegmentedView alloc]
                                        initWithFrame:CGRectMake(0, 0, pageWidth, self.bounds.size.height)];
    page.showRoundedCorners = YES;
    [page setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    page.contentView = view;
    page.haveRightShadow = YES;
    
    return page;
}

- (IBAction)panningAction:(UIPanGestureRecognizer*)gesture {
    
    if (gesture.state ==  UIGestureRecognizerStatePossible ||
        gesture.state == UIGestureRecognizerStateFailed)
        return;
    
    if (gesture.state ==  UIGestureRecognizerStateBegan &&
        panningPage == nil) {
        NSEnumerator *enumerator = [pages reverseObjectEnumerator];
        UIView *page;
        CGPoint gestureStartPoint = [gesture locationInView:self];
        while (page = [enumerator nextObject]) {
            if (CGRectContainsPoint(page.frame, gestureStartPoint)) {
                panningPage = page;
                panningPageStartOrigin = panningPage.frame.origin;
                break;
            }
        }
        
        if (!panningPage) {
            NSLog(@"ERROR: panningPage in nil in gesture beginning, invalidating gesture");
            gesture.enabled = NO;
            gesture.enabled = YES;
            return;
        }
    }
    
    CGPoint translation = [gesture translationInView:self];
    [gesture setTranslation:CGPointMake(0, 0) inView:self];
    
    CGRect frame = panningPage.frame;
    frame.origin.x += translation.x;
    panningPage.frame = frame;
    
//    Analyze the transition progress
    CGPoint endPoint = CGPointMake(panningPageStartOrigin.x - panningPage.bounds.size.width, panningPageStartOrigin.y);
    float   progress = (frame.origin.x - endPoint.x)/(panningPageStartOrigin.x - endPoint.x);
    
    int panningPageIndex = [pages indexOfObject:panningPage];
    CGPoint startPoint = panningPageStartOrigin;
    for (int i=panningPageIndex+1; i<[pages count]; i++) {
        UIView *nextPage = [pages objectAtIndex:i];
        UIView *prevPage = [pages objectAtIndex:i-1];
        startPoint.x += nextPage.bounds.size.width;
        endPoint = CGPointMake(panningPageStartOrigin.x - nextPage.bounds.size.width, panningPageStartOrigin.y);
        CGRect nextPageFrame = nextPage.frame;
        nextPageFrame.origin.x = MIN(progress * (startPoint.x-endPoint.x) + endPoint.x, prevPage.frame.origin.x+prevPage.frame.size.width);
        nextPage.frame = nextPageFrame;
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (panningPage != nil) {
        
            CGPoint velocity = [gesture velocityInView:self];
            BOOL shouldHide = NO;
            if (velocity.x < -OSCascade_PANNING_VELOCITY_THRESHOLD) {
                shouldHide = YES;
            }
            else { //  Analize progress
                shouldHide = (progress<OSCascade_SLIDE_PROGRESS_THRESHOLD);
            }
            
            if (shouldHide) {
                float slideDuration = MIN(300.f / ABS(velocity.x), OSCascade_SLIDE_ANIMATION_DURATION);
                NSLog(@"velocity.x: %0.2f; slideDuration: %0.3f", velocity.x, slideDuration);
                [self popAllPagesToIndex:panningPageIndex animated:YES startPoint:panningPageStartOrigin animationLength:slideDuration];
            }
            else {
//                Return pages to them positions, but also move to the right edge if needed
                CGFloat backOverhead = 0.f;
                if (panningPageIndex == [pages count]-1) {
                    CGFloat panningPageRigthEdge = panningPageStartOrigin.x + panningPage.frame.size.width;
                    CGFloat rightEmptySpace = MAX(self.bounds.size.width - panningPageRigthEdge, 0.f);
                    UIView *firstPage = [pages objectAtIndex:0];
                    backOverhead = rightEmptySpace - MAX(0, rightEmptySpace +
                                                            (panningPageIndex==0 ? panningPageStartOrigin.x : firstPage.frame.origin.x));
                }
                [UIView animateWithDuration:OSCascade_SLIDE_ANIMATION_DURATION delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    CGFloat originAddition = 0;
                    for (int i=panningPageIndex; i<[pages count]; i++) {
                        UIView *nextPage = [pages objectAtIndex:i];
                        CGRect nextPageFrame = nextPage.frame;
                        nextPageFrame.origin = panningPageStartOrigin;
                        nextPageFrame.origin.x += originAddition;
                        nextPage.frame = nextPageFrame;
                        
                        originAddition += nextPageFrame.size.width;
                    }
                    if (backOverhead>0.f) {
                        for (int i=0; i<[pages count]; i++) {
                            UIView *nextPage = [pages objectAtIndex:i];
                            nextPage.frame = CGRectOffset(nextPage.frame, backOverhead, 0);
                        }
                    }
                } completion:NULL];
            }
            panningPage = nil;
        }
    }
    else {
//        If current page was hidden, then we need to switch
        if (progress <= 0) {
//            Remove pages
            while ([pages count]>panningPageIndex) {
                UIView *page = [pages lastObject];
                [page removeFromSuperview];
                if ([_delegate respondsToSelector:@selector(cascadeView:didPopPageAtIndex:)]) {
                    [_delegate cascadeView:self didPopPageAtIndex:[pages count]-1];
                }
                [pages removeLastObject];
            }
            
            if (panningPageIndex > 0) {
                panningPage = [pages objectAtIndex:panningPageIndex-1];
                panningPageStartOrigin = panningPage.frame.origin;
            }
            else {
                panningPage = nil;
                gesture.enabled = NO;
                gesture.enabled = YES;
            }
        }
    }
}

- (NSInteger) indexOfFirstVisibleView {
    for (int i=0; i<[pages count]; i++) {
        UIView *page = [pages objectAtIndex:i];
        CGRect intersect = CGRectIntersection(self.bounds, page.frame);
        if (!CGRectIsNull(intersect))
            return i;
    }
    
    NSLog(@"ERROR in indexOfFirstVisibleView");
    return NSNotFound;
}

- (NSInteger) indexOfLastVisibleView {
    for (int i=[pages count]-1; i>=0; i--) {
        UIView *page = [pages objectAtIndex:i];
        CGRect intersect = CGRectIntersection(self.bounds, page.frame);
        if (!CGRectIsNull(intersect))
            return i;
    }
    
    NSLog(@"ERROR in indexOfLastVisibleView");
    return NSNotFound;
}

- (NSArray*) visiblePages {
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[pages count]];
    NSInteger startIndex = [self indexOfFirstVisibleView];
    NSInteger endIndex = [self indexOfLastVisibleView];
    for (int i=startIndex; i<endIndex; i++) {
        [result addObject:[pages objectAtIndex:i]];
    }
    return [result copy];
}

#pragma mark UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
//     We will start dragging if pan is horisontal enough
    CGPoint translation = [gestureRecognizer translationInView:self];
    float angle = atan2f(ABS(translation.y), ABS(translation.x));
    return (angle < M_PI/6 && [pages count]>0);
}


@end



