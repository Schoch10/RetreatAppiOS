//
//  PostsTableViewCell.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/17/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UITextView *postTextLabel;

@end
