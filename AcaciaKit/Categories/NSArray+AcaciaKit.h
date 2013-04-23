//
//  NSArray+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (AcaciaKit)

- (id)objectAtIndexNotNull:(int)index;
- (id)firstObject;
-(BOOL)isEmptyOrNull;

-(BOOL)countIsNOTDivisibleBy10;

+(NSArray *)kiwiLoadingAnimationImages;
+(NSArray *)alphabet;

@end
