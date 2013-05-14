//
//  SplashViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SplashViewController.h"
#import "SignupViewController.h"
#import "LoginViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController
@synthesize signupWithFacebookButton, signupWithEmailButton, loginButton; 


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self.signupWithFacebookButton addTarget:self action:@selector(signupWithFacebook:) forControlEvents:UIControlEventTouchUpInside];
    [self.signupWithEmailButton addTarget:self action:@selector(signupWithEmail:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

}
-(void)signupWithFacebook:(id)sender{
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    [self.navigationController pushViewController:signupVC animated:YES];
}
-(void)signupWithEmail:(id)sender{
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    [self.navigationController pushViewController:signupVC animated:YES];
}
-(void)login:(id)sender{
    LoginViewController *loginVC = initViewControllerWithIdentifier(@"LoginVC");
    [self.navigationController pushViewController:loginVC animated:YES];
}



















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
