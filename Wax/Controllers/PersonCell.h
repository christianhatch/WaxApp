//
//  PersonCell.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#define kPersonCellID @"PersonCellID" 

#import "WaxTableViewCell.h"

@class WaxFollowButton;

@interface PersonCell : WaxTableViewCell

@property (nonatomic, strong) PersonObject *person;

@property (strong, nonatomic) WaxFollowButton *followButton;
@property (nonatomic, readwrite) BOOL hidesFollowButton;

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;


@end
