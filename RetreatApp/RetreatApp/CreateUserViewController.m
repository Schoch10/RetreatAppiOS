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
#import "ServiceCoordinator.h"
#import "CreateUserNetworkOperation.h"

@interface CreateUserViewController () <CreateUserNetworkOperationDelegate>
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
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];

}

- (IBAction)saveButtonSelected:(id)sender {

    if (self.firstNameTextField.text) {
        self.saveButton.enabled = NO;
        self.firstNameString = [self.firstNameTextField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        SettingsManager *settings = [SettingsManager sharedManager];
        settings.username = self.firstNameTextField.text;
        CreateUserNetworkOperation *createUserNetworkOperation = [[CreateUserNetworkOperation alloc]initCreateUserOperationWithUsername:self.firstNameString];
        createUserNetworkOperation.createUserOperationDelegate = self;
        [ServiceCoordinator addNetworkOperation:createUserNetworkOperation priority:CMTTaskPriorityHigh];
        
    } else {
        return;
    }
}

#pragma mark Create User Network Operation Delegate

- (void)createUserNetworkOperationDidSucceedWithUserId:(NSNumber *)userId {
    if (userId) {
        SettingsManager *sharedManager = [SettingsManager sharedManager];
        sharedManager.userId = userId;
        HomeViewController *homeView = [[HomeViewController alloc]initWithNibName:@"HomeViewController" bundle:nil];
        self.navigationController.viewControllers = [NSArray arrayWithObject:homeView];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        NSError *error;
        [self presentCreateUserErrorView:error];
    }
}

- (void)createUserNetworkOperationDidFail:(NSError *)error {
    [self presentCreateUserErrorView:error];
}

- (void)presentCreateUserErrorView:(NSError *)error {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error!"
                                                                   message:@"User cannot be created please try again"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
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
