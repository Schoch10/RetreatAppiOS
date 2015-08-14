//
//  AgendaTableViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "AgendaTableViewCell.h"

@interface AgendaTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *agendaItemImageView;
@property (weak, nonatomic) IBOutlet UILabel *agendaItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *agendaItemLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *agendaTimeLabel;

@end

@implementation AgendaTableViewCell

- (void)awakeFromNib
{
    // Workaround for iOS 8 behavior where table view separators don't start flush with the left margin
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

+ (CGFloat)estimatedHeight
{
    return 116.f;
}

- (void)setAgendaItem:(NSString *)agendaItem
{
    if (agendaItem) {
        self.agendaItemLabel.text = agendaItem;
    }
}

- (void)setAgendaLocation:(NSString *)agendaLocation
{
    if (agendaLocation) {
        self.agendaItemLocationLabel.text = agendaLocation;
    }
}

- (void)setAgendaImage:(UIImage *)agendaImage
{
    if (agendaImage) {
        self.agendaItemImageView.image = agendaImage;
    }
}

- (void)setAgendaTime:(NSString *)agendaTime
{
    if (agendaTime) {
        self.agendaTimeLabel.text = agendaTime;
    }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
