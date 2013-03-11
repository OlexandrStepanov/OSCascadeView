//
//  ExampleCategoriesViewController.h
//  Cascade
//
//  Created by Alexandr Stepanov on 04.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OSCascade.h"

@interface ExampleCategoriesViewController : UIViewController <OSCascadeNavigationControllerDelegate> {
    
}

@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end
