//
//  WaxFollowButton.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxFollowButton.h"

@interface WaxFollowButton ()
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, readwrite, getter = isFollowing) BOOL following; 
@end

@implementation WaxFollowButton
@synthesize userID = _userID, following = _following; 

+(WaxFollowButton *)followButtonWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame{
    WaxFollowButton *btny = [[WaxFollowButton alloc] initWithUserID:userID following:following frame:frame];
    return btny; 
}
-(instancetype)initWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame{
 
    NSParameterAssert(userID);
    NSParameterAssert(!following || following == YES);
    
    self = [UIButton buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.frame = frame; 
        [self addTarget:self action:@selector(toggleFollow:) forControlEvents:UIControlEventTouchUpInside];
        self.userID = userID;
        self.following = following;
    }
    return self;
}
-(void)setUpView{
    NSAssert(self.isFollowing, @"must set isfollowing on followbutton!");
    
    if (self.enabled) {
        if (self.isFollowing) {
            [self setTitleForAllControlStates:NSLocalizedString(@"Unfollow", @"Unfollow")];
        }else{
            [self setTitleForAllControlStates:NSLocalizedString(@"Follow", @"Follow")];
        }
    }else{
        [self setTitleForAllControlStates:NSLocalizedString(@"......", @"......")];
    }
}
-(void)toggleFollow:(UIButton *)sender{

    NSAssert(self.userID, @"must set userid on followbutton!");

    self.enabled = NO;
    [[WaxAPIClient sharedClient] toggleFollowUserID:self.userID completion:^(BOOL complete, NSError *error) {
        self.enabled = YES; 
        if (!error) {
            self.following = !self.isFollowing;
        }else{
            VLog(@"error following or unfollowing %@", error);
        }
    }]; 
}

#pragma mark - Setters
-(void)setFollowing:(BOOL)following{
    if (_following != following) {
        _following = following;
        [self setUpView]; 
    }
}
-(void)setUserID:(NSString *)userID{

    NSParameterAssert(userID);
    
    if (_userID != userID) {
        _userID = userID; 
    }
}
-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setUpView]; 
}

@end
