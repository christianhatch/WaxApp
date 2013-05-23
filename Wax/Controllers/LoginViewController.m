//
//  LoginViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "LoginViewController.h"

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
    DLog(@"login fbook");
}
-(void)forgotPassword:(id)sender{
    DLog(@"forgot password");
}
-(void)login:(id)sender{
    DLog(@"login");
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Log In", @"Log In");
    self.loginButton.title = NSLocalizedString(@"Log In", @"Log In"); 
    
    self.usernameField.placeholder = NSLocalizedString(@"Username", @"Username");
//    self.usernameField.borderStyle = UITextBorderStyleNone;
//    self.usernameField.textAlignment = NSTextAlignmentCenter;
    
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
//    self.passwordField.borderStyle = UITextBorderStyleNone;
//    self.passwordField.textAlignment = NSTextAlignmentCenter;
    
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"forgot password?", @"forgot password?") forState:UIControlStateNormal];
    [self.forgotPasswordButton setTitle:NSLocalizedString(@"forgot password?", @"forgot password?") forState:UIControlStateHighlighted];
    [self.forgotPasswordButton setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    
    [self.loginFacebookButton setTitle:NSLocalizedString(@"Login With Facebook", @"Login With Facebook") forState:UIControlStateNormal];
    [self.loginFacebookButton setTitle:NSLocalizedString(@"Login With Facebook", @"Login With Facebook") forState:UIControlStateHighlighted];
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
