//
//  CheckedInTableViewCell.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckedInTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *checkinName;
@property (strong, nonatomic) UIImage *userImage;

+ (CGFloat)estimatedHeight;

@end
