//
//  VideoObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@interface VideoObject : ModelObject

#pragma mark - info about the user who created the video
@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSNumber *rank;
@property (nonatomic, copy) NSNumber *tagCount;

#pragma mark - info about the video itself
@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *shareID;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *tag;

@property (nonatomic, copy) NSNumber *votesCount;
@property (nonatomic, copy) NSNumber *viewCount;
@property (nonatomic, copy) NSString *caption;

#pragma mark - info about the current user's relationship to the video
@property (nonatomic, assign) BOOL didVote;

-(BOOL)isMine; 
-(NSString *)sharingString;

@end
