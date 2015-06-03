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
}

- (IBAction)nextButtonSelected:(id)sender {
    
    CreateUserViewController *createUserViewController = [[CreateUserViewController alloc]initWithNibName:@"CreateUserViewController" bundle:nil];
    [self.navigationController pushViewController:createUserViewController animated:nil];
}
@end
