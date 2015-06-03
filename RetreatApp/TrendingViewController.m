//
//  TrendingViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingViewController.h"
#import "TrendingModalViewController.h"
#import "CheckinViewController.h"

@interface TrendingViewController ()
- (IBAction)checkInButtonSelected:(id)sender;
- (IBAction)postButtonSelected:(id)sender;
- (IBAction)trendingAreaSelected:(id)sender;

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trending";
}

- (IBAction)checkInButtonSelected:(id)sender {
    CheckinViewController *checkinViewController = [[CheckinViewController alloc]initWithNibName:@"CheckinViewController" bundle:nil];
    checkinViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    checkinViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    checkinViewController.delegate = self;
    [self presentViewController:checkinViewController animated:YES completion:nil];
}

- (IBAction)postButtonSelected:(id)sender {
    PostModalViewController *postViewController = [[PostModalViewController alloc]initWithNibName:@"PostModalViewController" bundle:nil];
    postViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    postViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    postViewController.delegate = self;
    [self presentViewController:postViewController animated:YES completion:nil];
}

- (IBAction)trendingAreaSelected:(id)sender {
    TrendingModalViewController *trendingModalview = [[TrendingModalViewController alloc]initWithNibName:@"TrendingModalViewController" bundle:nil];
    trendingModalview.modalPresentationStyle = UIModalPresentationFullScreen;
    trendingModalview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    trendingModalview.delegate = self;
    [self presentViewController:trendingModalview animated:YES completion:nil];
}

- (void)dismissTrendingModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissCheckinModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissPostModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
