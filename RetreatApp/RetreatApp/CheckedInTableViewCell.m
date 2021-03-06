//
//  CheckedInTableViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CheckedInTableViewCell.h"

@interface CheckedInTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@end

@implementation CheckedInTableViewCell

- (void)awakeFromNib
{
    // Workaround for iOS 8 behavior where table view separators don't start flush with the left margin
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

+ (CGFloat)estimatedHeight
{
    return 80.f;
}

- (void)setCheckinName:(NSString *)username
{
    if (username) {
        self.userNameLabel.text = username;
    }
}

- (void)setUserImage:(UIImage *)userImage
{
    if (userImage) {
        self.userImageView.image = userImage;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
