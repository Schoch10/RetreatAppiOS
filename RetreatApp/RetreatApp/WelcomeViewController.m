//
//  WelcomeViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/29/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "WelcomeViewController.h"
#import "CreateUserViewController.h"

@interface WelcomeViewController ()
- (IBAction)nextButtonSelected:(id)sender;

@end

@implementation WelcomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Welcome to the T Party";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (IBAction)nextButtonSelected:(id)sender {
    
    CreateUserViewController *createUserViewController = [[CreateUserViewController alloc]initWithNibName:@"CreateUserViewController" bundle:nil];
    [self.navigationController pushViewController:createUserViewController animated:nil];
}
@end
