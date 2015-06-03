//
//  AgendaTableViewCell.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgendaTableViewCell : UITableViewCell

@property (strong, nonatomic) NSString *agendaItem;
@property (strong, nonatomic) NSString *agendaLocation;
@property (strong, nonatomic) NSString *agendaTime;
@property (strong, nonatomic) UIImage *agendaImage;

+(CGFloat)estimatedHeight;
- (CGSize)layoutWithWidth:(CGFloat)width;

@end
