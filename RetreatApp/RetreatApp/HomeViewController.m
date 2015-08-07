//
//  HomeViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "HomeViewController.h"
#import "InformationViewController.h"
#import "AgendaTableViewController.h"
#import "ActivitiesTableViewController.h"
#import "TrendingNowViewController.h"
#import "GameViewController.h"
#import "SettingsManager.h"

@interface HomeViewController ()
- (IBAction)informationButtonSelected:(id)sender;
- (IBAction)agendaButtonSelected:(id)sender;
- (IBAction)activitiesButtonSelected:(id)sender;
- (IBAction)trendingButtonSelected:(id)sender;
- (IBAction)gameButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *countdownLabel;
@property (weak, nonatomic) IBOutlet UIView *countdownView;
@property (weak, nonatomic) IBOutlet UIButton *gameButton;
@property (weak, nonatomic) IBOutlet UILabel *userInformationLabel;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic, strong) NSTimer *timer;
@end

int days, hours, minutes;
double seconds;
int secondsLeft;


@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView* logo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"slalomwhite"]];
    logo.contentMode = UIViewContentModeScaleAspectFit;
    self.navigationItem.titleView = logo;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    self.userInformationLabel.text = sharedManager.username;
    self.userImageView.image = [UIImage imageWithData:sharedManager.userImage];
    [self countdownTimer];
}

- (void)updateCounter:(NSTimer *)theTimer {
    if(secondsLeft > 0 ){
        secondsLeft -- ;
        days = secondsLeft / 86400;
        hours = (secondsLeft % 86400) / 3600;
        minutes = (secondsLeft % 3600) / 60;
        seconds = (secondsLeft % 3600) % 60;
        self.countdownLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d:%02.f",days, hours, minutes, seconds];
        self.gameButton.enabled = YES;
        self.gameButton.backgroundColor = [UIColor grayColor];
        self.gameButton.titleLabel.text = @"Top Secret";
    }
    else if (secondsLeft <= 0) {
        self.countdownView.hidden = YES;
        self.gameButton.enabled = YES;
        self.gameButton.titleLabel.text = @"Game";
    }
}

-(void)countdownTimer{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:28];
    [comps setMonth:8];
    [comps setYear:2015];
    //Add iOS 7 support
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *retreatDate = [gregorian dateFromComponents:comps];
    secondsLeft = [retreatDate timeIntervalSinceDate:[NSDate date]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateCounter:) userInfo:nil repeats:YES];
}

- (IBAction)informationButtonSelected:(id)sender {
    InformationViewController *informationViewController = [[InformationViewController alloc]initWithNibName:@"InformationViewController" bundle:nil];
    [self.navigationController pushViewController:informationViewController animated:YES];
}

- (IBAction)agendaButtonSelected:(id)sender {
    AgendaTableViewController *agendaTableViewController = [[AgendaTableViewController alloc]initWithNibName:@"AgendaTableViewController" bundle:nil];
    [self.navigationController pushViewController:agendaTableViewController animated:YES];
}

- (IBAction)activitiesButtonSelected:(id)sender {
    ActivitiesTableViewController *activitiesTableViewController = [[ActivitiesTableViewController alloc]initWithNibName:@"ActivitiesTableViewController" bundle:nil];
    [self.navigationController pushViewController:activitiesTableViewController animated:YES];
}

- (IBAction)trendingButtonSelected:(id)sender {
    TrendingNowViewController *trendingViewController = [[TrendingNowViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:trendingViewController animated:YES];
}

- (IBAction)gameButtonSelected:(id)sender {
    GameViewController *gameViewController = [[GameViewController alloc]initWithNibName:@"GameViewController" bundle:nil];
    [self.navigationController pushViewController:gameViewController animated:YES];
}

@end
