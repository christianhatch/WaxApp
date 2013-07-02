//
//  NotificationObject.h
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

typedef NS_ENUM(NSInteger, NotificationType){
    NotificationTypeVote = 1,
    NotificationTypeFollow,
    NotificationTypeTitleEarned,
    NotificationTypeTitleStolen,
    NotificationTypeChallengeResponse,
    NotificationTypeChallenged,
};

static inline NSString * StringFromNotificationType(NotificationType noteType) {
    switch (noteType) {
        case NotificationTypeVote:
            return @"Vote";
            break;
        case NotificationTypeFollow:
            return @"Follow";
            break;
        case NotificationTypeTitleEarned:
            return @"Title Earned";
            break;
        case NotificationTypeTitleStolen:
            return @"Title Stolen";
            break;
        case NotificationTypeChallengeResponse:
            return @"Challenge Response";
            break;
        case NotificationTypeChallenged:
            return @"Challenged";
            break; 
        default:
            return @"none(!)";
            break;
    }
}

#import "ModelObject.h"

@interface NotificationObject : ModelObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username; 
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *noteText;

@property (nonatomic, readonly) NotificationType noteType; 

@end
