//
//  ViewCheckinsTableViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 8/18/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@protocol ViewCheckinsControllerDelegate <NSObject>

- (void)dismissViewCheckinsTableViewController;

@end

@interface ViewCheckinsTableViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSFetchedResultsController *checkinFetchedResultsController;
@property (nonatomic, strong) NSNumber *locationId;
@property (nonatomic, weak) id<ViewCheckinsControllerDelegate> delegate;

@end
