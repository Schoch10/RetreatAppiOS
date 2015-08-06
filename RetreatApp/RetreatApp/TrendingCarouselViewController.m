//
//  TrendingViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/28/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingCarouselViewController.h"
#import "TrendingLocationCarouselCell.h"
#import "TrendingModalViewController.h"
#import "CheckinViewController.h"
#import "UIView+Position.h"

#define kBannerScrollTime 8

@interface TrendingCarouselViewController ()
{
    NSTimer *bannerTimer;
}

- (IBAction)checkInButtonSelected:(id)sender;
- (IBAction)postButtonSelected:(id)sender;
- (void)trendingAreaSelected:(id)sender;

@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) NSArray *dataSource; // TODO: Set up data source.  Placeholder for now.

@end

@implementation TrendingCarouselViewController

- (void)populateTestData
{
#define kLocationNameKey @"kLocationNameKey"
    
    self.dataSource = @[
                        @{ kLocationNameKey : @"Pool" },
                        @{ kLocationNameKey : @"Bar" },
                        @{ kLocationNameKey : @"Golf" },
                        ];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Trending";
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"TrendingLocationCarouselCell" bundle:nil] forCellWithReuseIdentifier:kTrendingLocationCarouselCellIdentifier];
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.infinityEnabled = YES;
    self.collectionView.minCellsForScroll = 1;
    
    [self populateTestData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.dataSource.count < 1) {
        [self.activityIndicator startAnimating];
    }
    
    if (!self.hasLoadedData) {
        [self reloadCollectionView];
    }
    
    [self.collectionView.collectionViewLayout invalidateLayout];
    
    [self registerTimer];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.collectionView reloadData];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [bannerTimer invalidate];
}

- (void)reloadCollectionView
{
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *itemData = [self objectAtInfiniteIndexPath:indexPath];
    
    [self trendingAreaSelected:itemData[kLocationNameKey]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TrendingLocationCarouselCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:kTrendingLocationCarouselCellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dataItem = [self objectAtInfiniteIndexPath:indexPath];
    
    // Populate cell data here
    cell.locationName.text = dataItem[kLocationNameKey];
    
    return cell;
}

#pragma mark - CollectionView Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.collectionView.infinityEnabled && self.dataSource.count >= self.collectionView.minCellsForScroll)
    {
        return self.dataSource.count * kInfiniteScrollMultiplier;
    }
    else
    {
        return self.dataSource.count;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > 1)
    {
        [self.activityIndicator stopAnimating];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return collectionView.frameSize;
}

#pragma mark - Action methods

- (IBAction)checkInButtonSelected:(id)sender {
    CheckinViewController *checkinViewController = [[CheckinViewController alloc]initWithNibName:@"CheckinViewController" bundle:nil];
    checkinViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    checkinViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    checkinViewController.delegate = self;
    [self presentViewController:checkinViewController animated:YES completion:nil];
}

- (IBAction)postButtonSelected:(id)sender {
    PostModalViewController *postViewController = [[PostModalViewController alloc]initWithNibName:@"PostModalViewController" bundle:nil];
    postViewController.modalPresentationStyle = UIModalPresentationFullScreen;
    postViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    postViewController.delegate = self;
    [self presentViewController:postViewController animated:YES completion:nil];
}

- (void)trendingAreaSelected:(id)sender {
    TrendingModalViewController *trendingModalview = [[TrendingModalViewController alloc]initWithNibName:@"TrendingModalViewController" bundle:nil];
    trendingModalview.modalPresentationStyle = UIModalPresentationFullScreen;
    trendingModalview.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    trendingModalview.delegate = self;
    [self presentViewController:trendingModalview animated:YES completion:nil];
}

- (void)dismissTrendingModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissCheckinModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dismissPostModalViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Banner Sliding

- (void)slideBanner
{
    if (bannerTimer.isValid && self.dataSource.count > 0 && !self.collectionView.isDragging)
    {
        NSIndexPath *visibleIndexPath = [[self.collectionView indexPathsForVisibleItems] lastObject];
        NSInteger nextRow = (visibleIndexPath.row == (self.dataSource.count * kInfiniteScrollMultiplier) - 1 ? 0 : visibleIndexPath.row + 1);
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextRow inSection:visibleIndexPath.section];
        
        UICollectionViewScrollPosition scrollPosition = UICollectionViewScrollPositionCenteredHorizontally;
        
        [self.collectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:scrollPosition animated:(nextRow > 0)];
    }
}

- (void)registerTimer
{
    if (self.dataSource.count > 1)
    {
        [bannerTimer invalidate];
        
        bannerTimer = [NSTimer scheduledTimerWithTimeInterval:kBannerScrollTime target:self selector:@selector(slideBanner) userInfo:nil repeats:YES];
    }
}

#pragma mark - UIScrollView Methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [bannerTimer invalidate];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self registerTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self registerTimer];
}

#pragma mark - Helpers for Infinite Scrolling

- (NSInteger)nonInfiniteItemPositionForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger count = self.dataSource.count;
    if (count > 0)
    {
        return (indexPath.row % count);
    }
    else
    {
        return 0;
    }
}

- (id)objectAtInfiniteIndexPath:(NSIndexPath *)indexPath
{
    if (self.collectionView.infinityEnabled && self.dataSource.count >= self.collectionView.minCellsForScroll)
    {
        return [self.dataSource objectAtIndex:(indexPath.row % self.dataSource.count)];
    }
    else
    {
        return [self.dataSource objectAtIndex:indexPath.row];
    }
}

@end
