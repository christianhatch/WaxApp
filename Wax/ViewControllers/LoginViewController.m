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

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize loginWithEmailLabel, usernameField, passwordField, disclaimerLabel, loginButton, loginFacebookButton, forgotPasswordButton; 

-(void)viewDidLoad{
    [super viewDidLoad];

    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];

    [self.loginFacebookButton addTarget:self action:@selector(loginWithFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [self.forgotPasswordButton addTarget:self action:@selector(forgotPassword:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton setTarget:self];
    [self.loginButton setAction:@selector(login:)]; 
    
    [self setUpView];
}
-(void)loginWithFacebook:(id)sender{

    [AIKErrorManager logMessageToAllServices:@"User tapped connect with facebook button on login page"];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
    
    [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
        if (!error) {
            [[WaxUser currentUser] loginWithFacebookID:user.id fullName:user.name email:[user objectForKey:@"email"] completion:^(NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Logged In!", @"Logged In!")];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    [SVProgressHUD dismiss];
                    if (error.code == 1010) {
                        UINavigationController *navController = self.navigationController;

                        SignupViewController *signup = initViewControllerWithIdentifier(@"SignupVC");
                        signup.facebookSignup = YES;
                       
                        NSMutableArray *vcs = [NSMutableArray arrayWithArray:navController.viewControllers];
                        [vcs removeObject:self];
                        navController.viewControllers = vcs;
                        [navController pushViewController:signup animated:YES];
                    }
                }
            }];
        }else{
            [SVProgressHUD dismiss];
        }
    }]; 
}
-(void)forgotPassword:(id)sender{
    [AIKErrorManager logMessageToAllServices:@"User tapped forgot password button on login page"];

    [AIKErrorManager showAlertWithTitle:@"Soon!" message:@"We'll have this up and running in a jiffy, so don't forget your password just yet!" buttonHandler:nil logError:NO];
    
}
-(void)login:(id)sender{
    
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

-(void)setUpView{
    for (UITextField *tf in self.view.subviews) {
        tf.autocorrectionType = UITextAutocorrectionTypeNo;
    }

    self.navigationItem.title = NSLocalizedString(@"Log In", @"Log In");
    self.loginButton.title = NSLocalizedString(@"Log In", @"Log In"); 
    
    self.usernameField.placeholder = NSLocalizedString(@"Username", @"Username");
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
    self.passwordField.secureTextEntry = YES;
    
    [self.forgotPasswordButton setTitleForAllControlStates:NSLocalizedString(@"forgot password?", @"forgot password?")]; 
    [self.forgotPasswordButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    
    [self.loginFacebookButton setTitleForAllControlStates:NSLocalizedString(@"Connect With Facebook", @"Connect With Facebook")]; 
    [self.loginFacebookButton sizeToFit];
    self.loginFacebookButton.center = CGPointMake(self.view.center.x, self.loginFacebookButton.center.y);
    
    self.loginWithEmailLabel.textAlignment = NSTextAlignmentCenter;
    self.loginWithEmailLabel.text = NSLocalizedString(@"Login With Email", @"Login With Email");
    self.loginWithEmailLabel.numberOfLines = 0;
    self.loginWithEmailLabel.minimumScaleFactor = 0.5;
    self.loginWithEmailLabel.font = [UIFont systemFontOfSize:15];

    self.disclaimerLabel.textAlignment = NSTextAlignmentCenter;
    self.disclaimerLabel.text = NSLocalizedString(@"by signing up you agree to the Wax terms of service and privacy policy", @"by signing up you agree to the Wax terms of service and privacy policy");
    self.disclaimerLabel.numberOfLines = 0;
    self.disclaimerLabel.minimumScaleFactor = 0.5;
    self.disclaimerLabel.font = [UIFont systemFontOfSize:12];
    [self.disclaimerLabel sizeToFit];
}










-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
