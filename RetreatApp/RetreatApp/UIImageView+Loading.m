//
//  UIImageView+Loading.m
//  SlalomCommon
//
//  Created by Greg Martin on 8/9/13.
//  Copyright (c) 2013 Slalom, LLC. All rights reserved.
//

#import "UIImageView+Loading.h"

@implementation UIImageView (Loading)

- (void)setImageAnimated:(UIImage *)image
{
    if (self.image != image)
    {
        self.image = nil;
        [UIView transitionWithView:self duration:(kDefaultAnimationDuration / 2) options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            self.image = image;
        } completion:nil];
    }
}

@end
