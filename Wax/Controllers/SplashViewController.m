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
    
    [self enableSwipeToPopVC:YES];
        
    [self.signupWithFacebookButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    self.signupWithFacebookButton.tag = 2;
  
    [self.signupWithEmailButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
    [self.loginButton addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];

    [self setUpView];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}
-(void)signup:(UIButton *)sender{
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    
    if (sender.tag == 2) {
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
                            [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:^{
                                signupVC.facebookSignup = YES;
                                [self.navigationController pushViewController:signupVC animated:YES];
                            }];
                        }
                    }
                }];
            }else{
                [SVProgressHUD dismiss];
            }
        }];
    }else{
        [self.navigationController pushViewController:signupVC animated:YES];
    }
}
-(void)login:(id)sender{
    LoginViewController *loginVC = initViewControllerWithIdentifier(@"LoginVC");
    [self.navigationController pushViewController:loginVC animated:YES];
}
-(void)pushFacebookSignupVC{
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    signupVC.facebookSignup = YES;
    [self.navigationController pushViewController:signupVC animated:YES];
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Wax", @"Wax");

    [self.signupWithFacebookButton setTitle:NSLocalizedString(@"Connect With Facebook", @"Connect With Facebook") forState:UIControlStateNormal];
    [self.signupWithFacebookButton setTitle:NSLocalizedString(@"Connect With Facebook", @"Connect With Facebook") forState:UIControlStateHighlighted];
    
    [self.signupWithEmailButton setTitle:NSLocalizedString(@"Sign Up With Email", @"Sign Up With Email") forState:UIControlStateNormal];
    [self.signupWithEmailButton setTitle:NSLocalizedString(@"Sign Up With Email", @"Sign Up With Email") forState:UIControlStateHighlighted];

    [self.loginButton setTitle:NSLocalizedString(@"Login", @"Login") forState:UIControlStateNormal];
    [self.loginButton setTitle:NSLocalizedString(@"Login", @"Login") forState:UIControlStateHighlighted];

}
















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
