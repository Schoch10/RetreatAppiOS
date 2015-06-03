//
//  CheckinViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CheckinModalViewControllerDelegate <NSObject>

- (void)dismissCheckinModalViewController;

@end

@interface CheckinViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) id<CheckinModalViewControllerDelegate> delegate;

@end
