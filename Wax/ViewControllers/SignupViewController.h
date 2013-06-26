//
//  SignupViewController.h
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SignupViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIBarButtonItem *goButton;

@property (strong, nonatomic) IBOutlet UIButton *profilePictureButton;
@property (strong, nonatomic) IBOutlet UITextField *fullNameField;
@property (strong, nonatomic) IBOutlet UITextField *emailField;

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;

@property (strong, nonatomic) IBOutlet UILabel *disclaimerLabel;

@property (nonatomic, assign) BOOL facebookSignup; 

@end
