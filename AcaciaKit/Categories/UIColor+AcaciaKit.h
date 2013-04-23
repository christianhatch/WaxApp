//
//  KiwiColors.h
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/21/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface UIColor (AcaciaKit)


+(UIColor *)colorWithHex:(int)hex;
+(UIColor *)coloredNoiseWithHex:(int)hex opacity:(CGFloat)opacity;
-(UIColor *)coloredNoiseWithOpacity:(CGFloat)opacity;

@end
