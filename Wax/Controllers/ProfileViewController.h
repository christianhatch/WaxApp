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

@property (nonatomic, strong) PersonObject *person;

+(ProfileViewController *)profileViewControllerFromUserID:(NSString *)userID username:(NSString *)username;
+(ProfileViewController *)profileViewControllerFromPersonObject:(PersonObject *)person;

@end
