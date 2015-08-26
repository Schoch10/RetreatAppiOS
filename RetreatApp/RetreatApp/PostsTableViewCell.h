//
//  PostsTableViewCell.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/17/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DownloadImageOperation.h"

@interface PostsTableViewCell : UITableViewCell <DownloadImageOperationDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *postTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *postImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeStampLabel;

@property (strong) DownloadImageOperation *downloadImageOperation;

- (void)configureImageWithURL:(NSString *)imageURL;

@end
