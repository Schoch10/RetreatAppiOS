//
//  TrendingModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingModalViewController.h"
#import "CheckedInTableViewCell.h"
#import "PostsTableViewCell.h"
#import "GetPostsForLocationOperation.h"
#import "ServiceCoordinator.h"
#import "CoreDataManager.h"
#import "Post.h"
#import "User.h"
#import "Checkin.h"

static  NSString * const SBRCHECKEDINCELL = @"CheckedinTableCell";
static  NSString * const SBRPOSTSCELL = @"PostsTableCell";


@interface TrendingModalViewController () <UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavigationConstraint;

@property (weak, nonatomic) IBOutlet UITabBar *trendingInformationTab;
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;
@property (nonatomic) BOOL isCheckedInView;


- (IBAction)closeModalSelected:(id)sender;
@end

@implementation TrendingModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view removeConstraint:self.topNavigationConstraint];
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:newTopConstraint];
    
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"CheckedInTableViewCell" bundle:nil] forCellReuseIdentifier:SBRCHECKEDINCELL];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"PostsTableViewCell" bundle:nil] forCellReuseIdentifier:SBRPOSTSCELL];
    self.isCheckedInView = NO;
    [self getPostsForLocation];
    
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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    // Edit the entity name as appropriate.
    
    CoreDataManager *sharedManaged = [CoreDataManager sharedManager];
    NSManagedObjectContext *mangedObjectContext = sharedManaged.mainThreadManagedObjectContext;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Post" inManagedObjectContext:mangedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"postID" ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(locationId == %@)", self.locationId];
    
    
    [fetchRequest setSortDescriptors:sortDescriptors];
    [fetchRequest setPredicate:predicate];
    
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

#pragma mark Fetched Results Controller Delegate


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.trendingTableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.trendingTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.trendingTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self.trendingTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [self.trendingTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.trendingTableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id )sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.trendingTableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.trendingTableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
        default:
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.trendingTableView endUpdates];
}


- (void)getPostsForLocation {
    GetPostsForLocationOperation *getPostsLocationOperation = [[GetPostsForLocationOperation alloc]initGetPostsOperationForLocationId:self.locationId];
    [ServiceCoordinator addNetworkOperation:getPostsLocationOperation priority:CMTTaskPriorityHigh];
    
}

- (IBAction)closeModalSelected:(id)sender {
    [self.delegate dismissTrendingModalViewController];
}

#pragma mark UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.fetchedResultsController sections].count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.isCheckedInView) {
        return [self.checkinFetchedResultsController.sections[section] numberOfObjects];
    } else {
        return [self.fetchedResultsController.sections[section] numberOfObjects];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCheckedInView) {
        return [self.trendingTableView dequeueReusableCellWithIdentifier:SBRCHECKEDINCELL forIndexPath:indexPath];
    } else {
        return [self.trendingTableView dequeueReusableCellWithIdentifier:SBRPOSTSCELL forIndexPath:indexPath];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCheckedInView) {
        return [CheckedInTableViewCell estimatedHeight];
    } else {
        return 250.0f;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(self.isCheckedInView) {
        CheckedInTableViewCell *checkinCell = (CheckedInTableViewCell *)cell;
        [checkinCell layoutWithWidth:CGRectGetWidth(self.trendingTableView.bounds)];
        Checkin *checkins = [self.checkinFetchedResultsController objectAtIndexPath:indexPath];
        checkinCell.checkinName = [checkins.username stringByReplacingOccurrencesOfString:@"%20" withString:@" "];;
        checkinCell.checkinTime = [NSString stringWithFormat:@"%@", checkins.checkinDate];
    } else {
       PostsTableViewCell *postsCell = (PostsTableViewCell *)cell;
        Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        postsCell.postTextLabel.text = [post.comment stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        postsCell.userLabel.text = [NSString stringWithFormat:@"%@", post.userid];
    }
    
}

#pragma mark UITabBarDelegate Methods

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag) {
        case 0:
            self.isCheckedInView = NO;
            [self.trendingTableView reloadData];
            break;
        case 1:
            self.isCheckedInView = YES;
            [self.trendingTableView reloadData];
            break;
        default:
            break;
    }
}

#pragma mark UINavigationBar delegate methods

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
