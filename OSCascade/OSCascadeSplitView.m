//
//  OSCascadeSplitView.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "OSCascadeSplitView.h"
#import "OSCascade.h"

@interface OSCascadeSplitView ()

- (void) setupView;
- (void) addDividerView;

@end


@implementation OSCascadeSplitView


#pragma mark -
#pragma mark Private

- (void) setupView {
    [self setBackgroundColor: [UIColor blackColor]];
}


- (void) addDividerView {
    
    if ((!_backgroundView) || (!_verticalDividerImage)) return;
    
    if (_dividerView) {
        [_dividerView removeFromSuperview];
        _dividerView = nil;
    }
    
    _dividerView = [[UIView alloc] init];
    _dividerWidth = _verticalDividerImage.size.width;
    [_dividerView setBackgroundColor:[UIColor colorWithPatternImage: _verticalDividerImage]];
    
    [_backgroundView addSubview: _dividerView];
    [self setNeedsLayout];
    
}


#pragma mark -
#pragma mark Init & dealloc

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setupView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}


- (void)dealloc
{
    _cascadeView = nil;
    _categoriesView = nil;
    _verticalDividerImage = nil;
    _dividerView = nil;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    UIView *result = nil;
    if (CGRectContainsPoint(_categoriesView.frame, point)) {
        result = [_categoriesView hitTest:[self convertPoint:point toView:_categoriesView]
                                withEvent:event];
    } else {
        result = [_cascadeView hitTest:[self convertPoint:point toView:_cascadeView]
                             withEvent:event];
        if (!result) {
            result = [_backgroundView hitTest:[self convertPoint:point toView:_backgroundView]
                                    withEvent:event];
        }
    }
    
    return result;
}

- (void) layoutSubviews {
    
    CGRect bounds = self.bounds;
    
    CGRect categoriesFrame = CGRectMake(0.0, 0.0, CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _categoriesView.frame = categoriesFrame;
    
    CGRect backgroundViewFrame = CGRectMake(CATEGORIES_VIEW_WIDTH, 0.0, bounds.size.width - CATEGORIES_VIEW_WIDTH, bounds.size.height);
    _cascadeView.frame = backgroundViewFrame;
    _backgroundView.frame = backgroundViewFrame;
    
    CGRect dividerViewFrame = CGRectMake(0.0, 0.0, _dividerWidth, bounds.size.height);
    _dividerView.frame = dividerViewFrame;    
}


#pragma mark -
#pragma mark Setter

- (void) setCategoriesView:(UIView*) aView {
    if (_categoriesView != aView) {
        _categoriesView = aView;
        
        [self addSubview: _categoriesView];
        [self bringSubviewToFront: _categoriesView];
    }
}

- (void) setCascadeView:(UIView*) aView {
    if (_cascadeView != aView) {
        _cascadeView = aView;
        
        [self addSubview: _cascadeView];
        [self bringSubviewToFront: _categoriesView];
        [self sendSubviewToBack: _backgroundView];
    }
}

- (void) setBackgroundView:(UIView*) aView {
    if (_backgroundView != aView) {
        _backgroundView = aView;
        
        [_dividerView removeFromSuperview];
        _dividerView = nil;
        
        [self addSubview: _backgroundView];
        [self sendSubviewToBack: _backgroundView];
        [self addDividerView];
    }
}

- (void) setVerticalDividerImage:(UIImage*) image {
    if (_verticalDividerImage != image) {
        _verticalDividerImage = image;
        
        [self addDividerView];
    }
}


@end
