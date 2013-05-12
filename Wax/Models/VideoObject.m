//
//  VideoObject.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "VideoObject.h"

@implementation VideoObject

@synthesize username = _username;
@synthesize commentCount = _commentCount;
@synthesize likeCount = _likeCount;
@synthesize viewCount = _viewCount;
@synthesize timeStamp = _timeStamp;
@synthesize userid = _userid;
@synthesize vidId = _vidId;
@synthesize videoLink = _videoLink;
@synthesize shareId = _shareId;
@synthesize serverTimeStamp = _serverTimeStamp;
@synthesize isFollowing = _isFollowing;
@synthesize didLike = _didLike;
@synthesize caption = _caption;
@synthesize trendCount = _trendCount;
@synthesize location = _location;
@synthesize likeStamp = _likeStamp;
@synthesize noSharing = _noSharing;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if(self) {
        self.commentCount = [dictionary objectForKeyNotNull:@"commentcount"] ;
        
        self.likeCount = [dictionary objectForKeyNotNull:@"likecount"]  == nil ? 0 : [dictionary objectForKeyNotNull:@"likecount"];
        self.caption = [dictionary objectForKeyNotNull:@"caption"]  == nil ? @"" : [dictionary objectForKeyNotNull:@"caption"];
        
        self.location = [dictionary objectForKeyNotNull:@"address"];
        self.likeStamp = [dictionary objectForKeyNotNull:@"likestamp"];
        
        self.username = [dictionary objectForKeyNotNull:@"username"];
        self.userid = [dictionary objectForKeyNotNull:@"userid"];
        self.vidId = [dictionary objectForKeyNotNull:@"videoid"];
        self.videoLink = [dictionary objectForKeyNotNull:@"videolink"];
        
        self.serverTimeStamp = [dictionary objectForKeyNotNull:@"timestamp"];
        self.viewCount = [dictionary objectForKeyNotNull:@"viewcount"];
        self.shareId = [dictionary objectForKeyNotNull:@"shareid"];
        self.trendCount = [dictionary objectForKeyNotNull:@"trendcount"];
        
        self.isFollowing = [[dictionary objectForKeyNotNull:@"following"] boolValue];
        self.didLike = [[dictionary objectForKeyNotNull:@"didlike"] boolValue];
        self.noSharing = [[dictionary objectForKeyNotNull:@"canshare"] boolValue];
        
        if (self.location != nil) {
            self.timeStamp = [NSString stringWithFormat:@"%@ near %@", [NSString prettyTimeStamp:self.serverTimeStamp], self.location];
        }else{
            self.timeStamp = [NSString prettyTimeStamp:self.serverTimeStamp];
        }
    }
    return self;
}
-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"FeedObject Description:\nComment Count: %@ LikeCount: %@ Caption: %@ Timestamp: %@ Location: %@ Likestamp: %@ Username: %@ Userid: %@ VidId: %@ VideoLink: %@ ServerTimestamp: %@ ViewCount: %@ SharedId: %@ Trendcount: %@ IsFollowing: %i DidLike: %i NoSharing: %i", self.commentCount, self.likeCount, self.caption, self.timeStamp, self.location, self.likeStamp, self.username, self.userid, self.vidId, self.videoLink, self.serverTimeStamp, self.viewCount, self.shareId, self.trendCount, self.isFollowing, self.didLike, self.noSharing];
    return descrippy;
}

@end
