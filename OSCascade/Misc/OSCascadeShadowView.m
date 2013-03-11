//
//  OSCascadeShadowView.m
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 01.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "OSCascadeShadowView.h"

@implementation OSCascadeShadowView

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
    }
    return self;
}


- (void) drawRect:(CGRect)rect {
    CGFloat colorsLeft [] = {
        0.0, 0.0, 0.0, 0.0,
        0.0, 0.0, 0.0, 0.3
    };
    CGFloat colorsRight [] = {
        0.0, 0.0, 0.0, 0.3,
        0.0, 0.0, 0.0, 0.0
    };
    
    CGColorSpaceRef baseSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(baseSpace, (self.isLeftBoder ? colorsLeft : colorsRight), NULL, 2);
    CGColorSpaceRelease(baseSpace), baseSpace = NULL;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGPoint startPoint = CGPointMake(0, CGRectGetMidY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMaxX(rect), CGRectGetMidY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient), gradient = NULL;
}


@end
