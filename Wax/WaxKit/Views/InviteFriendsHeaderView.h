//
//  InviteFriendsHeaderView.h
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

typedef NS_ENUM(NSInteger, InviteFriendsHeaderViewType){
    InviteFriendsHeaderViewTypeContacts = 1,
    InviteFriendsHeaderViewTypeFacebook,
};

#import <UIKit/UIKit.h>

@interface InviteFriendsHeaderView : UIView


+(InviteFriendsHeaderView *)inviteFriendsHeaderViewForContacts;
+(InviteFriendsHeaderView *)inviteFriendsHeaderViewForFacebook; 


@property (nonatomic) InviteFriendsHeaderViewType headerType; 

@end
