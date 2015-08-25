//
//  TrendingModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingModalViewController.h"
#import "PostsTableViewCell.h"
#import "GetPostsForLocationOperation.h"
#import "ServiceCoordinator.h"
#import "CoreDataManager.h"
#import "Post.h"
#import "User.h"
#import "Checkin.h"
#import "Checkin+Extensions.h"
#import "ServiceCoordinator.h"
#import "SettingsManager.h"
#import "CheckinOperation.h"
#import "PostModalViewController.h"
#import "SVProgressHUD/SVProgressHUD.h"
#import "ViewCheckinsTableViewController.h"
#import "PollParticipantLocationsOperation.h"
#import "SaveImageLocalOperation.h"

static  NSString * const SBRPOSTSCELL = @"PostsTableCell";


@interface TrendingModalViewController () <UINavigationBarDelegate, PostModalViewControllerDelegate, CheckinOperationDelegate, GetPostsForLocationDelegate, ViewCheckinsControllerDelegate, PollParticipantLocationServiceDelegate>
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;
@property (weak, nonatomic) IBOutlet UIButton *checkinPostButton;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (nonatomic) BOOL isCheckedInView;
- (IBAction)createPostButtonSelected:(id)sender;
@end

@implementation TrendingModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.trendingTableView registerNib:[UINib nibWithNibName:@"PostsTableViewCell" bundle:nil] forCellReuseIdentifier:SBRPOSTSCELL];
    self.trendingTableView.rowHeight = UITableViewAutomaticDimension;
    self.trendingTableView.estimatedRowHeight = 300.f;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:[self.totalCheckinsForLocations stringValue] style:UIBarButtonItemStylePlain target:self action:@selector(showCheckedInView)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    self.userImageView.image = [UIImage imageWithData:sharedSettings.userImage];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self getPostsForLocation];
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    if ([self.locationId intValue] == [sharedSettings.currentUserCheckinLocation intValue]) {
        [self.checkinPostButton setTitle:@"Checked-In, Write Something..." forState:UIControlStateNormal];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.fetchedResultsController = nil;
    [SVProgressHUD dismiss];
}

- (void)showCheckedInView {
     ViewCheckinsTableViewController *viewCheckinsController = [[ViewCheckinsTableViewController alloc]initWithNibName:@"ViewCheckinsTableViewController" bundle:nil];
     viewCheckinsController.modalPresentationStyle = UIModalPresentationFullScreen;
     viewCheckinsController.locationId = self.locationId;
     viewCheckinsController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
     viewCheckinsController.delegate = self;
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewCheckinsController];
     [self presentViewController:navController animated:YES completion:nil];
}

#pragma mark View Checkins Delegate

- (void)dismissViewCheckinsTableViewController {
    [self dismissViewControllerAnimated:YES completion:^(void){}];
}

- (void)checkinSelected {
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    CheckinOperation *checkinOperation = [[CheckinOperation alloc]initCheckinOperationWithLocationForUser:sharedManager.userId withLocation:self.locationId];
    checkinOperation.checkinOperationDelegate = self;
    [ServiceCoordinator addNetworkOperation:checkinOperation priority:CMTTaskPriorityHigh];
}

- (void)getCheckinsForLocation {
    PollParticipantLocationsOperation *pollCheckins = [[PollParticipantLocationsOperation alloc]initPollParticipantOperation];
    pollCheckins.pollParticipantDelegate = self;
    [ServiceCoordinator addNetworkOperation:pollCheckins priority:CMTTaskPriorityMedium];
}

#pragma mark Poll Participant Delegate

- (void)pollParticipantLocationDidSucceed {
    NSManagedObjectContext *managedObjectContext = [CoreDataManager sharedManager].mainThreadManagedObjectContext;
    NSInteger checkinCount = [Checkin getCheckinCountForLocation:self.locationId inManagedObjectContext:managedObjectContext];
    [self.navigationItem.rightBarButtonItem setTitle:[NSString stringWithFormat:@"%li", (long)checkinCount]];
}

- (void)pollParticipantLocationDidFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
}

#pragma mark Checkin Operation Delegate 

- (void)checkinOperationDidSucceed {

    SettingsManager *sharedManager = [SettingsManager sharedManager];
    sharedManager.currentUserCheckinLocation = self.locationId;
    [self.checkinPostButton setTitle:@"Checked-In, Write Something..." forState:UIControlStateNormal];
    sharedManager.currentCheckinLocationName = self.locationName;
    [self getCheckinsForLocation];

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

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        [NSFetchedResultsController deleteCacheWithName:@"posts"];
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
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:mangedObjectContext sectionNameKeyPath:nil cacheName:@"posts"];
    aFetchedResultsController.delegate = self;
    aFetchedResultsController.fetchRequest.fetchBatchSize = 20;
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
    [SVProgressHUD show];
    GetPostsForLocationOperation *getPostsLocationOperation = [[GetPostsForLocationOperation alloc]initGetPostsOperationForLocationId:self.locationId];
    getPostsLocationOperation.getPostsForLocationDelegate = self;
    [ServiceCoordinator addNetworkOperation:getPostsLocationOperation priority:CMTTaskPriorityHigh];
    
}

#pragma mark Get Posts For Location

- (void)getPostsForLocationDidSucceed {
    [SVProgressHUD dismiss];
    [self.trendingTableView reloadData];
}

- (void)getPostsForLocationDidFailWithError:(NSError *)error {
    [SVProgressHUD dismiss];
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:@"Could not Retrieve Posts Please Try Again"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    //Add Action To Try Again
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
    
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
        PostsTableViewCell *postsCell = [self.trendingTableView dequeueReusableCellWithIdentifier:SBRPOSTSCELL forIndexPath:indexPath];
        
        Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        NSString *usernameString = [post.username stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        NSString *postDate = [self formatPostDateForPostDate:post.postDate];
        postsCell.userLabel.text = usernameString;
        postsCell.timeStampLabel.text = postDate;
        postsCell.postTextLabel.text = [post.comment stringByReplacingOccurrencesOfString:@"%20" withString:@" "];
        if ([post.imageURL rangeOfString:@"http"].location == NSNotFound) {
            postsCell.postImageView.image = nil;
        } else {
            if (post.imageCache != nil) {
                postsCell.postImageView.image = [UIImage imageWithData:post.imageCache];
            } else {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^(void) {
                    NSURL *url = [NSURL URLWithString:post.imageURL];
                    NSData *data = [NSData dataWithContentsOfURL:url];
                    dispatch_sync(dispatch_get_main_queue(), ^(void) {
                        postsCell.postImageView.image = [UIImage imageWithData:data];
                    });
                });
            }
        }
        return postsCell;
}

- (void)saveImageToCacheForPost:(NSNumber *)postId withImageData:(NSData *)imageData {
    SaveImageLocalOperation *saveImageOperation = [[SaveImageLocalOperation alloc]initWithPostId:postId withImage:imageData];
    [ServiceCoordinator addLocalOperation:saveImageOperation completion:^(void){}];
}

- (NSString *)formatPostDateForPostDate:(NSDate *)postDate {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    NSTimeInterval postTimeInterval = [[NSDate date] timeIntervalSinceDate:postDate];
    int postTimeInt =  postTimeInterval;
    NSString *postDateString;
    int days = postTimeInt / 86400;
    int hours;
    int minutes;
    int seconds;
    if (days == 0) {
        hours = postTimeInt/3600;
    } else {
        hours = (postTimeInt % 86400) / 3600;
    }
    if (hours == 0) {
        minutes = postTimeInt/60;
    } else {
        minutes = (postTimeInt % 3600) / 60;
    }
    if (minutes == 0) {
        seconds = postTimeInt;
    } else {
        seconds = (postTimeInt % 3600) % 60;
    }
    if (minutes == 0 && hours == 0 & days == 0) {
        postDateString = @"Just Now";
    } else if (hours == 0 &&  days == 0) {
        postDateString = [NSString stringWithFormat:@"%d Minutes Ago", minutes];
    } else if (days == 0) {
        postDateString = [NSString stringWithFormat:@"%d Hours Ago", hours];
    } else {
        postDateString = [NSString stringWithFormat:@"%d Days Ago", days];
    }
    return postDateString;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    if ([post.imageURL rangeOfString:@"http"].location == NSNotFound) {
        return 270.0f;
    } else {
        return 100.0f;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self heightForImageCellAtIndexPath:indexPath];
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
    static PostsTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.trendingTableView dequeueReusableCellWithIdentifier:SBRPOSTSCELL];
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (void)configureImageCell:(PostsTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    Post *post = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.userLabel.text = post.username;
    cell.postTextLabel.text = post.comment;
    SCLogMessage(kLogLevelDebug, @"image URL %@", post.imageURL);
    if ([post.imageURL rangeOfString:@"http"].location == NSNotFound) {
        cell.postImageView.image = nil;
    } else {
        cell.postImageView.image = [UIImage imageNamed:@"me"];
    }
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

#pragma mark UINavigationBar delegate methods

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

- (IBAction)createPostButtonSelected:(id)sender {
    [self checkinSelected];
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    if ([self.locationId intValue] == [sharedSettings.currentUserCheckinLocation intValue]) {
        PostModalViewController *postViewController = [[PostModalViewController alloc]initWithNibName:@"PostModalViewController" bundle:nil];
        postViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        postViewController.locationId = self.locationId;
        postViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        postViewController.delegate = self;
        [self presentViewController:postViewController animated:YES completion:nil];
    }
}



#pragma mark Post Modal View Delegate

- (void)dismissPostModalViewController {
    [self dismissViewControllerAnimated:YES completion:^(void){
        [self getPostsForLocation];
    }];
    
}

@end
