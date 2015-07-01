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
@property (weak, nonatomic) IBOutlet UILabel *checkinTimeLabel;

@end

@implementation CheckedInTableViewCell

- (void)awakeFromNib {
}

+ (CGFloat)estimatedHeight
{
    return 80.f;
}

- (CGSize)layoutWithWidth:(CGFloat)width
{
    if (CGRectGetWidth(self.contentView.frame) != width) {
        self.contentView.frame = CGRectMake(0, 0, width, CGRectGetHeight(self.contentView.frame));
        [self.contentView setNeedsLayout];
    }
    [self layoutSubviews];
    
    CGSize compressedSize = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return CGSizeMake(width, compressedSize.height);
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

- (void)setCheckinTime:(NSString *)checkinTime
{
    if (checkinTime) {
        self.checkinTimeLabel.text = checkinTime;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
