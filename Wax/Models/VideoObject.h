//
//  VideoObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@interface VideoObject : ModelObject

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSNumber *commentCount;
@property (nonatomic, copy) NSNumber *likeCount;
@property (nonatomic, copy) NSNumber *viewCount;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *caption;

@property (nonatomic, copy) NSString *userid;
@property (nonatomic, copy) NSString *vidId;
@property (nonatomic, copy) NSString *videoLink;
@property (nonatomic, copy) NSString *shareId;
@property (nonatomic, copy) NSNumber *serverTimeStamp;
@property (nonatomic, copy) NSNumber *trendCount;
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSNumber *likeStamp;

@property (nonatomic, assign) BOOL isFollowing;
@property (nonatomic, assign) BOOL didLike;
@property (nonatomic, assign) BOOL noSharing;


@end
