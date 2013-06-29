//
//  UIButton+KiwiButtons.m
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIButton+WaxKit.h"

@implementation UIButton (WaxKit)

+(UIButton *)waxGreyButtonWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn styleAsWaxGreyButtonWithTitle:title];
    btn.frame = frame;
        
    return btn;
}
+(UIButton *)waxWhiteButtonWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn styleAsWaxWhiteButtonWithTitle:title];
    btn.frame = frame;
    
    return btn;
}
+(UIButton *)waxBlueButtonWithTitle:(NSString *)title frame:(CGRect)frame{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn styleAsWaxBlueButtonWithTitle:title];
    btn.frame = frame;
    
    return btn;
}
-(void)styleAsWaxGreyButtonWithTitle:(NSString *)title{
    [self setUpWaxButtonTitleStyleWithTitle:title color:nil];
    [self setBackgroundImage:[UIImage waxButtonImageNormalGrey] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedGrey] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedGrey] forState:UIControlStateDisabled];
}
-(void)styleAsWaxWhiteButtonWithTitle:(NSString *)title{
    [self setUpWaxButtonTitleStyleWithTitle:title color:[UIColor whiteColor]];
    [self setTitleColor:[UIColor waxHeaderFontColor] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage waxButtonImageNormalWhite] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedWhite] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedWhite] forState:UIControlStateDisabled];
}
-(void)styleAsWaxBlueButtonWithTitle:(NSString *)title{
    [self setUpWaxButtonTitleStyleWithTitle:title color:nil];
    [self setBackgroundImage:[UIImage waxButtonImageNormalBlue] forState:UIControlStateNormal];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedBlue] forState:UIControlStateHighlighted];
    [self setBackgroundImage:[UIImage waxButtonImageHighlightedBlue] forState:UIControlStateDisabled];
}

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



#pragma mark - Internal Methods
-(void)setUpWaxButtonTitleStyleWithTitle:(NSString *)title color:(UIColor *)color{
    [self setTitleForAllControlStates:title titleColor:color ? color : [UIColor waxHeaderFontColor] titleFont:[UIFont waxHeaderFont] titleTextAlignment:NSTextAlignmentCenter];
}

-(void)setTitleForAllControlStates:(NSString *)title titleColor:(UIColor *)color titleFont:(UIFont *)font titleTextAlignment:(NSTextAlignment)textAlignment{
    [self setTitleForAllControlStates:title];
    [self setTitleColorForAllControlStates:color];
    [self.titleLabel setTextAlignment:textAlignment];
    [self.titleLabel setFont:font]; 
}
@end
