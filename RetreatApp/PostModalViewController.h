//
//  PostModalViewController.h
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostModalViewControllerDelegate <NSObject>

- (void)dismissPostModalViewController;

@end

@interface PostModalViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (strong, nonatomic) id<PostModalViewControllerDelegate> delegate;

@end
