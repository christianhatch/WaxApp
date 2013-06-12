//
//  ProfileHeaderView.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ProfileHeaderView.h"

@interface ProfileHeaderView ()
@property (nonatomic, strong) NSString *userID; 
@end

@implementation ProfileHeaderView
@synthesize profilePictureView = _profilePictureView, nameLabel = _nameLabel, followersLabel = _followersLabel, followingLabel = _followingLabel;
@synthesize followButton = _followButton, talentsButton = _talentsButton;
@synthesize person = _person, userID = _userID;

#pragma mark - Alloc & Init
+(ProfileHeaderView *)profileHeaderViewForUserID:(NSString *)userID{
    ProfileHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil] objectAtIndexOrNil:0];
    header.userID = userID; 
    return header;
}
-(void)setUpView{
    PersonObject *person = self.person;
   
    [self.profilePictureView setImageWithURL:[NSURL profilePictureURLFromUserID:person.userID] placeholderImage:nil animated:YES completion:nil];
   
    self.nameLabel.text = person.username;
    self.followersLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Followers", @"%@ Followers"), person.followersCount];
    self.followingLabel.text = [NSString stringWithFormat:NSLocalizedString(@"%@ Following", @"%@ Following"), person.followingCount];
   
    [self.talentsButton setTitleForAllControlStates:NSLocalizedString(@"Talents", @"Talents")];
    [self setUpFollowingLabel]; 
}
-(void)setPerson:(PersonObject *)person{
    if (_person != person) {
        _person = person; 
        [self setUpView];
    }
}
-(void)setUserID:(NSString *)userID{

    NSParameterAssert(userID);
    
    if (_userID != userID) {
        _userID = userID;
        [self fetchProfileInfoAndUpdateUI];
    }
}

#pragma mark - IBActions
-(IBAction)talentsButonAction:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"implemented later!"]; 
}

-(IBAction)followButtonAction:(id)sender {
    if (self.person.isMe) {
        [SVProgressHUD showErrorWithStatus:@"implemented later!"];
    }else{
        [[WaxAPIClient sharedClient] toggleFollowUserID:self.person.userID completion:^(BOOL complete, NSError *error) {
            if (!error) {
                self.person.following = !self.person.isFollowing;
                [self setUpFollowingLabel];
            }else{
                DLog(@"followed/unfollowed error %@", error);
            }
        }];
    }
}

#pragma mark - Convenience Methods
-(void)setUpFollowingLabel{
    NSAssert(self.person, @"Must have a person object set on profile header to setup follow button!");
    
    NSString *title = nil;

    if (self.person.isMe) {
        title = NSLocalizedString(@"Settings", @"Settings");
    }else{
        title = self.person.isFollowing ? NSLocalizedString(@"Unfollow", @"Unfollow") : NSLocalizedString(@"Follow", @"Follow");
    }
    [self.followButton setTitleForAllControlStates:title];
}

-(void)fetchProfileInfoAndUpdateUI{
    [[WaxAPIClient sharedClient] fetchProfileInformationForUser:self.userID completion:^(PersonObject *person, NSError *error) {
        if (!error) {
            self.person = person;
        }else{
            DLog(@"error fetching person for profile header %@", error);
        }
    }];
}









@end
