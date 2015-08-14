//
//  PostsTableViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/17/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "PostsTableViewCell.h"

@implementation PostsTableViewCell

- (void)awakeFromNib
{
    // Workaround for iOS 8 behavior where table view separators don't start flush with the left margin
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

@end
