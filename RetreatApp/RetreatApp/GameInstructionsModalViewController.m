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
@property (weak, nonatomic) IBOutlet UIView *instructionsView;

@end

@implementation GameInstructionsModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.instructionsView.layer.masksToBounds = NO;
    self.instructionsView.layer.shadowOffset = CGSizeMake(2, 2);
    self.instructionsView.layer.shadowRadius = 5;
    self.instructionsView.layer.shadowOpacity = 0.5;
}

- (IBAction)dismissGameInstructionsModal:(id)sender {
    [self.delegate dismissGameInstructionsModalViewController];
}
@end
