//
//  InviteFriendsHeaderView.m
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#import "InviteFriendsHeaderView.h"

@implementation InviteFriendsHeaderView
@synthesize headerType = _headerType;

+(InviteFriendsHeaderView *)inviteFriendsHeaderViewForContacts{
    InviteFriendsHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"InviteFriendsHeaderView" owner:self options:nil] firstObject];
    head.headerType = InviteFriendsCellTypeContacts;
    return head; 
}
+(InviteFriendsHeaderView *)inviteFriendsHeaderViewForFacebook{
    InviteFriendsHeaderView *head = [[[NSBundle mainBundle] loadNibNamed:@"InviteFriendsHeaderView" owner:self options:nil] firstObject];
    head.headerType = InviteFriendsCellTypeFacebook;
    return head;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
}

-(void)setHeaderType:(InviteFriendsHeaderViewType)headerType{
    NSParameterAssert(headerType);
    _headerType = headerType;
}




@end
