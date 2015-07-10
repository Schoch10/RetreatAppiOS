//
//  TrendingLocationCarouselCell.h
//  RetreatApp
//
//  Created by Quinn MacKenzie on 7/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTrendingLocationCarouselCellIdentifier @"kTrendingLocationCarouselCellIdentifier"

@interface TrendingLocationCarouselCell : UICollectionViewCell

@property (nonatomic, weak) IBOutlet UILabel *locationName;
@property (nonatomic, weak) IBOutlet UIImageView *imageView;

@end
