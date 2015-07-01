//
//  CheckinViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckinViewController.h"

@interface CheckinViewController ()
@property (weak, nonatomic) IBOutlet UITableView *checkinTableView;
@property (strong, nonatomic) NSArray *locations;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
- (IBAction)checkinButtonSelected:(id)sender;
- (IBAction)cancelButtonSelected:(id)sender;

@end

@implementation CheckinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locations = @[@"Mt. Omni Lobby", @"Golf Course", @"The Pub", @"Lawn Games", @"Pool", @"Spa"];
    self.checkinButton.enabled = NO;
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier;
    UITableViewCell *cell;
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [self.locations objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.checkinButton.enabled = YES;
}

- (IBAction)checkinButtonSelected:(id)sender {
    [self.delegate dismissCheckinModalViewController];
}

- (IBAction)cancelButtonSelected:(id)sender {
    [self.delegate dismissCheckinModalViewController];
}

@end
