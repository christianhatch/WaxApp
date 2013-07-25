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

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UIButton *followersButton;
@property (strong, nonatomic) IBOutlet UIButton *followingButton;

@property (strong, nonatomic) IBOutlet WaxRoundButton *followButton;

- (IBAction)followButtonAction:(id)sender;
- (IBAction)followersButtonAction:(id)sender;
- (IBAction)followingButtonAction:(id)sender;

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
-(void)awakeFromNib{
    [super awakeFromNib];

    [self.followButton styleAsWaxRoundButtonWhiteWithTitle:nil];
    
    [self.nameLabel setWaxHeaderFontOfSize:20];
    self.nameLabel.textColor = [UIColor whiteColor];
    
    [self.followingButton styleFontAsWaxHeaderFontOfSize:14 color:[UIColor waxDetailFontColor] highlightedColor:[UIColor whiteColor]];
    [self.followersButton styleFontAsWaxHeaderFontOfSize:14 color:[UIColor waxDetailFontColor] highlightedColor:[UIColor whiteColor]];
}

-(void)setUpView{
    PersonObject *person = self.person;
   
    if (!person.isMe) {
        [self.profilePictureView setImageForProfilePictureWithUserID:person.userID buttonHandler:nil];
    }else{
        
        __block ProfileHeaderView *blockSelf = self; 
        [self.profilePictureView setImageForProfilePictureWithUserID:person.userID buttonHandler:^(UIImageView *imageView) {
                  
            [[WaxUser currentUser] chooseNewprofilePictureFromViewController:[blockSelf nearestViewController] completion:^(UIImage *profilePicture, NSError *error) {
                if (profilePicture) {
                    [imageView setImage:profilePicture animated:YES];
                }else{
                    VLog(@"error choosing new profile pic %@", error);
                }
            }];
            
        }];
    }
    
    self.nameLabel.text = person.fullName;
    
    [self.followingButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Following", @"%@ Following"), person.followingCount]];
    [self.followersButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Followers", @"%@ Followers"), person.followersCount]];
   
    [self setUpButton];
}
-(void)setPerson:(PersonObject *)person{
    
    NSParameterAssert(person);
    
    if (_person != person) {
        _person = person; 
        [self setUpView];
    }
}
-(void)setUserID:(NSString *)userID{

    NSParameterAssert(userID);
    
    if (_userID != userID) {
        _userID = userID;
        [self setUpButton]; 
        [self fetchProfileInfoAndUpdateUI];
    }
}

#pragma mark - IBActions

-(IBAction)followButtonAction:(id)sender {
    if ([WaxUser userIDIsCurrentUser:self.userID] || self.person.isMe) {
        [self showSettings];
        return; 
    }
    
    if (!self.person) {
        return; 
    }
    [self toggleFollow];
}

- (IBAction)followersButtonAction:(id)sender {
    if (!self.person) {
        return;
    }
    PersonListViewController *plvc = [PersonListViewController personListViewControllerForFollowersFromUserID:self.person.userID];
    [self.nearestNavigationController pushViewController:plvc animated:YES];
}

- (IBAction)followingButtonAction:(id)sender {
    if (!self.person) {
        return;
    }
    PersonListViewController *plvc = [PersonListViewController personListViewControllerForFollowingFromUserID:self.person.userID];
    [self.nearestNavigationController pushViewController:plvc animated:YES];
}


#pragma mark - Public API
-(void)refreshData{
    [self fetchProfileInfoAndUpdateUI]; 
}

#pragma mark - Convenience Methods
-(void)setUpButton{
    if ([WaxUser userIDIsCurrentUser:self.userID] || self.person.isMe) {
        [self setUpButtonForSettings];
        return;
    }
    
    if (self.person && !self.person.isMe) {
        [self setUpButtonAsFollowButton];
    }
}
-(void)setUpButtonAsFollowButton{
    NSAssert(self.person, @"Must have a person object set on profile header to setup follow button!");
    
    NSString *title = self.person.isFollowing ? NSLocalizedString(@"Unfollow", @"Unfollow") : NSLocalizedString(@"Follow", @"Follow");;
    
    [self.followButton setTitleForAllControlStates:title];
}
-(void)setUpButtonForSettings{
    
    [self.followButton setTitleForAllControlStates:NSLocalizedString(@"Settings", @"Settings")];
}

-(void)updateFollowersCountLabel{
    
    if (self.person.followersCount.integerValue != 1) {
        [self.followersButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Followers", @"%@ Followers"), self.person.followersCount]];
    }else{
        [self.followersButton setTitleForAllControlStates:[NSString stringWithFormat:NSLocalizedString(@"%@ Follower", @"%@ Follower"), self.person.followersCount]];
    }
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
-(void)showSettings{
    SettingsViewController *settings = initViewControllerWithIdentifier(@"SettingsVC");
    [self.nearestNavigationController pushViewController:settings animated:YES];
}
-(void)toggleFollow{
    [[WaxAPIClient sharedClient] toggleFollowUserID:self.person.userID completion:^(BOOL complete, NSError *error) {
        if (!error) {
            self.person.following = !self.person.isFollowing;
            
            self.person.followersCount = [NSNumber numberWithInteger:self.person.isFollowing ? self.person.followersCount.integerValue + 1 : self.person.followersCount.integerValue - 1];
            [self updateFollowersCountLabel];
            
            [self setUpButton];
        }else{
            DLog(@"followed/unfollowed error %@", error);
        }
    }];
}








@end
