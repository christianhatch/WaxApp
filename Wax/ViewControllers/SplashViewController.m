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

#import "TutorialParentViewController.h"

@interface SplashViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *waxLogoView;
@property (strong, nonatomic) IBOutlet UILabel *sloganLabel;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;

@property (strong, nonatomic) IBOutlet WaxRoundButton *signupWithFacebookButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *signupWithEmailButton;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;

- (IBAction)signup:(id)sender;
- (IBAction)login:(id)sender;

@end

@implementation SplashViewController
@synthesize signupWithFacebookButton, signupWithEmailButton, loginButton; 


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
        
    [self setUpView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [SVProgressHUD dismiss];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

-(void)setUpView{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; 
    self.backgroundImageView.image = [UIImage imageNamed:[UIDevice isRetina4Inch] ? @"splash_bg_568@2x" : @"splash_bg"];
    self.waxLogoView.image = [UIImage imageNamed:@"wax_logo"];
    [self.sloganLabel setWaxHeaderItalicsFontOfSize:20 color:[UIColor whiteColor]];
    self.sloganLabel.text = NSLocalizedString(@"Compete in Anything!", @"Compete in Anything!");
    self.backgroundImageView.dimmingView.alpha = 0.65;
    
    
    [self.signupWithFacebookButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Sign Up With Facebook", @"Sign Up With Facebook")];
    [self.signupWithFacebookButton.titleLabel setFont:[UIFont waxHeaderFontItalicsOfSize:16]];
    [self.signupWithFacebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupWithFacebookButton setTitleColor:[UIColor waxDefaultFontColor] forState:UIControlStateHighlighted]; 
    self.signupWithFacebookButton.tag = 2;

    [self.signupWithEmailButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Sign Up With Email", @"Sign Up With Email")];
    [self.signupWithEmailButton.titleLabel setFont:[UIFont waxHeaderFontItalicsOfSize:16]];
    [self.signupWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupWithEmailButton setTitleColor:[UIColor waxDefaultFontColor] forState:UIControlStateHighlighted];
   
    [self.loginButton styleFontAsWaxHeaderFontOfSize:13 color:[UIColor whiteColor] highlightedColor:[UIColor waxDefaultFontColor]];
    [self.loginButton setTitleForAllControlStates:NSLocalizedString(@"Already have an account? Log In", @"Already have an account? Log In")]; 
}

- (IBAction)signup:(id)sender {
        
    UIButton *sendy = (UIButton *)sender;
    
    SignupViewController *signupVC = initViewControllerWithIdentifier(@"SignupVC");
    
    if (sendy.tag == 2) {
        [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
        
        [AIKErrorManager logMessageToAllServices:@"User tapped connect with facebook button on splash page"];
        
        [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
            if (!error) {
                [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
                [[WaxUser currentUser] loginWithFacebookID:user.id fullName:user.name email:[user objectForKey:@"email"] completion:^(NSError *error) {
                    if (!error) {
                        [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Logged In!", @"Logged In!")];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    }else{
                        [SVProgressHUD dismiss];
                        if (error.code == 1010) {
                            [[AIKFacebookManager sharedManager] logoutFacebookWithCompletion:^{
                                signupVC.facebookSignup = YES;
                                [self.navigationController setNavigationBarHidden:NO animated:YES]; 
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
        [self.navigationController setNavigationBarHidden:NO animated:YES];
        [self.navigationController pushViewController:signupVC animated:YES];
    }
}

- (IBAction)login:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped login button on splash page"];
    
    LoginViewController *loginVC = initViewControllerWithIdentifier(@"LoginVC");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
}
















- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
