//
//  VideoObject.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "VideoObject.h"



@implementation VideoObject

@synthesize userID = _userID;
@synthesize username = _username;
@synthesize rank = _rank;
@synthesize tagCount = _tagCount;

@synthesize videoID = _videoID;
@synthesize videoLink = _videoLink;
//@synthesize caption = _caption;
@synthesize shareID = _shareID;
@synthesize timeStamp = _timeStamp;
@synthesize tag = _tag;

@synthesize votesCount = _votesCount;
@synthesize viewCount = _viewCount;

@synthesize didVote = _didVote;
@synthesize infiniteScrollingID = _infiniteScrollingID;


-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {

        self.userID = [dictionary objectForKey:@"userid" orDefaultValue:nil];
        self.username = [dictionary objectForKey:@"username" orDefaultValue:NSLocalizedString(@"a user", @"a user")];
        self.rank = [dictionary objectForKey:@"rank" orDefaultValue:@0];
        self.tagCount = [dictionary objectForKey:@"tag_count" orDefaultValue:@0];
        
        self.videoID = [dictionary objectForKey:@"videoid" orDefaultValue:nil];
        self.videoLink = [dictionary objectForKey:@"videolink" orDefaultValue:nil];
//        self.caption = 
        self.shareID = [dictionary objectForKey:@"shareid" orDefaultValue:nil];
        self.timeStamp = [NSString prettyTimeStamp:[dictionary objectForKey:@"timestamp" orDefaultValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]];
        self.tag = [dictionary objectForKey:@"tag" orDefaultValue:NSLocalizedString(@"a competition", @"a competition")];
        
        self.votesCount = [dictionary objectForKey:@"votes" orDefaultValue:@0];
        self.viewCount = [dictionary objectForKey:@"views" orDefaultValue:@0];
        
        self.didVote = [[dictionary objectForKey:@"didvote" orDefaultValue:NO] boolValue];
       
        self.infiniteScrollingID = [dictionary objectForKey:@"timestamp" orDefaultValue:nil]; 
    }
    return self;
}
-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"VideoObject Description:\nUserID: %@ Username: %@ Rank: %@ TagCount: %@ VideoID: %@ VideoLink: %@ ShareID: %@ TimeStamp: %@ Tag: %@ VotesCount: %@ ViewsCount: %@ DidVote: %i", self.userID, self.username, self.rank, self.tagCount, self.videoID, self.videoLink, self.shareID, self.timeStamp, self.tag, self.votesCount, self.viewCount, self.didVote];
    return descrippy;
}

@end
