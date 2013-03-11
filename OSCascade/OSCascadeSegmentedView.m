//
//  OSCascadeSegmentedView.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "OSCascadeSegmentedView.h"
#import "OSCascade.h"
#import "OSCascadeShadowView.h"

@interface OSCascadeSegmentedView ()

- (void) updateRoundedCorners;

@end


@implementation OSCascadeSegmentedView

- (BOOL)isLoaded
{
    return self.superview != nil;
}

#pragma mark - Init & dealloc

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        _roundedCornersView = [[UIView alloc] initWithFrame:frame];
        [_roundedCornersView setBackgroundColor: [UIColor clearColor]];
        [self addSubview: _roundedCornersView];
        
        _rectCorner = UIRectCornerAllCorners;
        _showRoundedCorners = NO;
        
        self.shadowWidth = OSCascade_PAGE_VIEW_SHADOW_WIDTH;
        [self setClipsToBounds: NO];
    }
    return self;
}



#pragma mark -
#pragma mark Setters

- (void) setContentView:(UIView*)contentView {
    if (_contentView != contentView) {
        [_contentView removeFromSuperview];
        
        _contentView = contentView;
        
        if (_contentView) {
            [_contentView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleBottomMargin |
             UIViewAutoresizingFlexibleTopMargin |
             UIViewAutoresizingFlexibleWidth |
             UIViewAutoresizingFlexibleHeight];
            
            [_roundedCornersView addSubview: _contentView];
            [self setNeedsLayout];
        }
    }
}


- (void) setHeaderView:(UIView*)headerView {
    
    if (_headerView != headerView) {
        [_headerView removeFromSuperview];
        
        _headerView = headerView;
        
        if (_headerView) {
            [_headerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleTopMargin];
            [_headerView setUserInteractionEnabled:YES];
            
            [_roundedCornersView addSubview: _headerView];
            [self setNeedsLayout];
        }
    }
}

- (void) setFooterView:(UIView*)footerView {
    
    if (_footerView != footerView) {
        [_footerView removeFromSuperview];
        
        _footerView = footerView;
        if (_footerView) {
            [_footerView setAutoresizingMask:
             UIViewAutoresizingFlexibleLeftMargin |
             UIViewAutoresizingFlexibleRightMargin |
             UIViewAutoresizingFlexibleBottomMargin];
            [_footerView setUserInteractionEnabled:YES];
            
            [_roundedCornersView addSubview: _footerView];
            [self setNeedsLayout];
        }
    }
}

- (void)setHaveLeftShadow:(BOOL)haveLeftShadow {
    if (haveLeftShadow != _haveLeftShadow) {
        _haveLeftShadow = haveLeftShadow;
        
        if (_haveLeftShadow) {
            _shadowViewLeft = [OSCascadeShadowView new];
            ((OSCascadeShadowView*)_shadowViewLeft).isLeftBoder = YES;
            [self insertSubview:_shadowViewLeft atIndex:0];
        }
        else {
            _shadowViewLeft = nil;
        }
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}

- (void)setHaveRightShadow:(BOOL)haveRightShadow {
    if (haveRightShadow != _haveRightShadow) {
        _haveRightShadow = haveRightShadow;
        
        if (_haveRightShadow) {
            _shadowViewRight = [OSCascadeShadowView new];
            ((OSCascadeShadowView*)_shadowViewRight).isLeftBoder = NO;
            [self insertSubview:_shadowViewRight atIndex:0];
        }
        else {
            _shadowViewRight = nil;
        }
        
        [self setNeedsLayout];
        [self setNeedsDisplay];
    }
}


#pragma mark -
#pragma mark Private

- (void) updateRoundedCorners {
    
    if (_showRoundedCorners) {
        CGRect toolbarBounds = self.bounds;
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect: toolbarBounds
                                                   byRoundingCorners:_rectCorner
                                                         cornerRadii:CGSizeMake(6.0f, 6.0f)];
        [maskLayer setPath:[path CGPath]];
        
        _roundedCornersView.layer.masksToBounds = YES;
        _roundedCornersView.layer.mask = maskLayer;
    }
    else {
        _roundedCornersView.layer.masksToBounds = NO;
        [_roundedCornersView.layer setMask: nil];
    }
}


- (void) layoutSubviews {
    
    CGRect rect = self.bounds;
    
    CGFloat viewWidth = rect.size.width;
    CGFloat viewHeight = rect.size.height;
    CGFloat headerHeight = 0.0;
    CGFloat footerHeight = 0.0;
    
    _roundedCornersView.frame = rect;
    
    if (_headerView) {
        headerHeight = _headerView.frame.size.height;
        
        CGRect newHeaderViewFrame = CGRectMake(0.0, 0.0, viewWidth, headerHeight);
        [_headerView setFrame: newHeaderViewFrame];
    }
    
    if (_footerView) {
        footerHeight = _footerView.frame.size.height;
        CGFloat footerY = viewHeight - footerHeight;
        
        CGRect newFooterViewFrame = CGRectMake(0.0, footerY, viewWidth, footerHeight);
        [_footerView setFrame: newFooterViewFrame];
    }
    
    [_contentView setFrame: CGRectMake(0.0, headerHeight, viewWidth, viewHeight - headerHeight - footerHeight)];
    
    if (_shadowViewLeft) {
        CGRect shadowFrame = CGRectMake(-_shadowWidth + _shadowOffset, 0.0, _shadowWidth, rect.size.height);
        _shadowViewLeft.frame = shadowFrame;
    }
    
    if (_shadowViewRight) {
        CGRect shadowFrame = CGRectMake(self.bounds.size.width, 0.0, _shadowWidth, rect.size.height);
        _shadowViewRight.frame = shadowFrame;
    }
    
    [self updateRoundedCorners];
}


#pragma mark
#pragma mark Setters

- (void) setRectCorner:(UIRectCorner)corners {
    if (corners != _rectCorner) {
        _rectCorner = corners;
        [self setNeedsLayout];
    }
}


- (void) setShowRoundedCorners:(BOOL)show {
    if (show != _showRoundedCorners) {
        _showRoundedCorners = show;
        [self setNeedsLayout];
    }
}

@end
