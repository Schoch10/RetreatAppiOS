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
- (void)trendingAreaSelected:(id)sender;
- (void)setupTrendingAreaViews;


@property (strong, nonatomic) UIView *poolAreaView;
@property (strong, nonatomic) UIView *golfAreaView;
@property (strong, nonatomic) UIView *barAreaView;

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trending";
    [self setupTrendingAreaViews];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (void)setupTrendingAreaViews {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    self.poolAreaView = [[UIView alloc]initWithFrame:CGRectMake(0.78 * screenWidth, 0.65 * screenHeight, 70.0f, 70.0f)];
    self.poolAreaView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.poolAreaView];
    UIButton *poolButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [poolButton addTarget:self action:@selector(trendingAreaSelected:) forControlEvents:UIControlEventTouchUpInside];
    [poolButton setBackgroundImage:[UIImage imageNamed:@"bluecircle"] forState:UIControlStateNormal];
    [poolButton setTitle:@"Pool" forState:UIControlStateNormal];
    [poolButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    poolButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    poolButton.alpha = 0.9;
    poolButton.titleLabel.textColor = [UIColor whiteColor];
    [self.poolAreaView addSubview:poolButton];
    
    self.golfAreaView = [[UIView alloc]initWithFrame:CGRectMake(0.70 * screenWidth, 0.50 * screenHeight, 70.0f, 70.0f)];
    self.golfAreaView.backgroundColor = [UIColor clearColor];
    UIButton *golfButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [golfButton addTarget:self action:@selector(trendingAreaSelected:) forControlEvents:UIControlEventTouchUpInside];
    [golfButton setBackgroundImage:[UIImage imageNamed:@"bluecircle"] forState:UIControlStateNormal];
    [golfButton setTitle:@"Golf" forState:UIControlStateNormal];
    [golfButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    golfButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    golfButton.alpha = 0.9;
    golfButton.titleLabel.textColor = [UIColor whiteColor];
    [self.golfAreaView addSubview:golfButton];
    [self.view addSubview:self.golfAreaView];
    
    self.barAreaView = [[UIView alloc]initWithFrame:CGRectMake(0.60 * screenWidth, 0.70 * screenHeight, 70.0f, 70.0f)];
    self.barAreaView.backgroundColor = [UIColor clearColor];
    UIButton *barButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [barButton addTarget:self action:@selector(trendingAreaSelected:) forControlEvents:UIControlEventTouchUpInside];
    [barButton setBackgroundImage:[UIImage imageNamed:@"bluecircle"] forState:UIControlStateNormal];
    [barButton setTitle:@"Bar" forState:UIControlStateNormal];
    [barButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    barButton.frame = CGRectMake(0, 0, 70.0f, 70.0f);
    barButton.alpha = 0.9;
    barButton.titleLabel.textColor = [UIColor whiteColor];
    [self.barAreaView addSubview:barButton];
    [self.view addSubview:self.barAreaView];
    
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

- (void)trendingAreaSelected:(id)sender {
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
