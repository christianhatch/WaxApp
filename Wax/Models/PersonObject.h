//
//  PersonObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface PersonObject : NSObject <NSCoding>

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *firstname;
@property (nonatomic, copy) NSString *lastname;
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSNumber *followersCount;
@property (nonatomic, copy) NSNumber *followingCount;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSNumber *serverTimeStamp;
@property (nonatomic, copy) NSNumber *count;

@property (nonatomic, assign) BOOL isFollowing;

-(id)initWithDictionary:(NSDictionary *)personDictionary;
-(id)initWithFBGraphUser:(id <FBGraphUser>)graphuser;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;


@end
