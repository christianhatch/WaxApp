//
//  UIFont+KiwiFonts.h
//  Kiwi
//
//  Created by Christian Hatch on 12/10/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (WaxKit)

+(UIFont *)waxDefaultFont; //default size is 13
+(UIFont *)waxDefaultFontOfSize:(CGFloat)size; 

+(UIFont *)waxHeaderFont; //default size is 16
+(UIFont *)waxHeaderFontOfSize:(CGFloat)size;

+(UIFont *)waxHeaderFontItalics; //default size is 16
+(UIFont *)waxHeaderFontItalicsOfSize:(CGFloat)size;

+(UIFont *)waxDetailFont; //default size is 12
+(UIFont *)waxDetailFontOfSize:(CGFloat)size;


@end
