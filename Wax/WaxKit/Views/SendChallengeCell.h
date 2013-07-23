//
//  SendChallengeCell.h
//  Wax
//
//  Created by Christian Hatch on 7/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, SendChallengeCellType){
    SendChallengeCellTypeContacts = 1,
    SendChallengeCellTypeFacebook,
    SendChallengeCellTypeTwitter,
};

#define kSendChallengeCellIDHeight  80
#define kSendChallengeCellID        @"SendChallengeCellID"


#import "WaxTableViewCell.h"

@interface SendChallengeCell : WaxTableViewCell

@property (nonatomic, assign) SendChallengeCellType cellType;

-(void)setChallengeTag:(NSString *)tag shareURL:(NSURL *)shareURL;

-(void)didSelect; 

@end
