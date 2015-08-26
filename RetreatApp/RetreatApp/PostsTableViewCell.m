//
//  PostsTableViewCell.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/17/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "PostsTableViewCell.h"
#import "UIImage+Loading.h"
#import "UIImageView+Loading.h"

@interface PostsTableViewCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *zeroHeightImageConstraint;

@end

@implementation PostsTableViewCell

- (void)awakeFromNib
{
    // Workaround for iOS 8 behavior where table view separators don't start flush with the left margin
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
}

- (void)prepareForReuse
{
    self.imageView.image = nil;
    self.downloadImageOperation.delegate = nil;
}

- (void)configureImageWithURL:(NSString *)imageURL
{
    self.postImageView.image = nil;
    
    if ([imageURL rangeOfString:@"http"].location == NSNotFound) {
        self.zeroHeightImageConstraint.active = YES;
    } else {
        self.zeroHeightImageConstraint.active = NO;
        [DownloadImageOperation asyncImageUri:imageURL delegate:self completion:^(UIImage *image) {
            if (image) // If we have the image already cached, set it right away
            {
                [self.postImageView setImage:image];
            }
        }];
    }
}

#pragma mark - DownloadImageOperationDelegate Methods

- (void)downloadImageOperationDidSucceedWithUserInfo:(NSDictionary *)userInfo
{
    [UIImage asyncImageInCachesDirectory:[userInfo objectForKey:kImagePathKey] completion:^(UIImage *image) {
        
        if (image)
        {
            [self.postImageView setImageAnimated:image];
        }
    }];
}

@end
