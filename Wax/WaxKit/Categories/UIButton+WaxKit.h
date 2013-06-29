//
//  UIButton+KiwiButtons.h
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WaxKit)

+(UIButton *)waxGreyButtonWithTitle:(NSString *)title frame:(CGRect)frame;
+(UIButton *)waxWhiteButtonWithTitle:(NSString *)title frame:(CGRect)frame;
+(UIButton *)waxBlueButtonWithTitle:(NSString *)title frame:(CGRect)frame;

-(void)styleAsWaxGreyButtonWithTitle:(NSString *)title;
-(void)styleAsWaxWhiteButtonWithTitle:(NSString *)title; 
-(void)styleAsWaxBlueButtonWithTitle:(NSString *)title;

-(void)styleFontAsWaxHeaderFontOfSize:(CGFloat)size color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor;

-(void)styleFontAsWaxHeaderItalics;


@end
