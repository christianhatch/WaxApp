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
@synthesize shareID = _shareID;
@synthesize timeStamp = _timeStamp;


@synthesize tag = _tag;
@synthesize category = _category; 
@synthesize votesCount = _votesCount;
@synthesize viewCount = _viewCount;
@synthesize caption = _caption;

@synthesize didVote = _didVote;
@synthesize infiniteScrollingID = _infiniteScrollingID;


-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {

        self.userID = [dictionary objectForKey:@"userid" orDefaultValue:nil];
        self.username = [dictionary objectForKey:@"username" orDefaultValue:NSLocalizedString(@"a user", @"a user")];
        self.rank = [dictionary objectForKey:@"rank" orDefaultValue:@"-"];
        self.tagCount = [dictionary objectForKey:@"tag_count" orDefaultValue:@0];
        
        self.videoID = [dictionary objectForKey:@"videoid" orDefaultValue:nil];
        self.shareID = [dictionary objectForKey:@"shareid" orDefaultValue:nil];
        self.timeStamp = [NSString prettyTimeStamp:[dictionary objectForKey:@"timestamp" orDefaultValue:[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]]];
        
        self.tag = [dictionary objectForKey:@"tag" orDefaultValue:NSLocalizedString(@"a competition", @"a competition")];
        self.category = [dictionary objectForKey:@"category" orDefaultValue:NSLocalizedString(@"a category", @"a category")]; 
        self.votesCount = [dictionary objectForKey:@"votes" orDefaultValue:@0];
        self.viewCount = [dictionary objectForKey:@"views" orDefaultValue:@0];
        self.caption = [dictionary objectForKey:@"captions" orDefaultValue:NSLocalizedString(@"a caption", @"a caption")];

        self.didVote = [[dictionary objectForKey:@"didvote" orDefaultValue:NO] boolValue];
       
        self.infiniteScrollingID = [dictionary objectForKey:@"timestamp" orDefaultValue:nil]; 
    }
    return self;
}
-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"VideoObject Description: UserID=%@ Username=%@ Rank=%@ TagCount=%@ VideoID=%@ ShareID=%@ TimeStamp=%@ Tag=%@ Category=%@ VotesCount=%@ ViewsCount=%@ DidVote=%@ InfiniteScrollingID=%@", self.userID, self.username, self.rank, self.tagCount, self.videoID, self.shareID, self.timeStamp, self.tag, self.category, self.votesCount, self.viewCount, HumanReadableStringFromBool(self.didVote), self.infiniteScrollingID];
    return descrippy;
}

#pragma mark - Public API
-(BOOL)isMine{
    return [WaxUser userIDIsCurrentUser:self.userID];
}
-(NSArray *)sharingActivityItems{
    return @[[NSString sharingTextFromCompetitionTag:self.tag andShareURL:[NSURL shareURLFromShareID:self.shareID]]];
}




@end
