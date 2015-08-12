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
#import "CoreDataManager.h"
#import "Location.h"
#import "Checkin.h"
#import "PollParticipantLocationsOperation.h"
#import "TrendingModalViewController.h"

@interface TrendingNowViewController () <UITableViewDataSource, UITableViewDelegate, PollParticipantLocationServiceDelegate >

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
    [self.tableView registerNib:[UINib nibWithNibName:@"TrendingNowTableViewCell" bundle:nil] forCellReuseIdentifier:kTrendingNowCellIdentifier];
    [self getPollLocations];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    CoreDataManager *sharedManaged = [CoreDataManager sharedManager];
    NSManagedObjectContext *mangedObjectContext = sharedManaged.mainThreadManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Location" inManagedObjectContext:mangedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"locationId" ascending:YES
                                        ];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:mangedObjectContext sectionNameKeyPath:nil cacheName:@"Master"];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

#pragma mark Poll Participant Locations

- (void)getPollLocations {
    PollParticipantLocationsOperation *pollParticipantOperation = [[PollParticipantLocationsOperation alloc]initPollParticipantOperation];
    pollParticipantOperation.pollParticipantDelegate = self;
    CMTTaskPriority priority = CMTTaskPriorityHigh;
    [ServiceCoordinator addNetworkOperation:pollParticipantOperation priority:priority];
}

- (void)pollParticipantLocationDidSucceed {
    SCLogMessage(kLogLevelDebug, @"Worked");
}

- (void)pollParticipantLocationDidFailWithError:(NSError *)error {
    SCLogMessage(kLogLevelDebug, @"Error");
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
 

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.fetchedResultsController.sections[section] numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TrendingNowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTrendingNowCellIdentifier forIndexPath:indexPath];
    
    Location *location = [self.fetchedResultsController objectAtIndexPath:indexPath];
    NSString *checkInString = [NSString stringWithFormat:@"%@ checkins", @(location.checkin.count)];
    [cell configureWithLocation:location.locationName checkInText:checkInString imageURL:nil];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   TrendingCarouselViewController *trendingViewController = [[TrendingCarouselViewController alloc] initWithNibName:nil bundle:nil];
    trendingViewController.currentIndex = @(indexPath.row + 1);
    [self.navigationController pushViewController:trendingViewController animated:YES];
}

@end
