//
//  LoginViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "LoginViewController.h"
#import "SplashViewController.h"
#import "SignupViewController.h"

@interface LoginViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *loginWithEmailLabel;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UIButton *forgotPasswordButton;
@property (strong, nonatomic) IBOutlet UIButton *loginFacebookButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *loginButton;

- (IBAction)loginFacebookButtonAction:(id)sender;
- (IBAction)forgotPasswordButtonAction:(id)sender;
- (IBAction)signupButtonAction:(id)sender;
- (IBAction)tosButtonAction:(id)sender;
- (IBAction)privacyButtonAction:(id)sender;

@end

@implementation LoginViewController
@synthesize loginWithEmailLabel, usernameField, passwordField, loginButton, loginFacebookButton, forgotPasswordButton; 

-(void)viewDidLoad{
    [super viewDidLoad];

    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];
    
    [self setUpView];
}

-(void)setUpView{
#ifndef DEBUG
    self.forgotPasswordButton.hidden = YES;
#endif
    
    self.view.backgroundColor = [UIColor waxTableViewCellSelectionColor];
    
    self.navigationItem.title = NSLocalizedString(@"Log In", @"Log In");
    self.loginButton.title = NSLocalizedString(@"Log In", @"Log In");
        
    [self.forgotPasswordButton styleFontAsWaxHeaderFontOfSize:13 color:[UIColor whiteColor] highlightedColor:[UIColor waxHeaderFontColor]]; 
    [self.forgotPasswordButton setTitleForAllControlStates:NSLocalizedString(@"forgot password?", @"forgot password?")];

    [self.loginFacebookButton.titleLabel setWaxDefaultFontOfSize:16];    
    [self.loginFacebookButton setTitleColorForAllControlStates:[UIColor waxDefaultFontColor]];

    [self.loginWithEmailLabel setWaxDetailFontOfSize:13 color:[UIColor waxDefaultFontColor]];
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
}

- (IBAction)loginFacebookButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped connect with facebook button on login page"];
    
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
        
    [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
        
        if (!user || [NSString isEmptyOrNil:user.id] || [NSString isEmptyOrNil:user.name] || [NSString isEmptyOrNil:[user objectForKey:@"email"]]) {
            
            [SVProgressHUD dismiss];
            
        }else{
            
            [self attemptFacebookLoginWithFBGraphUser:user];
            
        }
        
    }];
}

- (IBAction)forgotPasswordButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped forgot password button on login page"];
    
    [AIKErrorManager showAlertWithTitle:@"Soon!" message:@"We'll have this up and running in a jiffy, so don't forget your password just yet!" buttonHandler:nil logError:NO];
}

- (IBAction)signupButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped login button on login page"];
            
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In...", @"Logging In...")];
    
    [[WaxUser currentUser] loginWithUsername:self.usernameField.text password:self.passwordField.text completion:^(NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Logged In!", @"Logged In!")];
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [SVProgressHUD dismiss];
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
    if (textField == self.usernameField){
        [self.passwordField becomeFirstResponder];
    }else if (textField == self.passwordField){
        [self signupButtonAction:self];
    }
    return YES;
}

#pragma mark - Internal Methods
-(void)loginDidSucceed{
    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Logged In!", @"Logged In!")];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)attemptFacebookLoginWithFBGraphUser:(id <FBGraphUser>)user{
    
    [[WaxUser currentUser] loginWithFacebookID:user.id fullName:user.name email:[user objectForKey:@"email"] completion:^(NSError *error) {
        if (!error) {
            [self loginDidSucceed];
        }else{
            [SVProgressHUD dismiss];
            
            if (error.code == WaxAPIErrorRegistrationMustCreateUsernameForFacebookSignup) {
                [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:^{
                    
                    SignupViewController *signup = [SignupViewController signupViewControllerForFacebookWithFBGraphUser:user];
                    
                    UINavigationController *navController = self.navigationController;

                    NSMutableArray *vcs = [NSMutableArray arrayWithArray:navController.viewControllers];
                    [vcs removeObject:self];
                    navController.viewControllers = vcs;
                    [navController pushViewController:signup animated:YES];
                }];
            }
        }
        
    }];
}




-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
