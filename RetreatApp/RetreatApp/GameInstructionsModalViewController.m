//
//  GameInstructionsModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/13/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "GameInstructionsModalViewController.h"

@interface GameInstructionsModalViewController ()
- (IBAction)dismissGameInstructionsModal:(id)sender;

@end

@implementation GameInstructionsModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)dismissGameInstructionsModal:(id)sender {
    [self.delegate dismissGameInstructionsModalViewController];
}
@end
