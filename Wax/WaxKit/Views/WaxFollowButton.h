//
//  WaxFollowButton.h
//  Wax
//
//  Created by Christian Hatch on 6/28/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxRoundButton.h"

@interface WaxFollowButton : WaxRoundButton

+(WaxFollowButton *)followButtonWithUserID:(NSString *)userID isFollowing:(BOOL)isFollowing frame:(CGRect)frame;
-(instancetype)initWithUserID:(NSString *)userID isFollowing:(BOOL)isFollowing frame:(CGRect)frame;

-(void)setUserid:(NSString *)userID isFollowing:(BOOL)isFollowing;



@end
