//
//  SendChallengeTopCell.h
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, InviteFriendsCellType){
    InviteFriendsCellTypeContacts = 1,
    InviteFriendsCellTypeFacebook,
};

#define kInviteFriendsCellIDHeight  80
#define kInviteFriendsCellID        @"InviteFriendsCellID"


#import "WaxTableViewCell.h"

@interface InviteFriendsCell : WaxTableViewCell

@property (nonatomic) InviteFriendsCellType *cellType; 

@end
