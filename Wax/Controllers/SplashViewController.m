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

- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation SplashViewController
@synthesize signupWithFacebookButton, signupWithEmailButton, loginButton; 


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewWillAppear:) name:UIApplicationWillResignActiveNotification object:nil]; 
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}
- (IBAction)signup:(id)sender {
        
    UIButton *sendy = (UIButton *)sender;
    
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    
    if (sendy.tag == 2) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
        
        [AIKErrorManager logMessageToAllServices:@"User tapped connect with facebook button on splash page"];
        
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
        [AIKErrorManager logMessageToAllServices:@"User tapped signup with email button on splash page"];
        
        [self.navigationController pushViewController:signupVC animated:YES];
    }
}

- (IBAction)login:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped login button on splash page"];
    
    LoginViewController *loginVC = initViewControllerWithIdentifier(@"LoginVC");
    [self.navigationController pushViewController:loginVC animated:YES];
}

-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Wax", @"Wax");

    self.signupWithFacebookButton.tag = 2;
    
    [self.signupWithFacebookButton setTitleForAllControlStates:NSLocalizedString(@"Connect With Facebook", @"Connect With Facebook")];
    [self.signupWithEmailButton setTitleForAllControlStates:NSLocalizedString(@"Sign Up With Email", @"Sign Up With Email")]; 
    [self.loginButton setTitleForAllControlStates:NSLocalizedString(@"Login", @"Login")]; 
}
















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
