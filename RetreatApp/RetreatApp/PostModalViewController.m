//
//  PostModalViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 6/1/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "PostModalViewController.h"
#import "DoPostForLocation.h"
#import "SettingsManager.h"

@interface PostModalViewController () <UINavigationBarDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavigationConstraint;

@property (strong, nonatomic) UIImage *imageToPost;
@property (weak, nonatomic) IBOutlet UIImageView *imageToPostImageView;
@property (weak, nonatomic) IBOutlet UIButton *postButton;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


- (IBAction)selectImageButtonSelected:(id)sender;
- (IBAction)postButtonSelected:(id)sender;
- (IBAction)cancelPostSelected:(id)sender;

@end

@implementation PostModalViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view removeConstraint:self.topNavigationConstraint];
    NSLayoutConstraint *newTopConstraint = [NSLayoutConstraint constraintWithItem:self.navigationBar attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    [self.view addConstraint:newTopConstraint];
}

- (IBAction)selectImageButtonSelected:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)postButtonSelected:(id)sender {
    NSString* encodedPost = [self.commentTextView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ;
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    DoPostForLocation *doPostForLocationOperation = [[DoPostForLocation alloc]initDoPostForUser:sharedManager.userId forLocation:@(3) withText:encodedPost];
    [ServiceCoordinator addNetworkOperation:doPostForLocationOperation priority:CMTTaskPriorityHigh];
    [self.delegate dismissPostModalViewController];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageToPost = info[UIImagePickerControllerEditedImage];
    self.imageToPostImageView.image = self.imageToPost;
    [picker dismissViewControllerAnimated:YES completion:NULL];
    self.postButton.enabled = YES;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}

- (IBAction)cancelPostSelected:(id)sender {
    [self.delegate dismissPostModalViewController];
}

#pragma mark UINavigationBar delegate methods

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
