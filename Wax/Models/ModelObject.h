//
//  ModelObject.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kinfiniteScrollingIDKey = @"infinitescrollingid"

#import <Foundation/Foundation.h>

@interface ModelObject : NSObject <NSCoding>

-(id)initWithDictionary:(NSDictionary *)dictionary;

-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;


@property (nonatomic, strong) NSNumber *infiniteScrollingID;


@end
