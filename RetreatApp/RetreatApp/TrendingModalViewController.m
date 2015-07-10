//
//  TrendingModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingModalViewController.h"
#import "CheckedInTableViewCell.h"
#import "PostsTableViewCell.h"

static  NSString * const SBRCHECKEDINCELL = @"CheckedinTableCell";
static  NSString * const SBRPOSTSCELL = @"PostsTableCell";


@interface TrendingModalViewController () <UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavigationConstraint;

@property (weak, nonatomic) IBOutlet UITabBar *trendingInformationTab;
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;
@property (nonatomic) BOOL isCheckedInView;


- (IBAction)closeModalSelected:(id)sender;
@end

@implementation TrendingModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view removeConstraint:self.topNavigationConstraint];
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:newTopConstraint];
    
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"CheckedInTableViewCell" bundle:nil] forCellReuseIdentifier:SBRCHECKEDINCELL];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"PostsTableViewCell" bundle:nil] forCellReuseIdentifier:SBRPOSTSCELL];
    self.isCheckedInView = NO;
    
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
    if (self.isCheckedInView) {
        return [self.trendingTableView dequeueReusableCellWithIdentifier:SBRCHECKEDINCELL forIndexPath:indexPath];
    } else {
        return [self.trendingTableView dequeueReusableCellWithIdentifier:SBRPOSTSCELL forIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCheckedInView) {
        return [CheckedInTableViewCell estimatedHeight];
    } else {
        return 250.0f;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.isCheckedInView) {
        CheckedInTableViewCell *checkinCell = (CheckedInTableViewCell *)cell;
        [checkinCell layoutWithWidth:CGRectGetWidth(self.trendingTableView.bounds)];
        NSString *username = @"Brendan Schoch";
        NSString *checkinTime = @"20 minutes ago";
        UIImage *image = [UIImage imageNamed:@"me"];
        checkinCell.checkinName = username;
        checkinCell.userImage = image;
        checkinCell.checkinTime = checkinTime;
    } else {
      //  PostsTableViewCell *postsCell = (PostsTableViewCell *)cell;
    }
    
}

#pragma mark UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            self.isCheckedInView = NO;
            [self.trendingTableView reloadData];
            break;
        case 1:
            self.isCheckedInView = YES;
            [self.trendingTableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark UINavigationBar delegate methods

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
