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

@property (strong, nonatomic) IBOutlet UIButton *tutorialButton;

- (IBAction)tutorialButtonAction:(id)sender;
- (IBAction)signupWithFacebookAction:(id)sender;
- (IBAction)signupWithEmailAction:(id)sender;
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
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kHasShownTutorialKey]) {
        [self tutorialButtonAction:nil]; 
    }
}

-(void)setUpView{
    [self.navigationController setNavigationBarHidden:YES animated:NO]; 
    self.backgroundImageView.image = [UIImage imageNamed:[UIDevice isRetina4Inch] ? @"splash_bg_568@2x" : @"splash_bg"];
    self.waxLogoView.image = [UIImage imageNamed:@"wax_logo"];
    [self.sloganLabel setWaxHeaderItalicsFontOfSize:20 color:[UIColor whiteColor]];
    self.sloganLabel.text = NSLocalizedString(@"Compete in Anything!", @"Compete in Anything!");
    self.backgroundImageView.dimmingView.alpha = 0.65;
    
    [self.tutorialButton styleFontAsWaxHeaderFontOfSize:15 color:[UIColor whiteColor] highlightedColor:[UIColor waxDefaultFontColor]]; 
    
    [self.signupWithFacebookButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Sign Up With Facebook", @"Sign Up With Facebook")];
    [self.signupWithFacebookButton.titleLabel setFont:[UIFont waxHeaderFontItalicsOfSize:16]];
    [self.signupWithFacebookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupWithFacebookButton setTitleColor:[UIColor waxDefaultFontColor] forState:UIControlStateHighlighted]; 

    [self.signupWithEmailButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Sign Up With Email", @"Sign Up With Email")];
    [self.signupWithEmailButton.titleLabel setFont:[UIFont waxHeaderFontItalicsOfSize:16]];
    [self.signupWithEmailButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.signupWithEmailButton setTitleColor:[UIColor waxDefaultFontColor] forState:UIControlStateHighlighted];
   
    [self.loginButton styleFontAsWaxHeaderFontOfSize:13 color:[UIColor whiteColor] highlightedColor:[UIColor waxDefaultFontColor]];
    [self.loginButton setTitleForAllControlStates:NSLocalizedString(@"Already have an account? Log In", @"Already have an account? Log In")]; 
}

- (IBAction)tutorialButtonAction:(id)sender {
    TutorialParentViewController *tut = [TutorialParentViewController tutorialViewController];
    [self presentViewController:tut animated:YES completion:nil]; 
}

- (IBAction)signupWithFacebookAction:(id)sender {
    [AIKErrorManager logMessage:@"User tapped connect with facebook button on splash page"];

    [SVProgressHUD showWithStatus:NSLocalizedString(@"Logging In With Facebook...", @"Logging In With Facebook...")];
    
    [[AIKFacebookManager sharedManager] connectFacebookWithCompletion:^(id<FBGraphUser> user, NSError *error) {
        
        if (!user || [NSString isEmptyOrNil:user.id] || [NSString isEmptyOrNil:user.name] || [NSString isEmptyOrNil:[user objectForKey:@"email"]]) {
            
            [SVProgressHUD dismiss];
            
        }else{
            [self attemptFacebookLoginWithFBGraphUser:user]; 
        }
    }];
}

- (IBAction)signupWithEmailAction:(id)sender {
    [AIKErrorManager logMessage:@"User tapped signup with email button on splash page"];
    
    SignupViewController *signupVC = [SignupViewController signupViewControllerForEmail];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:signupVC animated:YES];
}

- (IBAction)login:(id)sender {
    [AIKErrorManager logMessage:@"User tapped login button on splash page"];
    
    LoginViewController *loginVC = initViewControllerWithIdentifier(@"LoginVC");
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController pushViewController:loginVC animated:YES];
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
                    [self.navigationController setNavigationBarHidden:NO animated:YES];
                    [self.navigationController pushViewController:signup animated:YES];
                }];
            }
        }
        
    }];
}









- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    
}

@end
