//
//  TextEntryCell.h
//  SlalomCommon
//
//  Created by Greg Martin on 11/27/11.
//  Copyright (c) 2011 Slalom, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum
{
    TextEntryCellStyleNormal,
    TextEntryCellStyleNoLabel,
} TextEntryCellStyle;

@interface TextEntryCell : UITableViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

+ (id)textEntryCellForTableView:(UITableView *)tableView;
+ (id)textEntryCellForTableView:(UITableView *)tableView withStyle:(TextEntryCellStyle)style;

@end
