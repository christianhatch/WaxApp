//
//  WaxFollowButton.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaxFollowButton : UIControl

+(WaxFollowButton *)followButtonWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame;
-(instancetype)initWithUserID:(NSString *)userID following:(BOOL)following frame:(CGRect)frame;

-(void)setUserID:(NSString *)userID;
-(void)setFollowing:(BOOL)following;

@end
