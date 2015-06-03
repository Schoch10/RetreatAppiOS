//
//  CreateUserViewController.m
//  RetreatApp
//
//  Created by Brendan Schoch on 5/29/15.
//  Copyright (c) 2015 Slalom Consulting. All rights reserved.
//

#import "CreateUserViewController.h"
#import "SettingsManager.h"
#import "HomeViewController.h"

@interface CreateUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) NSString *firstNameString;
- (IBAction)saveButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)chooseUserImageSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create User";
    self.saveButton.enabled = NO;
}

- (IBAction)saveButtonSelected:(id)sender {

    if (self.firstNameTextField.text) {
        self.firstNameString = self.firstNameTextField.text;
        SettingsManager *settings = [SettingsManager sharedManager];
        settings.username = self.firstNameString;
    }
    
    HomeViewController *homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
    self.navigationController.viewControllers = [NSArray arrayWithObject:homeView];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

#pragma mark Text Field Delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (self.firstNameTextField.text) {
        self.saveButton.enabled = YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.firstNameTextField resignFirstResponder];
    return YES;
}

#pragma mark UIImagePickerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *userImage = info[UIImagePickerControllerEditedImage];
    self.userImageView.image = userImage;
    NSData *imageData = UIImagePNGRepresentation(userImage);
    SettingsManager *sharedSettings = [SettingsManager sharedManager];
    sharedSettings.userImage = imageData;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)chooseUserImageSelected:(id)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:NULL];
}
@end
