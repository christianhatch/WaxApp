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
@property (nonatomic, strong) UILabel *titleLabel; 
@end

@implementation WaxFollowButton
@synthesize userID = _userID, following = _following, titleLabel = _titleLabel;

+(WaxFollowButton *)followButtonWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame{
    WaxFollowButton *btny = [[WaxFollowButton alloc] initWithUserID:userID following:following frame:frame];
    return btny; 
}
-(instancetype)initWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame{
 
    NSParameterAssert(userID);
    NSParameterAssert(!following || following == YES);
    
    self = [super initWithFrame:frame];
    if (self) {
        [super addTarget:self action:@selector(toggleFollow:) forControlEvents:UIControlEventTouchUpInside];
        self.userID = userID;
        self.following = following;
        [self addSubview:self.titleLabel];
        self.backgroundColor = [UIColor orangeColor]; 
    }
    return self;
}
-(void)didMoveToSuperview{
    [self setUpView]; 
}
-(void)setUpView{
    
    if (self.enabled) {
        if (self.isFollowing) {
            self.titleLabel.text = NSLocalizedString(@"Unfollow", @"Unfollow");
        }else{
            self.titleLabel.text = NSLocalizedString(@"Follow", @"Follow");
        }
    }else{
        self.titleLabel.text = NSLocalizedString(@"......", @"......");
    }
}
-(void)toggleFollow:(id)sender{

    NSAssert(self.userID, @"must set userid on followbutton!");

    self.enabled = NO;
    
    if (self.isFollowing) {
        [AIKErrorManager logMessageToAllServices:@"User unfollowed another user"];
    }else{
        [AIKErrorManager logMessageToAllServices:@"User followed another user"];
    }

    
    [[WaxAPIClient sharedClient] toggleFollowUserID:self.userID completion:^(BOOL complete, NSError *error) {
        self.enabled = YES;
        
        if (!error) {
            self.following = !self.isFollowing;
        }else{
            VLog(@"error following or unfollowing %@", error);
        }
    }]; 
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesForDimming:touches withTouchesEnded:NO];
    [super touchesBegan:touches withEvent:event];
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesForDimming:touches withTouchesEnded:NO];
    [super touchesMoved:touches withEvent:event];
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesForDimming:touches withTouchesEnded:YES];
    [super touchesEnded:touches withEvent:event];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    [self handleTouchesForDimming:touches withTouchesEnded:YES];
    [super touchesEnded:touches withEvent:event];
}

#pragma mark - Getters
-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectInset(self.bounds, 4, 4)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.backgroundColor = [UIColor clearColor]; 
    }
    return _titleLabel;
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
        [self setUpView];
    }
}

-(void)setEnabled:(BOOL)enabled{
    [super setEnabled:enabled];
    [self setUpView]; 
}

@end
