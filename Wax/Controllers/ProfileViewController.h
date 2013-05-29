//
//  ProfileViewController.h
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonObject;

@interface ProfileViewController : UIViewController

@property (nonatomic, strong) PersonObject *user;

@property (strong, nonatomic) IBOutlet UIButton *profPicBtn;
@property (strong, nonatomic) IBOutlet UIButton *uploadBtn;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@end
