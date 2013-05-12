//
//  PersonObject.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonObject.h"


#define kusernameKey            @"username"
#define kuseridKey              @"userid"
#define kisFollowingKey         @"isfollowing"
#define kfollowingCountKey      @"followingcount"
#define kfollowersCountKey      @"followerscount"
#define klikeCountKey           @"likecount"
#define kserverTimestampKey     @"servertimestamp"
#define kcountKey               @"count"
#define kfirstnameKey           @"firstname"
#define klastnameKey            @"lastname"


@implementation PersonObject
@synthesize username = _username;
@synthesize userid = _userid;
@synthesize isFollowing = _isFollowing;
@synthesize followingCount = _followingCount;
@synthesize followersCount = _followersCount;
@synthesize likeCount = _likeCount;
@synthesize serverTimeStamp = _serverTimeStamp;
@synthesize count = _count;
@synthesize firstname = _firstname;
@synthesize lastname = _lastname;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        @try {
            self.username = [dictionary objectForKeyNotNull:@"username"];
            self.firstname = [dictionary objectForKeyNotNull:@"firstname"];
            self.lastname = [dictionary objectForKeyNotNull:@"lastname"];
            
            self.followersCount = [dictionary objectForKeyNotNull:@"followerscount"];
            self.followingCount = [dictionary objectForKeyNotNull:@"followingcount"];
            self.likeCount = [dictionary objectForKeyNotNull:@"likecount"];
            
            self.userid = [dictionary objectForKeyNotNull:@"userid"];
            self.isFollowing = [[dictionary objectForKeyNotNull:@"isfollowing"] boolValue];
            
            self.serverTimeStamp = [dictionary objectForKeyNotNull:@"timestamp"];
            self.count = [dictionary objectForKeyNotNull:@"count"] ;
        }
        @catch (NSException *exception) {
            [[AIKErrorUtilities sharedUtilities] logExceptionWithMessage:@"Tried to init person object with a nil persondictionary!" exception:exception];
        }
    }
    return self;
}
-(id)initWithFBGraphUser:(id<FBGraphUser>)graphuser{
    self = [super init];
    if (self) {
        @try {
            self.userid = graphuser.id;
            self.firstname = graphuser.first_name;
            self.lastname = graphuser.last_name;
        }
        @catch (NSException *exception) {
            [[AIKErrorUtilities sharedUtilities] logExceptionWithMessage:@"Tried to init person object with a nil fbgraphuser!" exception:exception];
        }
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"PersonObject:\nUsername: %@\nFirstname: %@\nLastname: %@\nFollowersCount: %@\nFollowingCount: %@\nLikeCount: %@\nUserid: %@\nIsFollowing: %i\nServerTimestamp: %@\nCount: %@\n", self.username, self.firstname, self.lastname, self.followersCount, self.followingCount, self.likeCount, self.userid, self.isFollowing, self.serverTimeStamp, self.count];
    return descrippy;
}

- (id)initWithCoder:(NSCoder *)acoder {
    self = [super init];
    if (self) {
        _username = [acoder decodeObjectForKey:kusernameKey];
        _userid = [acoder decodeObjectForKey:kuseridKey];
        _isFollowing = [acoder decodeBoolForKey:kisFollowingKey];
        _followersCount = [acoder decodeObjectForKey:kfollowersCountKey];
        _followingCount = [acoder decodeObjectForKey:kfollowingCountKey];
        _likeCount = [acoder decodeObjectForKey:klikeCountKey];
        _serverTimeStamp = [acoder decodeObjectForKey:kserverTimestampKey];
        _count = [acoder decodeObjectForKey:kcountKey];
        _firstname = [acoder decodeObjectForKey:kfirstnameKey];
        _lastname = [acoder decodeObjectForKey:klastnameKey];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)acoder {
    [acoder encodeObject:_username forKey:kusernameKey];
    [acoder encodeObject:_userid forKey:kuseridKey];
    [acoder encodeBool:_isFollowing forKey:kisFollowingKey];
    [acoder encodeObject:_followersCount forKey:kfollowersCountKey];
    [acoder encodeObject:_followingCount forKey:kfollowingCountKey];
    [acoder encodeObject:_likeCount forKey:klikeCountKey];
    [acoder encodeObject:_serverTimeStamp forKey:kserverTimestampKey];
    [acoder encodeObject:_count forKey:kcountKey];
    [acoder encodeObject:_firstname forKey:kfirstnameKey];
    [acoder encodeObject:_lastname forKey:klastnameKey];
}


@end
