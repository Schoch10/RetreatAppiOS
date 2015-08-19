//
//  AgendaTableViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "AgendaTableViewController.h"
#import "AgendaTableViewCell.h"
#import "TrendingCarouselViewController.h"
#import "CoreDataManager.h"
#import "Agenda+Extensions.h"

static  NSString * const SBRAGENDATABLEVIEWCELL = @"AgendaTableViewCell";

@interface AgendaTableViewController ()
@property (strong, nonatomic) NSArray *agendaArray;

@end

@implementation AgendaTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Agenda";
    [self.tableView registerNib:[UINib nibWithNibName:@"AgendaTableViewCell" bundle:nil] forCellReuseIdentifier:SBRAGENDATABLEVIEWCELL];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self getAgendaItems];
}

- (void)getAgendaItems {
    NSManagedObjectContext *sharedContext = [CoreDataManager sharedManager].mainThreadManagedObjectContext;
    NSFetchRequest *agendaFetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Agenda"];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"time" ascending:YES];
    agendaFetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error;
    self.agendaArray = [sharedContext executeFetchRequest:agendaFetchRequest error:&error];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.agendaArray.count;
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
    Agenda *currentAgendaItem = [self.agendaArray objectAtIndex:indexPath.row];
    [agendaCell layoutWithWidth:CGRectGetWidth(tableView.bounds)];
    UIImage *agendaImage = [UIImage imageNamed:@"golf"];
    agendaCell.agendaItem = currentAgendaItem.title;
    agendaCell.agendaLocation = currentAgendaItem.location;
    agendaCell.agendaImage = agendaImage;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSString *agendaItemTime = [dateFormatter stringFromDate:currentAgendaItem.time];
    agendaCell.agendaTime = [NSString stringWithFormat:@"%@", agendaItemTime];
    agendaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

/*- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
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
} */

@end
