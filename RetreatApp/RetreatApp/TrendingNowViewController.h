//
//  TrendingNowViewController.h
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/6/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface TrendingNowViewController : UIViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
