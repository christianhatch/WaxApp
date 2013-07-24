//
//  NotificationObject.m
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationObject.h"

@interface NotificationObject ()
@property (nonatomic, readwrite) NotificationType noteType; 
@end

@implementation NotificationObject
@synthesize tag = _tag, userID = _userID, username = _username, videoID = _videoID, noteType = _noteType, noteText = _noteText, unread = _unread, timeStamp = _timeStamp, voteCount = _voteCount; 
@synthesize infiniteScrollingID = _infiniteScrollingID;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        
        self.noteType = [[dictionary objectForKey:@"type" orDefaultValue:0] integerValue];
        
        self.userID = [dictionary objectForKey:@"userid" orDefaultValue:nil];        
        self.videoID = [dictionary objectForKey:@"videoid" orDefaultValue:nil];
        self.tag = [dictionary objectForKey:@"tag" orDefaultValue:NSLocalizedString(@"a competition", @"a competition")];
        
        self.username = [dictionary objectForKey:@"username" orDefaultValue:NSLocalizedString(@"a user", @"a user")];
        self.noteText = [dictionary objectForKey:@"text" orDefaultValue:NSLocalizedString(@"something cool happened", @"something cool happened")]; 
        self.timeStamp = [NSString prettyTimeStamp:[dictionary objectForKey:@"timestamp" orDefaultValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]];
        self.voteCount = [dictionary objectForKey:@"vote_count" orDefaultValue:@0];

        self.infiniteScrollingID = [dictionary objectForKey:@"timestamp" orDefaultValue:nil];
        
        self.unread = [[dictionary objectForKey:@"unread" orDefaultValue:NO] boolValue];
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"NotificationObject Description: UserID=%@ Username=%@ NoteText=%@ NoteType=%@ VideoID=%@ Tag=%@ Timestamp=%@ Unread=%@ InfiniteScrollingID=%@", self.userID, self.username, self.noteText, StringFromNotificationType(self.noteType), self.videoID, self.tag, self.timeStamp, HumanReadableStringFromBool(self.unread), self.infiniteScrollingID];
    return descrippy;
}


@end
