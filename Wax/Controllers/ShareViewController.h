//
//  ShareViewController.h
//  Wax
//
//  Created by Christian Hatch on 6/3/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewController : UIViewController

@property (strong, nonatomic) IBOutlet UITextField *tagField;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;

@property (strong, nonatomic) IBOutlet UISwitch *twitterSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *facebookSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *locationSwitch;

@property (strong, nonatomic) IBOutlet UILabel *instructionsLabel;
@property (strong, nonatomic) IBOutlet UILabel *twitterLabel;
@property (strong, nonatomic) IBOutlet UILabel *facebookLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;

@end