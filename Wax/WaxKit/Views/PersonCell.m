//
//  PersonCell.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonCell.h"
#import "WaxFollowButton.h"
#import "ProfileViewController.h"

@interface PersonCell ()
@property (strong, nonatomic) IBOutlet WaxFollowButton *followButton;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *fullNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@end


@implementation PersonCell
@synthesize followButton = _followButton, fullNameLabel, usernameLabel, profilePictureView, cellType = _cellType; 
@synthesize person = _person; 

-(void)setUpView{
    PersonObject *person = self.person;
    
    [self.profilePictureView setImageForProfilePictureWithUserID:person.userID buttonHandler:nil];
    
    self.fullNameLabel.text = person.fullName;
    self.usernameLabel.text = person.username;
    
    self.followButton.hidden = (person.isMe || self.cellType == PersonCellTypeSendChallenge);

    if (self.cellType == PersonCellTypeDefault) {
        [self.followButton setUserid:person.userID isFollowing:person.isFollowing];
    }
}

-(void)setPerson:(PersonObject *)person{
    NSAssert(((self.cellType == PersonCellTypeDefault) || (self.cellType == PersonCellTypeSendChallenge)), @"you must set a cell type BEFORE setting a person object");
    
    if (_person != person) {
        _person = person;
        [self setUpView]; 
    }
}



#pragma mark - Overrides
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    self.followButton.highlighted = NO;
}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.followButton.highlighted = NO;
}


@end






