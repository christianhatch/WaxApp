//
//  PersonObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"
#import <FacebookSDK/FacebookSDK.h>

@interface PersonObject : ModelObject

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, assign) BOOL isFollowing;

@property (nonatomic, copy) NSNumber *followersCount;
@property (nonatomic, copy) NSNumber *followingCount;
@property (nonatomic, copy) NSNumber *titlesCount;


-(id)initWithFBGraphUser:(id <FBGraphUser>)graphuser;

@end
