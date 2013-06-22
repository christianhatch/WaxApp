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

@implementation PersonCell
@synthesize followButton = _followButton, fullNameLabel, usernameLabel, profilePictureView, hidesFollowButton = _hidesFollowButton;
@synthesize person = _person; 

-(void)setUpView{
    PersonObject *person = self.person;
    
//    __block PersonCell *blockSelf = self;
    [self.profilePictureView setImageForProfilePictureWithUserID:person.userID buttonHandler:^(UIImageView *imageView) {
       
//        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromPersonObject:blockSelf.person];
//        UIViewController *vc = [blockSelf nearestViewController];
//        [vc.navigationController pushViewController:pvc animated:YES];
        
    }];
    
    self.fullNameLabel.text = person.fullName;
    self.usernameLabel.text = person.username;
    
    if (!person.isMe || !self.hidesFollowButton) {
        [self.contentView addSubview:self.followButton];
    }
}
-(void)setPerson:(PersonObject *)person{
    if (_person != person) {
        _person = person;
        [self setUpView]; 
    }
}

#pragma mark - Getters
-(WaxFollowButton *)followButton{
    if (!_followButton) {
        _followButton = [WaxFollowButton followButtonWithUserID:self.person.userID following:self.person.isFollowing frame:CGRectMake((self.contentView.bounds.size.width - 90), 0, 90, self.contentView.bounds.size.height)];
    }
    return _followButton; 
}

@end
