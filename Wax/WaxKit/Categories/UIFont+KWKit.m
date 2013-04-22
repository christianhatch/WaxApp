//
//  UIFont+KiwiFonts.m
//  Kiwi
//
//  Created by Christian Hatch on 12/10/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIFont+KWKit.h"


@implementation UIFont (KWKit)

+(UIFont *)kiwiRegularOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue" size:size]; 
}
+(UIFont *)kiwiLightOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+(UIFont *)kiwiBoldOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
