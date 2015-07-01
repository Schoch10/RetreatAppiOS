//
//  TrendingModalViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TrendingModalViewDelegate <NSObject>

- (void)dismissTrendingModalViewController;

@end

@interface TrendingModalViewController : UIViewController <UITabBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) id<TrendingModalViewDelegate> delegate;

@end
