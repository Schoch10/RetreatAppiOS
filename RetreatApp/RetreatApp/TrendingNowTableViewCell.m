//
//  TrendingNowTableViewCell.m
//  RetreatApp
//
//  Created by Quinn MacKenzie on 8/6/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "TrendingNowTableViewCell.h"

@interface TrendingNowTableViewCell ()

@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic, weak) IBOutlet UILabel *checkinLabel;

@end

@implementation TrendingNowTableViewCell

- (void)awakeFromNib {
    // Workaround for iOS 8 behavior where table view separators don't start flush with the left margin
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

- (void)configureWithLocation:(NSString *)location checkInText:(NSString *)checkInText imageURL:(NSString *)imageURL {
    self.locationLabel.text = location;
    self.checkinLabel.text = checkInText;
    
    // TODO: Setup image retrieval here
}

@end
