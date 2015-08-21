//
//  TrendingModalViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol TrendingModalViewDelegate <NSObject>

- (void)dismissTrendingModalViewController;

@end

@interface TrendingModalViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, weak) id<TrendingModalViewDelegate> delegate;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSFetchedResultsController *checkinFetchedResultsController;
@property (nonatomic, strong) NSNumber *locationId;
@property (nonatomic, strong) NSNumber *totalCheckinsForLocations;
@property (nonatomic, strong) NSString *locationName;
@end
