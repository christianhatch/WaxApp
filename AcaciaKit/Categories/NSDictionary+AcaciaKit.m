//
//  NSDictionary+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSDictionary+AcaciaKit.h"

@implementation NSDictionary (AcaciaKit)

- (id)objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    if (object == [NSNull null])
        return nil;
    return object;
}
-(BOOL)isEmptyOrNull{
    if (self.count == 0 || [self isKindOfClass:[NSNull class]])
        return YES;
    else
        return NO;
}

@end
