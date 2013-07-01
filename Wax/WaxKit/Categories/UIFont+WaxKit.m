//
//  UIFont+KiwiFonts.m
//  Kiwi
//
//  Created by Christian Hatch on 12/10/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIFont+WaxKit.h"

@implementation UIFont (WaxKit)

+(UIFont *)waxDefaultFont{
    return [UIFont waxDefaultFontOfSize:13];
}
+(UIFont *)waxDefaultFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue" size:size]; 
}


+(UIFont *)waxHeaderFont{
    return [UIFont waxHeaderFontOfSize:16];
}
+(UIFont *)waxHeaderFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:size];
}

+(UIFont *)waxHeaderFontItalics{
    return [UIFont waxHeaderFontItalicsOfSize:16]; 
}
+(UIFont *)waxHeaderFontItalicsOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-BoldItalic" size:size]; 
}


+(UIFont *)waxDetailFont{
    return [UIFont waxDetailFontOfSize:12];
}
+(UIFont *)waxDetailFontOfSize:(CGFloat)size{
    return [UIFont fontWithName:@"HelveticaNeue-Light" size:size];
}



@end
