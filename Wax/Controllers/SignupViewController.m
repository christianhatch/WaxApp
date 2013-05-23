//
//  SignupViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController
@synthesize profilePictureButton, fullNameField, emailField, usernameField, passwordField, disclaimerLabel, goButton;


- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self enableSwipeToPopVC:YES];
    [self enableTapToDismissKeyboard:YES];

    [self.profilePictureButton addTarget:self action:@selector(profilePicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.goButton setTarget:self];
    [self.goButton setAction:@selector(signup:)];

    [self setUpView];
}

-(void)profilePicture:(id)sender{
    DLog(@"profile picture");
}
-(void)signup:(id)sender{
    DLog(@"signup"); 
}
-(void)setUpView{
    self.navigationItem.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    
    self.goButton.title = NSLocalizedString(@"Sign Up", @"Sign Up");
    
    self.profilePictureButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.profilePictureButton.layer.cornerRadius = kCornerRadiusDefault;
    
    self.fullNameField.placeholder = NSLocalizedString(@"Full Name", @"Full Name");
//    self.fullNameField.borderStyle = UITextBorderStyleNone;
//    self.fullNameField.textAlignment = NSTextAlignmentCenter;
    
    self.emailField.placeholder = NSLocalizedString(@"Email", @"Email");
//    self.emailField.borderStyle = UITextBorderStyleNone;
//    self.emailField.textAlignment = NSTextAlignmentCenter;
    
    self.usernameField.placeholder = NSLocalizedString(@"Username", @"Username");
//    self.usernameField.borderStyle = UITextBorderStyleNone;
//    self.usernameField.textAlignment = NSTextAlignmentCenter;
    
    self.passwordField.placeholder = NSLocalizedString(@"Password", @"Password");
//    self.passwordField.borderStyle = UITextBorderStyleNone;
//    self.passwordField.textAlignment = NSTextAlignmentCenter;
    
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
    