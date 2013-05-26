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

#define kfollowingKey           @"isfollowing"

#define kfollowersCountKey      @"followerscount"
#define kfollowingCountKey      @"followingcount"
#define ktitlesCountKey         @"titlescount"


@implementation PersonObject
@synthesize userID = _userID;
@synthesize username = _username;
@synthesize fullName = _fullName;

@synthesize following = _following;

@synthesize followersCount = _followersCount;
@synthesize followingCount = _followingCount;
@synthesize titlesCount = _titlesCount;

@synthesize infiniteScrollingID = _infiniteScrollingID;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
//        @try {
            self.userID = [dictionary objectForKey:@"userid" orDefaultValue:@""];
            self.username = [dictionary objectForKey:@"username" orDefaultValue:NSLocalizedString(@"a user", @"a user")];
            self.fullName = [dictionary objectForKey:@"name"  orDefaultValue:NSLocalizedString(@"a user", @"a user")];
            
            self.following = [[dictionary objectForKey:@"isfollowing" orDefaultValue:NO] boolValue];
            
            self.followersCount = [dictionary objectForKey:@"followers" orDefaultValue:@0];
            self.followingCount = [dictionary objectForKey:@"following" orDefaultValue:@0];
            self.titlesCount = [dictionary objectForKey:@"titles" orDefaultValue:@0];
            
            self.infiniteScrollingID = [dictionary objectForKey:@"item_number" orDefaultValue:nil];
        
//        }
//        @catch (NSException *exception) {
//            [[AIKErrorUtilities sharedUtilities] logExceptionWithMessage:@"Tried to init person object with a nil persondictionary!" exception:exception];
//        }
    }
    return self;
}

-(id)initWithFBGraphUser:(id<FBGraphUser>)graphuser{
    self = [super init];
    if (self) {
        @try {
            self.userID = graphuser.id;
            self.fullName = [NSString stringWithFormat:@"%@ %@", graphuser.first_name, graphuser.last_name];
        }
        @catch (NSException *exception) {
            [[AIKErrorManager sharedManager] logExceptionWithMessage:@"Tried to init person object with a nil fbgraphuser!" exception:exception];
        }
    }
    return self;
}


-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"PersonObject:\nUserid: %@\nUsername: %@\nFullname: %@\nFollowing: %i\nFollowersCount: %@\nFollowingCount: %@\nTitlesCount: %@\nInfiniteScrollingID: %@", self.userID, self.username, self.fullName, self.following, self.followersCount, self.followingCount, self.titlesCount, self.infiniteScrollingID];
    return descrippy;
}


- (id)initWithCoder:(NSCoder *)acoder {
    self = [super init];
    if (self) {
        _userID = [acoder decodeObjectForKey:kuseridKey];
        _username = [acoder decodeObjectForKey:kusernameKey];
        _fullName = [acoder decodeObjectForKey:kfullnameKey];
        
        _following = [acoder decodeBoolForKey:kfollowingKey];
       
        _followersCount = [acoder decodeObjectForKey:kfollowersCountKey];
        _followingCount = [acoder decodeObjectForKey:kfollowingCountKey];
        _titlesCount = [acoder decodeObjectForKey:ktitlesCountKey];

        _infiniteScrollingID = [acoder decodeObjectForKey:kinfiniteScrollingIDKey]; 
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)acoder {
    [acoder encodeObject:_userID forKey:kuseridKey];
    [acoder encodeObject:_username forKey:kusernameKey];
    [acoder encodeObject:_fullName forKey:kfullnameKey];
    
    [acoder encodeBool:_following forKey:kfollowingKey];
   
    [acoder encodeObject:_followersCount forKey:kfollowersCountKey];
    [acoder encodeObject:_followingCount forKey:kfollowingCountKey];
    [acoder encodeObject:_titlesCount forKey:ktitlesCountKey];

    [acoder encodeObject:_infiniteScrollingID forKey:kinfiniteScrollingIDKey];
}


@end
