//
//  AgendaTableViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "AgendaTableViewController.h"
#import "AgendaTableViewCell.h"
#import "TrendingViewController.h"

static  NSString * const SBRAGENDATABLEVIEWCELL = @"AgendaTableViewCell";

@interface AgendaTableViewController ()

@end

@implementation AgendaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Agenda";
    [self.tableView registerNib:[UINib nibWithNibName:@"AgendaTableViewCell" bundle:nil] forCellReuseIdentifier:SBRAGENDATABLEVIEWCELL];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
    NSString *name = @"Cocktail Hour";
    NSString *location = @"Pool";
    NSString *time = @"5:00-10:00PM";
    UIImage *image = [UIImage imageNamed:@"pool"];
    agendaCell.agendaItem = name;
    agendaCell.agendaLocation = location;
    agendaCell.agendaTime = time;
    agendaCell.agendaImage = image;
    agendaCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Friday";
            break;
        case 1:
            return @"Saturday";
            break;
        case 2:
            return @"Sunday";
            break;
        default:
            return @"Error";
            break;
    }
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendingViewController *trendingViewController =[[TrendingViewController alloc]initWithNibName:@"TrendingViewController" bundle:nil];
    [self.navigationController pushViewController:trendingViewController animated:YES];
}

@end
