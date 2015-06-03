//
//  TrendingModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingModalViewController.h"
#import "CheckedInTableViewCell.h"

static  NSString * const SBRCHECKEDINCELL = @"CheckedinTableCell";


@interface TrendingModalViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITabBar *trendingInformationTab;
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;


- (IBAction)closeModalSelected:(id)sender;
@end

@implementation TrendingModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"CheckedInTableViewCell" bundle:nil] forCellReuseIdentifier:SBRCHECKEDINCELL];
}

- (IBAction)closeModalSelected:(id)sender {
    [self.delegate dismissTrendingModalViewController];
}

#pragma mark UITableView Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.trendingTableView dequeueReusableCellWithIdentifier:SBRCHECKEDINCELL forIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CheckedInTableViewCell estimatedHeight];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CheckedInTableViewCell *checkinCell = (CheckedInTableViewCell *)cell;
    [checkinCell layoutWithWidth:CGRectGetWidth(self.trendingTableView.bounds)];
    NSString *username = @"Brendan Schoch";
    NSString *checkinTime = @"20 minutes ago";
    UIImage *image = [UIImage imageNamed:@"me"];
    checkinCell.checkinName = username;
    checkinCell.userImage = image;
    checkinCell.checkinTime = checkinTime;
    
}

#pragma mark UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            NSLog(@"Posts");
            break;
        case 1:
            NSLog(@"Checked In");
            break;
        default:
            break;
    }
}

@end
