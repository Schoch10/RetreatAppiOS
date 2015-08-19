//
//  ViewCheckinsTableViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 8/18/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "ViewCheckinsTableViewController.h"
#import "CoreDataManager.h"
#import "SettingsManager.h"
#import "Checkin.h"
#import "Location+Extensions.h"
#import "CheckedInTableViewCell.h"

static  NSString * const SBRCHECKEDINCELL = @"CheckedinTableCell";


@interface ViewCheckinsTableViewController ()

@end

@implementation ViewCheckinsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CheckedInTableViewCell" bundle:nil] forCellReuseIdentifier:SBRCHECKEDINCELL];
    self.title = @"Check-ins";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeViewCheckinsModal)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)closeViewCheckinsModal {
    [self.delegate dismissViewCheckinsTableViewController];
}

- (NSFetchedResultsController *)checkinFetchedResultsController {
    if (_checkinFetchedResultsController != nil) {
        return _checkinFetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    CoreDataManager *sharedManaged = [CoreDataManager sharedManager];
    NSManagedObjectContext *mangedObjectContext = sharedManaged.mainThreadManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Checkin" inManagedObjectContext:mangedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"checkinID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(checkinLocation.locationId == %@)", self.locationId];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *checkinFetchRequest = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:mangedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    checkinFetchRequest.delegate = self;
    self.checkinFetchedResultsController = checkinFetchRequest;
    
    NSError *error = nil;
    if (![self.checkinFetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _checkinFetchedResultsController;
    
}

#pragma mark Fetched Results Controller Delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.checkinFetchedResultsController.sections[section] numberOfObjects];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckedInTableViewCell *checkinCell = [self.tableView dequeueReusableCellWithIdentifier:SBRCHECKEDINCELL forIndexPath:indexPath];
    
    Checkin *checkins = [self.checkinFetchedResultsController objectAtIndexPath:indexPath];
    checkinCell.checkinName = [checkins.username stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
    checkinCell.checkinTime = [NSString stringWithFormat:@"%@", checkins.checkinDate];
    
    return checkinCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [CheckedInTableViewCell estimatedHeight];
}

@end
