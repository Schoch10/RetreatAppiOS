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
@property (strong, nonatomic) NSMutableArray *fridayArray;
@property (strong, nonatomic) NSMutableArray *saturdayArray;
@property (strong, nonatomic) NSMutableArray *sundayArray;

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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"agendaId" ascending:YES];
    agendaFetchRequest.sortDescriptors = @[sortDescriptor];
    NSError *error;
    self.agendaArray = [sharedContext executeFetchRequest:agendaFetchRequest error:&error];
    self.fridayArray = [[NSMutableArray alloc]init];
    self.saturdayArray = [[NSMutableArray alloc]init];
    self.sundayArray = [[NSMutableArray alloc]init];
    for (Agenda *agendaItem in self.agendaArray) {
        if ([agendaItem.day isEqualToString:@"Friday"]) {
            [self.fridayArray addObject:agendaItem];
        } else if ([agendaItem.day isEqualToString:@"Saturday"]) {
            [self.saturdayArray addObject:agendaItem];
        } else {
            [self.sundayArray addObject:agendaItem];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return self.fridayArray.count;
            break;
        case 1:
            return self.saturdayArray.count;
            break;
        case 2:
            return self.sundayArray.count;
        default:
            return self.agendaArray.count;
            break;
    }
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
    Agenda *currentAgendaItem;
    switch (indexPath.section) {
        case 0:
           currentAgendaItem = [self.fridayArray objectAtIndex:indexPath.row];
            break;
        case 1:
            currentAgendaItem = [self.saturdayArray objectAtIndex:indexPath.row];
            break;
        case 2:
            currentAgendaItem = [self.sundayArray objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    [agendaCell layoutWithWidth:CGRectGetWidth(tableView.bounds)];
    agendaCell.agendaItem = currentAgendaItem.title;
    agendaCell.agendaLocation = currentAgendaItem.location;
    NSString *agendaItemTime = currentAgendaItem.time;
    agendaCell.agendaTime = [NSString stringWithFormat:@"%@", agendaItemTime];
    agendaCell.agendaImage = [UIImage imageNamed:currentAgendaItem.type];
    agendaCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

@end
