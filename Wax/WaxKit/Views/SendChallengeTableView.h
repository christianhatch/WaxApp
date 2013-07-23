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
//    SendChallengeTableViewTypeTwitter,
};


#import "WaxTableView.h"

@interface SendChallengeTableView : WaxTableView

+(SendChallengeTableView *)sendChallengeTableViewForWaxWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame;
+(SendChallengeTableView *)sendChallengeTableViewForContactsWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame;
+(SendChallengeTableView *)sendChallengeTableViewForFacebookWithChallengeTag:(NSString *)challengeTag shareURL:(NSURL *)shareURL frame:(CGRect)frame;

@property (nonatomic, readonly) NSArray *selectedPersons;

@property (nonatomic, assign) SendChallengeTableViewType tableViewType;


@end
