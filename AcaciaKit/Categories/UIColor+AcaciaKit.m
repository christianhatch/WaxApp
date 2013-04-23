//
//  UIColor+AcaciaKit.h
//  Wax
//
//  Created by Christian Michael Hatch on 6/21/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


#import "UIColor+AcaciaKit.h"
#import "KGNoise.h"

@implementation UIColor (AcaciaKit)


+(UIColor *)colorWithHex:(int)hex{
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0
                           green:((float)((hex & 0xFF00) >> 8))/255.0
                            blue:((float)(hex & 0xFF))/255.0 alpha:1.0];
}

+(UIColor *)coloredNoiseWithHex:(int)hex opacity:(CGFloat)opacity{
    return [[UIColor colorWithHex:hex] colorWithNoiseWithOpacity:opacity];
}
-(UIColor *)coloredNoiseWithOpacity:(CGFloat)opacity{
    return [self colorWithNoiseWithOpacity:opacity];
}

@end
