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
#import "SVProgressHUD/SVProgressHUD.h"

@interface CreateUserViewController () <CreateUserNetworkOperationDelegate>
@property (weak, nonatomic) IBOutlet UITextField *firstNameTextField;
@property (strong, nonatomic) NSString *firstNameString;
- (IBAction)saveButtonSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
- (IBAction)chooseUserImageSelected:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *selectImageButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CreateUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Create User";
    self.saveButton.enabled = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self drawBorders];
}

- (void)drawBorders {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.frame = CGRectMake(0.0f, self.firstNameTextField.frame.size.height - 1, self.firstNameTextField.frame.size.width, 1.0f);
    bottomBorder.backgroundColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f].CGColor;
    [self.firstNameTextField.layer addSublayer:bottomBorder];
    CALayer *nameBorder = [CALayer layer];
    nameBorder.frame = CGRectMake(0.0f, self.nameLabel.frame.size.height - 1, self.nameLabel.frame.size.width, 1.0f);
    nameBorder.backgroundColor = [UIColor colorWithRed:0.0 green:0.447f blue:0.784f alpha:1.0f].CGColor;
    [self.nameLabel.layer addSublayer:nameBorder];
    
    self.saveButton.layer.cornerRadius = 2;
    self.saveButton.clipsToBounds = YES;


}

- (IBAction)saveButtonSelected:(id)sender {

    if (self.firstNameTextField.text) {
        [SVProgressHUD show];
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
    [SVProgressHUD dismiss];
    if (userId && [userId intValue] != -1) {
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
    [SVProgressHUD dismiss];
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
    [self.selectImageButton setBackgroundImage:userImage forState:UIControlStateNormal];
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
