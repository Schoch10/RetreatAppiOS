//
//  TrendingNowTableViewCell.h
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/6/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTrendingNowCellIdentifier @"kTrendingNowCellIdentifier"

@interface TrendingNowTableViewCell : UITableViewCell

- (void)configureWithLocation:(NSString *)location checkInText:(NSString *)checkInText imageURL:(NSString *)imageURL;

@end
