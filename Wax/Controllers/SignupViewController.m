//
//  SignupViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SignupViewController.h"
#import "SplashViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize profilePictureButton, fullNameField, emailField, usernameField, passwordField, disclaimerLabel, goButton, facebookSignup; 


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];

    [self.profilePictureButton addTarget:self action:@selector(profilePicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.goButton setTarget:self];
    [self.goButton setAction:@selector(signup:)];

    [self setUpView];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    self.profilePictureButton.enabled = !self.facebookSignup;
    self.passwordField.hidden = self.facebookSignup;

    if (self.facebookSignup) {
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
                    [self.profilePictureButton setBackgroundImage:profilePic forState:UIControlStateNormal animated:YES];
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
-(void)profilePicture:(id)sender{
    
    [[WaxUser currentUser] chooseNewprofilePicture:self completion:^(UIImage *profilePicture, NSError *error) {
        if (profilePicture) {
            [self.profilePictureButton setImage:profilePicture forState:UIControlStateNormal animated:YES];
        }
    }];
}
-(void)signup:(id)sender{
    if ([self verifyInputtedData]) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Creating Account...", @"Creating Account...")];
        
        if (!self.facebookSignup) {
            [[WaxUser currentUser] updateProfilePictureOnServer:self.profilePictureButton.imageView.image andShowUICallbacks:NO completion:^(NSError *error) {
                if (error) {
                    [[AIKErrorManager sharedManager] logErrorWithMessage:NSLocalizedString(@"Problem Uploading Profile Picture", @"Problem Uploading Profile Picture") error:error andShowAlertWithButtonHandler:^{
                        //try again? tell user to manually go try again?
                    }];
                }
            }];
        }
        [[WaxUser currentUser] createAccountWithUsername:self.usernameField.text fullName:self.fullNameField.text email:self.emailField.text passwordOrFacebookID:self.passwordField.text completion:^(NSError *error) {

            if (!error) {
                [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Account Created!", @"Account Created!")];
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                [SVProgressHUD dismiss];
                
            }
        }];
    }
}

#pragma mark - Utility Methods
-(BOOL)verifyInputtedData{
    BOOL verified = YES;
    
    if (self.usernameField.text.length < 3) {
        verified = NO;
        if ([NSString isEmptyOrNil:self.emailField.text]) {
            [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Username", @"No Username") message:NSLocalizedString(@"Please choose a username", @"Please choose a username") buttonHandler:^{
                [self.usernameField becomeFirstResponder];
            }];
        }else{
            [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"Username Too Short", @"Username Too Short") message:NSLocalizedString(@"Your username must be at least 2 characters long.", @"Your username must be at least 2 characters long.") buttonHandler:^{
                [self.usernameField becomeFirstResponder];
            }];
        }
    }else if ([NSString isEmptyOrNil:self.emailField.text]) {
        verified = NO;
        [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Email", @"No Email") message:NSLocalizedString(@"Please enter your email address", @"Please enter your email address") buttonHandler:^{
            [self.emailField becomeFirstResponder];
        }];
    }else if (!self.facebookSignup && [NSString isEmptyOrNil:self.passwordField.text]) {
        [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Password", @"No Password") message:NSLocalizedString(@"Please choose a password", @"Please choose a password") buttonHandler:^{
            [self.passwordField becomeFirstResponder];
        }];
    }else if (!self.facebookSignup && !self.profilePictureButton.imageView.image) {
        [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"No Profile Picture", @"No Profile Picture") message:NSLocalizedString(@"Please choose a profile picture", @"Please choose a profile picture") buttonHandler:^{
            [self profilePicture:self];
        }];
    }
    
    return verified;
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    
    self.goButton.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    
    self.profilePictureButton.adjustsImageWhenDisabled = NO;
    self.profilePictureButton.layer.cornerRadius = kCornerRadiusDefault;
    
    self.fullNameField.placeholder = NSLocalizedString(@"Full Name", @"Full Name");
    self.emailField.placeholder = NSLocalizedString(@"Email", @"Email");
    self.usernameField.placeholder = NSLocalizedString(@"choose a username", @"choose a username");
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
    
    self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    self.disclaimerLabel.text = NSLocalizedString(@"by signing up you agree to the Wax terms of service and privacy policy", @"by signing up you agree to the Wax terms of service and privacy policy");
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.minimumScaleFactor = 0.5;
    self.disclaimerLabel.font = [UIFont systemFontOfSize:12];
    [self.disclaimerLabel sizeToFit];
}



















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];


}

@end
    