//
//  ProfileHeaderView.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kProfileHeaderViewHeight 250


#import <UIKit/UIKit.h>

@interface ProfileHeaderView : UIView

+(ProfileHeaderView *)profileHeaderViewForUserID:(NSString *)userID;

@property (nonatomic, strong) PersonObject *person;

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIButton *followersButton;
@property (strong, nonatomic) IBOutlet UIButton *followingButton;

@property (strong, nonatomic) IBOutlet UIButton *followButton;


- (IBAction)followButtonAction:(id)sender;
- (IBAction)followersButtonAction:(id)sender;
- (IBAction)followingButtonAction:(id)sender;


@end
