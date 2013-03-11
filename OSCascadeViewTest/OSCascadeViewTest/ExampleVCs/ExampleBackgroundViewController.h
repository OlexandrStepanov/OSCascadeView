//
//  ExampleBackgroundViewController.h
//  OSCascadeTest
//
//  Created by Alexandr Stepanov on 04.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExampleBackgroundViewController : UIViewController<UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIImageView *imageView;

@end
