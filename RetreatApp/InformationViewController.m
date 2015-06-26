//
//  InformationViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "InformationViewController.h"
#import "InformationTableViewCell.h"

static  NSString * const SBRINFOTABLEVIEWCELL = @"InfoTableViewCell";

@interface InformationViewController ()
@property (strong, nonatomic) NSArray *informationArray;
@property (weak, nonatomic) IBOutlet UITableView *informationTableView;
@end


@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Information";
    self.informationArray = @[@"310 Mount Washington Hotel Rd, Bretton Woods, NH 03575", @"603-278-1000"];
    [self.informationTableView registerNib:[UINib nibWithNibName:@"InformationTableViewCell" bundle:nil] forCellReuseIdentifier:SBRINFOTABLEVIEWCELL];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return @"Location";
            break;
        case 1:
            return @"Phone";
            break;
        default:
            return @"Error";
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70.f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.informationTableView dequeueReusableCellWithIdentifier:SBRINFOTABLEVIEWCELL forIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    InformationTableViewCell *informationCell = (InformationTableViewCell *)cell;
    if (indexPath.section == 0) {
        informationCell.informationString =  [self.informationArray objectAtIndex:0];
    } else {
        informationCell.informationString =  [self.informationArray objectAtIndex:1];
    }
   
}

@end
