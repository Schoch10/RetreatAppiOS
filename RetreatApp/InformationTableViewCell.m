//
//  InformationTableViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/2/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "InformationTableViewCell.h"

@interface InformationTableViewCell()
@property (weak, nonatomic) IBOutlet UITextView *informationTextView;
@end

@implementation InformationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setInformationString:(NSString *)informationString
{
    if (informationString) {
        _informationString = informationString;
        self.informationTextView.text = informationString;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
