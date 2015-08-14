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
#import "ServiceCoordinator.h"
#import "SettingsManager.h"
#import "CheckinOperation.h"
#import "PostModalViewController.h"

static  NSString * const SBRCHECKEDINCELL = @"CheckedinTableCell";
static  NSString * const SBRPOSTSCELL = @"PostsTableCell";


@interface TrendingModalViewController () <UINavigationBarDelegate, PostModalViewControllerDelegate, CheckinOperationDelegate>
@property (weak, nonatomic) IBOutlet UITabBar *trendingInformationTab;
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;
- (IBAction)createPostButtonSelected:(id)sender;
@property (nonatomic) BOOL isCheckedInView;
@end

@implementation TrendingModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"CheckedInTableViewCell" bundle:nil] forCellReuseIdentifier:SBRCHECKEDINCELL];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"PostsTableViewCell" bundle:nil] forCellReuseIdentifier:SBRPOSTSCELL];
    self.trendingTableView.rowHeight = UITableViewAutomaticDimension;
    self.trendingTableView.estimatedRowHeight = 300.f;
    self.isCheckedInView = NO;
    self.title = @"Location Title";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Checkin" style:UIBarButtonItemStylePlain target:self action:@selector(checkinSelected)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    [self getPostsForLocation];
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    if ([sharedSettings.currentUserCheckinLocation intValue] == [self.locationId intValue]) {
        self.navigationItem.rightBarButtonItem.title = @"CheckedIn";
        self.navigationItem.rightBarButtonItem.enabled = NO;
    }
}

- (void)checkinSelected {
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    CheckinOperation *checkinOperation = [[CheckinOperation alloc]initCheckinOperationWithLocationForUser:sharedManager.userId withLocation:self.locationId];
    checkinOperation.checkinOperationDelegate = self;
    [ServiceCoordinator addNetworkOperation:checkinOperation priority:CMTTaskPriorityHigh];
}

#pragma mark Checkin Operation Delegate 

- (void)checkinOperationDidSucceed {

    self.navigationItem.rightBarButtonItem.title = @"Checked In";
    self.navigationItem.rightBarButtonItem.enabled = NO;
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    sharedManager.currentUserCheckinLocation = self.locationId;

}

- (void)checkinOperationDidFailWithError:(NSError *)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:@"Could not Checkin Please Try Again"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
    if (self.isCheckedInView)
    {
        CheckedInTableViewCell *checkinCell = [self.trendingTableView dequeueReusableCellWithIdentifier:SBRCHECKEDINCELL forIndexPath:indexPath];
        
        [checkinCell layoutWithWidth:CGRectGetWidth(self.trendingTableView.bounds)];
        Checkin *checkins = [self.checkinFetchedResultsController objectAtIndexPath:indexPath];
        checkinCell.checkinName = [checkins.username stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        checkinCell.checkinTime = [NSString stringWithFormat:@"%@", checkins.checkinDate];
        
        return checkinCell;
    }
    else
    {
        PostsTableViewCell *postsCell = [self.trendingTableView dequeueReusableCellWithIdentifier:SBRPOSTSCELL forIndexPath:indexPath];
        
        Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *usernameString = [post.username stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        postsCell.userLabel.text = [NSString stringWithFormat:@"Posted by: %@", usernameString];
        postsCell.postTextLabel.text = [post.comment stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        
        return postsCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isCheckedInView) {
        return [CheckedInTableViewCell estimatedHeight];
    } else {
        return UITableViewAutomaticDimension;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
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

- (IBAction)createPostButtonSelected:(id)sender {
    PostModalViewController *postViewController = [[PostModalViewController alloc]initWithNibName:@"PostModalViewController" bundle:nil];
    postViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    postViewController.locationId = self.locationId;
    postViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    postViewController.delegate = self;
    [self presentViewController:postViewController animated:YES completion:nil];
}

#pragma mark Post Modal View Delegate

- (void)dismissPostModalViewController {
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self getPostsForLocation];
    }];
    
}

@end
