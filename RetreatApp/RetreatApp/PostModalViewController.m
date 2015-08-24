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
#import "SVProgressHUD/SVProgressHUD.h"

@interface PostModalViewController () <UINavigationBarDelegate, DoPostForLocationDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topNavigationConstraint;

@property (strong, nonatomic) UIImage *imageToPost;
@property (weak, nonatomic) IBOutlet UIImageView *imageToPostImageView;
@property (weak, nonatomic) IBOutlet UITextView *commentTextView;


- (void)selectImageButtonSelected;
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
    self.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationBar.barStyle = UIBarStyleBlack;

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.commentTextView becomeFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated {
    [SVProgressHUD dismiss];
}

- (void)selectImageButtonSelected {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];

}

- (IBAction)postButtonSelected:(id)sender {
    NSString *nonAttributedString = self.commentTextView.text;
    SCLogMessage(kLogLevelDebug, @"non attributed String %@", nonAttributedString);
    NSString* encodedPost = [nonAttributedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *cleanedEncodeForAttributedString = [encodedPost stringByReplacingOccurrencesOfString:@"%EF%BF%BC%0A" withString:@""];
    NSString *cleanedEncodeFoNoText = [cleanedEncodeForAttributedString stringByReplacingOccurrencesOfString:@"%EF%BF%BC" withString:@""];
    SettingsManager *sharedManager = [SettingsManager sharedManager];
    if (self.imageToPost != nil) {
        DoPostForLocation *doPostForLocationImageOperation = [[DoPostForLocation alloc]initDoPostForUser:sharedManager.userId forLocation:self.locationId withText:cleanedEncodeFoNoText withImage:UIImageJPEGRepresentation(self.imageToPost, 1.0)];
        doPostForLocationImageOperation.doPostForLocationDelegate = self;
        [ServiceCoordinator addNetworkOperation:doPostForLocationImageOperation priority:CMTTaskPriorityHigh];
    } else {
        DoPostForLocation *doPostForLocationOperation = [[DoPostForLocation alloc]initDoPostForUser:sharedManager.userId forLocation:self.locationId withText:cleanedEncodeFoNoText];
        doPostForLocationOperation.doPostForLocationDelegate = self;
        [ServiceCoordinator addNetworkOperation:doPostForLocationOperation priority:CMTTaskPriorityHigh];
    }
}

- (void)showAlertForPostContent {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Please Complete Post!"
                                                                   message:@"Please add a picture or text to the post"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark DoPostForLocationDelegate

- (void)doPostForLocationDidSucceed {
    [self.delegate dismissPostModalViewController];
}

- (void)doPostForLocationDidFailWithError:(NSError *)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Success!"
                                                                   message:@"You Have Successfully Posted Please Check the Wall"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    self.imageToPost = info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:NULL];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = self.imageToPost;
    CGFloat oldWidth = textAttachment.image.size.width;
    //I'm subtracting 10px to make the image display nicely, accounting
    //for the padding inside the textView
    CGFloat scaleFactor = oldWidth / (self.commentTextView.frame.size.width - 10);
    textAttachment.image = [UIImage imageWithCGImage:textAttachment.image.CGImage scale:scaleFactor orientation:UIImageOrientationUp];
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    self.commentTextView.attributedText = attrStringWithImage;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

#pragma mark UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    [self.commentTextView resignFirstResponder];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.selectedRange = NSMakeRange(0, 0);
    if ([textView.text isEqualToString:@"What's on your mind?"]) {
        textView.textColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0f];
    }
    UIView *accessoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40.0)];
    accessoryView.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.94 alpha:1.0f];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(selectImageButtonSelected)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"Photo" forState:UIControlStateNormal];
    button.frame = CGRectMake(5.0, 5.0, 50.0, 30.0);
    [accessoryView addSubview:button];
    self.commentTextView.inputAccessoryView = accessoryView;
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([textView.text isEqualToString:@"What's on your mind?"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
    return YES;
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
