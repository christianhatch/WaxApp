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
@synthesize tag = _tag, userID = _userID, username = _username, videoID = _videoID, noteType = _noteType, noteText = _noteText; 
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
        
        self.infiniteScrollingID = [dictionary objectForKey:@"timestamp" orDefaultValue:nil];
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"NotificationObject Description: UserID=%@ Username=%@ NoteText=%@ NoteType=%@ VideoID=%@ Tag=%@ InfiniteScrollingID=%@", self.userID, self.username, self.noteText, StringFromNotificationType(self.noteType), self.videoID, self.tag, self.infiniteScrollingID];
    return descrippy;
}


@end