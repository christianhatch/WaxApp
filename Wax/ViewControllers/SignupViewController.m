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

@property (strong, nonatomic) IBOutlet UIBarButtonItem *goButton;

@property (strong, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (strong, nonatomic) IBOutlet UITextField *fullNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)profilePictureButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;

- (IBAction)tosButtonAction:(id)sender;
- (IBAction)privacyButtonAction:(id)sender;

@end

@implementation SignupViewController
@synthesize profilePictureButton, fullNameField, emailField, usernameField, passwordField, goButton, facebookSignup; 


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];

    [self setUpView];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Sign Up", @"Sign Up");

    [self.profilePictureButton setBackgroundImage:[UIImage imageNamed:@"profile_picture_placeholder"] forState:UIControlStateNormal];
    [self.profilePictureButton setBackgroundImage:[UIImage imageNamed:@"profile_picture_placeholder_On"] forState:UIControlStateHighlighted]; 
    
    self.goButton.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    self.fullNameField.placeholder = NSLocalizedString(@"Full Name", @"Full Name");
    self.emailField.placeholder = NSLocalizedString(@"Email", @"Email");
    self.usernameField.placeholder = NSLocalizedString(@"choose a username", @"choose a username");
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
    
    UIImage *textFieldBG = [UIImage stretchyImage:[UIImage imageNamed:@"waxSearchBar_bg"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO];
    for (UITextField *tf in @[self.fullNameField, self.emailField, self.usernameField, self.passwordField]) {
        tf.background = textFieldBG;
        tf.delegate = self;
        tf.layer.cornerRadius = kCornerRadiusDefault; 
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.profilePictureButton.enabled = !self.facebookSignup;
    self.passwordField.hidden = self.facebookSignup;

    if (self.facebookSignup) {
        self.usernameField.returnKeyType = UIReturnKeyGo;
        
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Loading Facebook Information", @"Loading Facebook Information")];
        
        UIActivityIndicatorView *loadingPicView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingPicView.hidesWhenStopped = YES;
        [self.profilePictureButton addSubview:loadingPicView];
        loadingPicView.center = self.profilePictureButton.center;
        [loadingPicView startAnimating];
        
        [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
            
            [SVProgressHUD dismiss];
            
            if (!error) {
                [[AIKFacebookManager sharedManager] fetchProfilePictureForFacebookID:user.id completion:^(NSError *error, UIImage *profilePic) {
                  
                    [self.profilePictureButton setImage:profilePic forState:UIControlStateNormal animated:YES];
                    
                    [loadingPicView stopAnimating];
                }];
                
                self.passwordField.text = user.id; 
                self.fullNameField.text = user.name;
                self.emailField.text = [user objectForKey:@"email"];
                
            }else{
                
            }
        }];
    }
}
- (IBAction)signupButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped signup button on signup page"];
    
    if ([self verifyInputtedData]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating Account...", @"Creating Account...")];
        
        [[WaxUser currentUser] createAccountWithUsername:self.usernameField.text fullName:self.fullNameField.text email:self.emailField.text passwordOrFacebookID:self.passwordField.text completion:^(NSError *error) {
            
            if (!error) {
                if (!self.facebookSignup) {
                    
                    UIImage *profPic = self.profilePictureButton.imageView.image;
                    
                    [[WaxUser currentUser] updateProfilePictureOnServer:profPic andShowUICallbacks:NO completion:^(NSError *error) {
                        if (error) {
                            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Problem Uploading Profile Picture", @"Problem Uploading Profile Picture")  message:error.localizedRecoverySuggestion buttonTitle:NSLocalizedString(@"Try again", @"Try again") showsCancelButton:NO buttonHandler:^{
                                [[WaxUser currentUser] updateProfilePictureOnServer:profPic andShowUICallbacks:NO completion:^(NSError *error) {
                                    if (error) {
                                        [AIKErrorManager logMessage:NSLocalizedString(@"Problem Uploading Profile Picture", @"Problem Uploading Profile Picture") withError:error];
                                    }
                                }];
                            } logError:YES];
                        }
                    }];
                }
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Account Created!", @"Account Created!")];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }
}
- (IBAction)profilePictureButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped profile picture button on signup page"];
    
    [[WaxUser currentUser] chooseNewprofilePicture:self completion:^(UIImage *profilePicture, NSError *error) {
        if (profilePicture) {
            [self.profilePictureButton setImage:profilePicture forState:UIControlStateNormal animated:YES];
        }
    }];
}

- (IBAction)tosButtonAction:(id)sender {
    [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:kWaxTermsOfServiceURL] pageTitle:NSLocalizedString(@"Terms of Service", @"Terms of Service") presentFromViewController:self];
}

- (IBAction)privacyButtonAction:(id)sender {
    [AIKWebViewController webViewControllerWithURL:[NSURL URLWithString:kWaxPrivacyPolicyURL] pageTitle:NSLocalizedString(@"Privacy Policy", @"Privacy Policy") presentFromViewController:self];
}

#pragma mark - UITextField Delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (!self.facebookSignup) {
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

#pragma mark - Internal Methods
-(BOOL)verifyInputtedData{
    BOOL verified = YES;
    
    if ([NSString isEmptyOrNil:self.emailField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Username", @"No Username") message:NSLocalizedString(@"Please choose a username", @"Please choose a username") buttonHandler:^{
            [self.usernameField becomeFirstResponder];
        } logError:NO];
    }else if ([NSString isEmptyOrNil:self.emailField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Email", @"No Email") message:NSLocalizedString(@"Please enter your email address", @"Please enter your email address") buttonHandler:^{
            [self.emailField becomeFirstResponder];
        } logError:NO];
    }else if (!self.facebookSignup && [NSString isEmptyOrNil:self.passwordField.text]) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Password", @"No Password") message:NSLocalizedString(@"Please choose a password", @"Please choose a password") buttonHandler:^{
            [self.passwordField becomeFirstResponder];
        } logError:NO];
    }else if (!self.facebookSignup && !self.profilePictureButton.imageView.image) {
        verified = NO;
        [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"No Profile Picture", @"No Profile Picture") message:NSLocalizedString(@"Please choose a profile picture", @"Please choose a profile picture") buttonHandler:nil logError:NO];
        [self profilePictureButtonAction:self];
    }
    
    return verified;
}


















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];


}

@end
    