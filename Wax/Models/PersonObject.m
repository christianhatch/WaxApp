//
//  PersonObject.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "PersonObject.h"


#define kuseridKey              @"userid"
#define kusernameKey            @"username"
#define kfullnameKey            @"fullname"

#define kisFollowingKey         @"isfollowing"

#define kfollowersCountKey      @"followerscount"
#define kfollowingCountKey      @"followingcount"
#define ktitlesCountKey         @"titlescount"


@implementation PersonObject
@synthesize userid = _userid;
@synthesize username = _username;
@synthesize fullName = _fullName;

@synthesize isFollowing = _isFollowing;

@synthesize followersCount = _followersCount;
@synthesize followingCount = _followingCount;
@synthesize titlesCount = _titlesCount;

@synthesize infiniteScrollingID = _infiniteScrollingID;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        @try {
            self.userid = [dictionary objectForKeyNotNull:@"userid"];
            self.username = [dictionary objectForKeyNotNull:@"username"];
            self.fullName = [dictionary objectForKeyNotNull:@"name"];
            
            self.isFollowing = [[dictionary objectForKeyNotNull:@"isfollowing"] boolValue];
            
            self.followersCount = [dictionary objectForKeyNotNull:@"followers"];
            self.followingCount = [dictionary objectForKeyNotNull:@"following"];
            self.titlesCount = [dictionary objectForKeyNotNull:@"titles"];
            
            self.infiniteScrollingID = [dictionary objectForKeyNotNull:@"item_number"];
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
            self.fullName = [NSString stringWithFormat:@"%@ %@", graphuser.first_name, graphuser.last_name];
        }
        @catch (NSException *exception) {
            [[AIKErrorUtilities sharedUtilities] logExceptionWithMessage:@"Tried to init person object with a nil fbgraphuser!" exception:exception];
        }
    }
    return self;
}


-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"PersonObject:\nUserid: %@\nUsername: %@\nFullname: %@\nIsFollowing: %i\nFollowersCount: %@\nFollowingCount: %@\nTitlesCount: %@\nInfiniteScrollingID: %@", self.userid, self.username, self.fullName, self.isFollowing, self.followersCount, self.followingCount, self.titlesCount, self.infiniteScrollingID];
    return descrippy;
}


- (id)initWithCoder:(NSCoder *)acoder {
    self = [super init];
    if (self) {
        _userid = [acoder decodeObjectForKey:kuseridKey];
        _username = [acoder decodeObjectForKey:kusernameKey];
        _fullName = [acoder decodeObjectForKey:kfullnameKey];
        
        _isFollowing = [acoder decodeBoolForKey:kisFollowingKey];
       
        _followersCount = [acoder decodeObjectForKey:kfollowersCountKey];
        _followingCount = [acoder decodeObjectForKey:kfollowingCountKey];
        _titlesCount = [acoder decodeObjectForKey:ktitlesCountKey];

        _infiniteScrollingID = [acoder decodeObjectForKey:kinfiniteScrollingIDKey]; 
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)acoder {
    [acoder encodeObject:_userid forKey:kuseridKey];
    [acoder encodeObject:_username forKey:kusernameKey];
    [acoder encodeObject:_fullName forKey:kfullnameKey];
    
    [acoder encodeBool:_isFollowing forKey:kisFollowingKey];
   
    [acoder encodeObject:_followersCount forKey:kfollowersCountKey];
    [acoder encodeObject:_followingCount forKey:kfollowingCountKey];
    [acoder encodeObject:_titlesCount forKey:ktitlesCountKey];

    [acoder encodeObject:_infiniteScrollingID forKey:kinfiniteScrollingIDKey];
}


@end
