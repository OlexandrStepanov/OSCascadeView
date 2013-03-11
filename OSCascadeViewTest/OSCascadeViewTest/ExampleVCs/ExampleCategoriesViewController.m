//
//  ExampleCategoriesViewController.m
//  Cascade
//
//  Created by Alexandr Stepanov on 04.03.13.
//  Copyright (c) 2013  Alex Stepanov. All rights reserved.
//

#import "ExampleCategoriesViewController.h"
#import "ExampleTableViewController.h"

@interface ExampleCategoriesViewController()

@property (nonatomic, retain) UITableViewCell *selectedCell;
@property (nonatomic, retain) UIViewController *selectedVC;

@end


@implementation ExampleCategoriesViewController

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // set background of tableview
    UIView* backgrounView = [[UIView alloc] initWithFrame: self.tableView.bounds];
    [backgrounView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"brown_bg_128x128.png"]]];
    [self.tableView setBackgroundView:backgrounView];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}


#pragma mark - 
#pragma mark Table view data source - Categories

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 10;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];

        [cell.textLabel setFont:[UIFont fontWithName:@"HelveticaNeue-Bold" size:22.0]];
        [cell.textLabel setTextColor: [UIColor colorWithRed:0.894117 green:0.839215 blue:0.788235 alpha:1.0]];
        [cell.textLabel setShadowColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75]];
        [cell.textLabel setShadowOffset:CGSizeMake(0.0, 1.0)];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        UIImage *backgroundImage = [[UIImage imageNamed:@"LightBackground.png"] stretchableImageWithLeftCapWidth:0.0 topCapHeight:1.0];
        cell.backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
        cell.backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        cell.backgroundView.frame = cell.bounds;
        cell.backgroundView.alpha = 0.5;
    }
    
    // Configure the cell...
    cell.textLabel.text = [NSString stringWithFormat:@"%i", indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.f;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    if (self.selectedCell != newSelectedCell) {
        self.selectedVC = [[ExampleTableViewController alloc] initWithStyle:UITableViewStylePlain];
        [self.cascadeNavigationController setRootViewController:self.selectedVC withWidth:300 animated:YES];
        self.selectedCell = newSelectedCell;
    }
    else {
        [self.cascadeNavigationController popAllViewControllers:YES];
        self.selectedCell = nil;
        self.selectedVC = nil;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}


#pragma mark OSCascadeNavigationControllerDelegate

- (void) didPopViewController:(UIViewController*)pageController {
    if (self.selectedVC == pageController) {
        NSIndexPath *selectedIndex = [self.tableView indexPathForCell:self.selectedCell];
        [self.tableView deselectRowAtIndexPath:selectedIndex animated:YES];
        self.selectedCell = nil;
        self.selectedVC = nil;
    }
}

@end
