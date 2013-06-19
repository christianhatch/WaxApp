//
//  ProfileHeaderView.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ProfileHeaderView.h"
#import "PersonListViewController.h"

@interface ProfileHeaderView ()
@property (nonatomic, strong) NSString *userID; 
@end

@implementation ProfileHeaderView
@synthesize profilePictureView = _profilePictureView, nameLabel = _nameLabel;
@synthesize followButton = _followButton, followersButton = _followersButton, followingButton = _followingButton;
@synthesize person = _person, userID = _userID;

#pragma mark - Alloc & Init
+(ProfileHeaderView *)profileHeaderViewForUserID:(NSString *)userID{
    ProfileHeaderView *header = [[[NSBundle mainBundle] loadNibNamed:@"ProfileHeaderView" owner:self options:nil] objectAtIndexOrNil:0];
    header.userID = userID; 
    return header;
}
-(void)setUpView{
    PersonObject *person = self.person;
   
    [self.profilePictureView setImageForProfilePictureWithUserID:person.userID buttonHandler:nil];
   
    self.nameLabel.text = person.username;
    
    [self updateFollowersCountLabel];
    [self.followingButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Following", @"%@ Following"), person.followingCount]];
   
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

-(IBAction)followButtonAction:(id)sender {
    if (self.person.isMe) {
        [SVProgressHUD showErrorWithStatus:@"implemented later!"];
    }else{
        [[WaxAPIClient sharedClient] toggleFollowUserID:self.person.userID completion:^(BOOL complete, NSError *error) {
            if (!error) {
                self.person.following = !self.person.isFollowing;

                self.person.followersCount = [NSNumber numberWithInteger:self.person.isFollowing ? self.person.followersCount.integerValue + 1 : self.person.followersCount.integerValue - 1];
                [self updateFollowersCountLabel];
                
                [self setUpFollowingLabel];
            }else{
                DLog(@"followed/unfollowed error %@", error);
            }
        }];
    }
}

- (IBAction)followersButtonAction:(id)sender {
    PersonListViewController *plvc = [PersonListViewController personListViewControllerForFollowersFromUserID:self.person.userID];
    UIViewController *vc = [self nearestViewController];
    [vc.navigationController pushViewController:plvc animated:YES];
}

- (IBAction)followingButtonAction:(id)sender {
    PersonListViewController *plvc = [PersonListViewController personListViewControllerForFollowingFromUserID:self.person.userID];
    UIViewController *vc = [self nearestViewController];
    [vc.navigationController pushViewController:plvc animated:YES];
}

#pragma mark - Public API
-(void)refreshData{
    [self fetchProfileInfoAndUpdateUI]; 
}

#pragma mark - Convenience Methods
-(void)setUpFollowingLabel{
    NSAssert(self.person, @"Must have a person object set on profile header to setup follow button!");
    
    NSString *title = self.person.isFollowing ? NSLocalizedString(@"Unfollow", @"Unfollow") : NSLocalizedString(@"Follow", @"Follow");;

    if (self.person.isMe) {
        title = NSLocalizedString(@"Settings", @"Settings");
    }
    
    [self.followButton setTitleForAllControlStates:title];
}
-(void)updateFollowersCountLabel{
    [self.followersButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Followers", @"%@ Followers"), self.person.followersCount]];
}
-(void)fetchProfileInfoAndUpdateUI{
    [[WaxAPIClient sharedClient] fetchProfileInformationForUserID:self.userID completion:^(PersonObject *person, NSError *error) {
        if (!error) {
            self.person = person;
        }else{
            DLog(@"error fetching person for profile header %@", error);
        }
    }];
}








@end
