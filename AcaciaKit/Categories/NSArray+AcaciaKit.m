//
//  NSArray+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSArray+AcaciaKit.h"

@implementation NSArray (AcaciaKit)

-(id)objectAtIndexNotNull:(int)index {
    if (self.count > 0) {
        if (index <= self.count - 1) {
            if ([self objectAtIndex:index] == [NSNull null]){
                return nil;
            }else{
                return [self objectAtIndex:index];
            }
        }else{
            return nil;
//            CLSLog(@"Object at index not null was asked for an object beyond bounds of array");
        }
    }else{
        return nil;
//        CLSLog(@"Object at index not null was given an empty array");
    }
}
- (id)firstObject{
    return [self objectAtIndexNotNull:0]; 
}
-(BOOL)isEmptyOrNull{
    if (self.count == 0 || [self isKindOfClass:[NSNull class]])
        return YES;
    else
        return NO;
}
-(BOOL)countIsNOTDivisibleBy10{
    return (self.count % 10) != 0; 
}
+(NSArray *)kiwiLoadingAnimationImages{
    return @[[UIImage imageNamed:@"UIImageBGKiwiA1.png"], [UIImage imageNamed:@"UIImageBGKiwiA2.png"], [UIImage imageNamed:@"UIImageBGKiwiA3.png"], [UIImage imageNamed:@"UIImageBGKiwiA4.png"],  [UIImage imageNamed:@"UIImageBGKiwiA5.png"], [UIImage imageNamed:@"UIImageBGKiwiA6.png"],  [UIImage imageNamed:@"UIImageBGKiwiA7.png"], [UIImage imageNamed:@"UIImageBGKiwiA7.5.png"], [UIImage imageNamed:@"UIImageBGKiwiA8.png"], [UIImage imageNamed:@"UIImageBGKiwiA9.png"], [UIImage imageNamed:@"UIImageBGKiwiA10.png"],  [UIImage imageNamed:@"UIImageBGKiwiA11.png"], [UIImage imageNamed:@"UIImageBGKiwiA12.png"],  [UIImage imageNamed:@"UIImageBGKiwiA13.png"], [UIImage imageNamed:@"UIImageBGKiwiA14.png"],  [UIImage imageNamed:@"UIImageBGKiwiA15.png"],  [UIImage imageNamed:@"UIImageBGKiwiA16.png"], [UIImage imageNamed:@"UIImageBGKiwiA17.png"]]; 
}
+(NSArray *)alphabet{
    return @[@"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"];
}
@end
