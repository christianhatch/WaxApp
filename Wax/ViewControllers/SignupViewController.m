//
//  SignupViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SignupViewController.h"
#import "SplashViewController.h"

@interface SignupViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *profilePictureLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileInfoLabel;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *goButton;

@property (strong, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicturePreview;
@property (strong, nonatomic) IBOutlet UIImageView *profilePicChevron;

@property (strong, nonatomic) IBOutlet UITextField *fullNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) id <FBGraphUser> facebookUser;

- (IBAction)profilePictureButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;

- (IBAction)tosButtonAction:(id)sender;
- (IBAction)privacyButtonAction:(id)sender;

@end

@implementation SignupViewController
@synthesize profilePictureButton, fullNameField, emailField, usernameField, passwordField, goButton, facebookUser; 

+(SignupViewController *)signupViewControllerForFacebookWithFBGraphUser:(id <FBGraphUser>)graphUser{
    SignupViewController *sign = initViewControllerWithIdentifier(@"SignupVC");
    sign.facebookUser = graphUser;
    return sign; 
}

+(SignupViewController *)signupViewControllerForEmail{
    SignupViewController *sign = initViewControllerWithIdentifier(@"SignupVC");
    return sign;
}



-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];

    [self setUpView];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Sign Up", @"Sign Up");

    self.view.backgroundColor = [UIColor waxTableViewCellSelectionColor];
    
    self.goButton.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    self.fullNameField.placeholder = NSLocalizedString(@"Full Name", @"Full Name");
    self.emailField.placeholder = NSLocalizedString(@"Email", @"Email");
    self.usernameField.placeholder = NSLocalizedString(@"Username", @"choose a username");
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
    
    [self.profilePictureButton setTitleForAllControlStates:NSLocalizedString(@"Choose Picture", @"Choose Picture")];
    
    [self.profilePictureButton.titleLabel setWaxDefaultFontOfSize:16];
    [self.profilePictureButton setTitleColorForAllControlStates:[UIColor waxDefaultFontColor]];
    
    [self.profilePictureLabel setWaxDetailFontOfSize:13 color:[UIColor waxDefaultFontColor]];
    [self.profileInfoLabel setWaxDetailFontOfSize:13 color:[UIColor waxDefaultFontColor]];
    
    for (UITextField *tf in @[self.fullNameField, self.emailField, self.usernameField, self.passwordField]) {
        tf.delegate = self;
    }
    
    [self.scrollView setContentSize:self.view.bounds.size]; 
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.profilePictureButton.enabled = self.facebookUser == nil;
    self.passwordField.hidden = self.facebookUser != nil;
    self.profilePicChevron.hidden = self.facebookUser != nil; 

    if (self.facebookUser != nil) [self configureForFacebookSignup];
}
- (void)configureForFacebookSignup {
    self.usernameField.returnKeyType = UIReturnKeyGo;
    
    [self.profilePictureButton setTitleForAllControlStates:NSLocalizedString(@"Facebook Picture", @"Facebook Picture")]; 
    
    self.fullNameField.text = self.facebookUser.name;
    self.emailField.text = [self.facebookUser objectForKey:@"email"];
    self.passwordField.text = self.facebookUser.id;
    
    [self.profilePicturePreview setFacebookProfilePictureWithFacebookID:self.facebookUser.id placeholderImage:nil animated:YES completion:nil];
}

- (IBAction)signupButtonAction:(id)sender {
    [AIKErrorManager logMessage:@"User tapped signup button on signup page"];
    
    if (![self verifyInputtedData]) {
        return;
    }
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating Account...", @"Creating Account...")];
    
    if (self.facebookUser != nil) {
        [[WaxUser currentUser] createAccountWithUsername:self.usernameField.text fullName:self.fullNameField.text email:self.emailField.text facebookID:self.passwordField.text completion:^(NSError *error) {
            [self handleCreatingAccountWithError:error]; 
        }];
    }else{
        [[WaxUser currentUser] createAccountWithUsername:self.usernameField.text fullName:self.fullNameField.text email:self.emailField.text password:self.passwordField.text profilePicture:self.profilePicturePreview.image completion:^(NSError *error) {
            [self handleCreatingAccountWithError:error];
        }];
    }    
}
- (IBAction)profilePictureButtonAction:(id)sender {
    [AIKErrorManager logMessage:@"User tapped profile picture button on signup page"];
    
    [[WaxUser currentUser] chooseNewprofilePictureFromViewController:self completion:^(UIImage *profilePicture, NSError *error) {
        [self setProfilePicture:profilePicture];
    }];
}
-(void)handleCreatingAccountWithError:(NSError *)error{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Account Created!", @"Account Created!")];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [SVProgressHUD dismiss];
    }
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.facebookUser == nil) {
        if (textField == self.fullNameField) {
            [self.emailField becomeFirstResponder];
        }else if (textField == self.emailField){
            [self.usernameField becomeFirstResponder];
        }else if (textField == self.usernameField){
            [self.passwordField becomeFirstResponder];
        }else if (textField == self.passwordField){
            [self signupButtonAction:self];
        }
    }else{
        if (textField == self.fullNameField) {
            [self.emailField becomeFirstResponder];
        }else if (textField == self.emailField){
            [self.usernameField becomeFirstResponder];
        }else if (textField == self.usernameField){
            [self signupButtonAction:self];
        }
    }
    return YES;
}

#pragma mark - Helper Methods
-(BOOL)verifyInputtedData{
    BOOL verified = YES;
    
    if ([NSString isEmptyOrNil:self.usernameField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Username", @"No Username") message:NSLocalizedString(@"Please choose a username", @"Please choose a username") buttonHandler:^{
            [self.usernameField becomeFirstResponder];
        } logError:NO];
    }else if ([NSString isEmptyOrNil:self.emailField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Email", @"No Email") message:NSLocalizedString(@"Please enter your email address", @"Please enter your email address") buttonHandler:^{
            [self.emailField becomeFirstResponder];
        } logError:NO];
    }
    //only when not in fb mode!
    else if (self.facebookUser == nil && [NSString isEmptyOrNil:self.passwordField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Password", @"No Password") message:NSLocalizedString(@"Please choose a password", @"Please choose a password") buttonHandler:^{
            [self.passwordField becomeFirstResponder];
        } logError:NO];
    }else if (self.facebookUser == nil && !self.profilePicturePreview.image) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Profile Picture", @"No Profile Picture") message:NSLocalizedString(@"Please choose a profile picture", @"Please choose a profile picture") buttonHandler:nil logError:NO];
        [self profilePictureButtonAction:self];
    }
    
    return verified;
}
-(void)setProfilePicture:(UIImage *)image{
    [self.profilePicturePreview setCircular:YES borderColor:[UIColor waxTableViewCellSelectionColor]];
    [self.profilePicturePreview setImage:image animated:YES];
}









- (IBAction)tosButtonAction:(id)sender {
    [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:kWaxTermsOfServiceURL] pageTitle:NSLocalizedString(@"Terms of Service", @"Terms of Service") presentFromViewController:self];
}

- (IBAction)privacyButtonAction:(id)sender {
    [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:kWaxPrivacyPolicyURL] pageTitle:NSLocalizedString(@"Privacy Policy", @"Privacy Policy") presentFromViewController:self];
}











- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];


}

@end
    