//
//  TagObject.m
//  Wax
//
//  Created by Christian Hatch on 6/21/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "TagObject.h"

@implementation TagObject
@synthesize tag = _tag, totalCount = _totalCount, infiniteScrollingID = _infiniteScrollingID;

-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        
        self.tag = [dictionary objectForKey:@"tag" orDefaultValue:NSLocalizedString(@"a tag", @"a tag")];
        self.totalCount = [dictionary objectForKey:@"total" orDefaultValue:@0];
        self.infiniteScrollingID = [dictionary objectForKey:@"count" orDefaultValue:nil];
        
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"TagObject Description: Tag=%@ TotalCount=%@ InfiniteScrollingID=%@", self.tag, self.totalCount, self.infiniteScrollingID];
    return descrippy;
}

@end
