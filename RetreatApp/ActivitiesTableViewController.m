//
//  ActivitiesTableViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "ActivitiesTableViewController.h"
#import "AgendaTableViewCell.h"
#import "TrendingViewController.h"

static  NSString * const SBRAGENDATABLEVIEWCELL = @"AgendaTableViewCell";

@interface ActivitiesTableViewController ()

@end

@implementation ActivitiesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Activities";
    [self.tableView registerNib:[UINib nibWithNibName:@"AgendaTableViewCell" bundle:nil] forCellReuseIdentifier:SBRAGENDATABLEVIEWCELL];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [AgendaTableViewCell estimatedHeight];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView dequeueReusableCellWithIdentifier:SBRAGENDATABLEVIEWCELL forIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    AgendaTableViewCell *agendaCell = (AgendaTableViewCell *)cell;
    [agendaCell layoutWithWidth:CGRectGetWidth(tableView.bounds)];
    NSString *name = @"Golf";
    NSString *location = @"Golf Course";
    NSString *time = @"9:00AM-2:00PM";
    UIImage *image = [UIImage imageNamed:@"golf"];
    agendaCell.agendaItem = name;
    agendaCell.agendaLocation = location;
    agendaCell.agendaTime = time;
    agendaCell.agendaImage = image;
    agendaCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendingViewController *trendingViewController =[[TrendingViewController alloc]initWithNibName:@"TrendingViewController" bundle:nil];
    [self.navigationController pushViewController:trendingViewController animated:YES];
}


@end
