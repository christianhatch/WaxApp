//
//  PersonObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@interface PersonObject : ModelObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;

@property (nonatomic, getter = isFollowing) BOOL following;

@property (nonatomic, copy) NSNumber *followersCount;
@property (nonatomic, copy) NSNumber *followingCount;
@property (nonatomic, copy) NSNumber *titlesCount;

//-(id)initWithFBGraphUser:(id <FBGraphUser>)graphuser;

-(BOOL)isMe; 

@end
