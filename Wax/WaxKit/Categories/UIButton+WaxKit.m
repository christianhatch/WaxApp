//
//  UIButton+KiwiButtons.m
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIButton+WaxKit.h"

@implementation UIButton (WaxKit)


-(void)styleFontAsWaxHeaderFontOfSize:(CGFloat)size color:(UIColor *)color highlightedColor:(UIColor *)highlightedColor{
    [self.titleLabel setWaxHeaderFontOfSize:size];
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:highlightedColor forState:UIControlStateHighlighted];
}

-(void)styleFontAsWaxHeaderItalics{
    [self.titleLabel setWaxHeaderItalicsFont];
    [self setTitleColor:[UIColor waxRedColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor waxHeaderFontColor] forState:UIControlStateHighlighted];
}



@end
