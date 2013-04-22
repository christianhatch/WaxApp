//
//  UIButton+KiwiButtons.m
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIButton+KWKit.h"
#import "UIImage+KWKit.h"
#import "Constants.h"
#import "UIFont+KWKit.h"

@implementation UIButton (KWKit)

+(UIButton *)whiteButtonWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage whiteButton] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage whiteButtonOn] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont kiwiLightOfSize:14]];
    [btn.titleLabel setTextAlignment:UITextAlignmentCenter];
    return btn;
}
+(UIButton *)greenButtonWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
    [btn setBackgroundImage:[UIImage greenButton] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage greenButtonOn] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont kiwiLightOfSize:14]];
    [btn.titleLabel setTextAlignment:UITextAlignmentCenter];
    return btn;
}

@end
