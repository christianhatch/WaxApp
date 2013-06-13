//
//  PersonListViewController.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonListViewController : UIViewController

+(PersonListViewController *)personListViewControllerForFollowingFromUserID:(NSString *)userID;
+(PersonListViewController *)personListViewControllerForFollowersFromUserID:(NSString *)userID;

@end
