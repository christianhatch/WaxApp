//
//  WaxFollowButton.m
//  Wax
//
//  Created by Christian Hatch on 6/28/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxFollowButton.h"


@interface WaxFollowButton ()
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, getter = isFollowing) BOOL following;
@end
@implementation WaxFollowButton
@synthesize userID = _userID, following = _following;


#pragma mark - Alloc & Init
+(WaxFollowButton *)followButtonWithUserID:(NSString *)userID isFollowing:(BOOL)isFollowing frame:(CGRect)frame{
    WaxFollowButton *btn = [[WaxFollowButton alloc] initWithUserID:userID isFollowing:isFollowing frame:frame];
    return btn;
}
-(instancetype)initWithUserID:(NSString *)userID isFollowing:(BOOL)isFollowing frame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userID = userID;
        self.following = isFollowing;
        [self configure];
    }
    return self;
}

-(void)setUserid:(NSString *)userID isFollowing:(BOOL)isFollowing{
    self.userID = userID;
    self.following = isFollowing;
    [self updateUI];
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self configure];
    }
    return self;
}
-(void)configure{
    [super addTarget:self action:@selector(toggleFollow:) forControlEvents:UIControlEventTouchUpInside];
    [self styleAsWaxRoundButtonGreyWithTitle:@""];
    [self updateUI];
}
-(void)updateUI{
    if (self.enabled) {
        if (self.isFollowing) {
            [self styleAsWaxRoundButtonBlueWithTitle:NSLocalizedString(@"Unfollow", @"Unfollow")];
//            [self setTitleForAllControlStates:NSLocalizedString(@"Unfollow", @"Unfollow")];
        }else{
            [self styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Follow", @"Follow")];
//            [self setTitleForAllControlStates:NSLocalizedString(@"Follow", @"Follow")];
        }
    }else{
        [self setTitleForAllControlStates:@"......"];
    }
}


#pragma mark - Internal Methods
-(void)toggleFollow:(id)sender{
    
    self.enabled = NO;
    
    [[WaxAPIClient sharedClient] toggleFollowUserID:self.userID completion:^(BOOL complete, NSError *error) {
        
        self.enabled = YES;
        
        if (!error) {
            if (self.isFollowing) {
                [AIKErrorManager logMessage:@"User unfollowed another user"];
            }else{
                [AIKErrorManager logMessage:@"User followed another user"];
            }
            
            self.following = !self.isFollowing;
            
        }else{
            DDLogError(@"error following or unfollowing %@", error);
        }
    }];
}

#pragma mark - Setters
-(void)setFollowing:(BOOL)following{
    _following = following;
    [self updateUI];
}
-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self updateUI];
}

@end
