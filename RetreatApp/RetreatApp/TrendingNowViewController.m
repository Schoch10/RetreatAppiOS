//
//  TrendingNowViewController.m
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/6/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingNowViewController.h"
#import "TrendingNowTableViewCell.h"
#import "TrendingCarouselViewController.h"

@interface TrendingNowViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *locations;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation TrendingNowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Trending Now";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:nil];
    self.locations = @[@"Hotel Bar", @"Hotel Lobby", @"Golf", @"Lawn Games", @"Spa", @"Zipline", @"Outdoor Activities", @"Town", @"Banquet", @"Afterparty"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"TrendingNowTableViewCell" bundle:nil] forCellReuseIdentifier:kTrendingNowCellIdentifier];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendingNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrendingNowCellIdentifier forIndexPath:indexPath];
    
    NSString *checkInString = [NSString stringWithFormat:@"%@ check-ins", @(arc4random_uniform(80))];
    [cell configureWithLocation:self.locations[indexPath.row] checkInText:checkInString imageURL:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendingCarouselViewController *trendingViewController = [[TrendingCarouselViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:trendingViewController animated:YES];
}

@end
