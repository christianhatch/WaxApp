//
//  UIFont+KiwiFonts.m
//  Kiwi
//
//  Created by Christian Hatch on 12/10/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIFont+WaxKit.h"

@implementation UIFont (WaxKit)

+(UIFont *)waxRegularOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue" size:size]; 
}
+(UIFont *)waxLightOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}
+(UIFont *)waxBoldOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

@end
