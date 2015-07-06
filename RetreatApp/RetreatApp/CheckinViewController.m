//
//  CheckinViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckinViewController.h"

@interface CheckinViewController () <UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavigationConstraint;

@property (weak, nonatomic) IBOutlet UITableView *checkinTableView;
@property (strong, nonatomic) NSArray *locations;
@property (weak, nonatomic) IBOutlet UIButton *checkinButton;
- (IBAction)checkinButtonSelected:(id)sender;
- (IBAction)cancelButtonSelected:(id)sender;

@end

@implementation CheckinViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view removeConstraint:self.topNavigationConstraint];
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:newTopConstraint];

    
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

#pragma mark UINavigationBar delegate methods

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
