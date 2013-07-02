//
//  UILabel+WaxKit.h
//  Wax
//
//  Created by Christian Hatch on 6/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WaxKit)

-(void)setWaxDefaultFont;
-(void)setWaxDefaultFontOfSize:(CGFloat)size;
-(void)setWaxDefaultFontOfSize:(CGFloat)size color:(UIColor *)color;

-(void)setWaxHeaderFont;
-(void)setWaxHeaderFontOfSize:(CGFloat)size;
-(void)setWaxHeaderFontOfSize:(CGFloat)size color:(UIColor *)color;

-(void)setWaxHeaderItalicsFont;
-(void)setWaxHeaderItalicsFontOfSize:(CGFloat)size;
-(void)setWaxHeaderItalicsFontOfSize:(CGFloat)size color:(UIColor *)color;

-(void)setWaxDetailFont;
-(void)setWaxDetailFontOfSize:(CGFloat)size;
-(void)setWaxDetailFontOfSize:(CGFloat)size color:(UIColor *)color;


@end
