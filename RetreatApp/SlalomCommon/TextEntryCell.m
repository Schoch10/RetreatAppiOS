//
//  TextEntryCell.m
//  SlalomCommon
//
//  Created by Greg Martin on 11/27/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import "TextEntryCell.h"

@implementation TextEntryCell

@synthesize label;
@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self)
    {
        CGRect contentFrame = CGRectInset(self.contentView.frame, 15, 5);
        
        CGRect labelFrame = CGRectIntegral(CGRectMake(contentFrame.origin.x, contentFrame.origin.y, 79, contentFrame.size.height));
        
        self.label = [[UILabel alloc] initWithFrame:labelFrame];
        self.label.font = [UIFont systemFontOfSize:16];
        self.label.adjustsFontSizeToFitWidth = YES;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.label];
        
        int x = labelFrame.origin.x + labelFrame.size.width + 15;
        int width = self.contentView.frame.size.width - x - 5;
        
        CGRect textFieldFrame = CGRectIntegral(CGRectMake(x, contentFrame.origin.y,  width, contentFrame.size.height));
        
        self.textField = [[UITextField alloc] initWithFrame:textFieldFrame];
        self.textField.font = [UIFont systemFontOfSize:16];
        self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        self.textField.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        [self.contentView addSubview:self.textField];
    }
    
    return self;
}

- (BOOL)becomeFirstResponder
{
    return [self.textField becomeFirstResponder];
}

+ (id)textEntryCellForTableView:(UITableView *)tableView
{
    return [TextEntryCell textEntryCellForTableView:tableView withStyle:TextEntryCellStyleNormal];
}

+ (id)textEntryCellForTableView:(UITableView *)tableView withStyle:(TextEntryCellStyle)style
{
    TextEntryCell *cell = [[TextEntryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(style == TextEntryCellStyleNoLabel)
    {
        cell.label.hidden = YES;
        
        cell.textField.frame = CGRectIntegral(CGRectInset(cell.contentView.frame, 15, 5));
    }
    
    return cell;
}

@end
