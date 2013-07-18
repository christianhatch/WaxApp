//
//  SendChallengeTableView.h
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

typedef NS_ENUM(NSInteger, SendChallengeTableViewType){
    SendChallengeTableViewTypeWax = 1,
    SendChallengeTableViewTypeContacts,
    SendChallengeTableViewTypeFacebook,
};


#import "WaxTableView.h"

@interface SendChallengeTableView : WaxTableView

+(SendChallengeTableView *)sendChallengeTableViewForWaxWithFrame:(CGRect)frame;
+(SendChallengeTableView *)sendChallengeTableViewForContactsWithFrame:(CGRect)frame;
+(SendChallengeTableView *)sendChallengeTableViewForFacebookWithFrame:(CGRect)frame;

@property (nonatomic, readonly) NSArray *selectedPersons;

@property (nonatomic) SendChallengeTableViewType tableViewType;


@end
