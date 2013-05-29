//
//  UIButton+KiwiButtons.m
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIButton+WaxKit.h"
#import "UIFont+WaxKit.h"

@implementation UIButton (WaxKit)

+(UIButton *)whiteButtonWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage whiteButton] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage whiteButtonOn] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont waxLightOfSize:14]];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    return btn;
}
+(UIButton *)greenButtonWithTitle:(NSString *)title{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateHighlighted];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkTextColor] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage greenButton] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage greenButtonOn] forState:UIControlStateHighlighted];
    [btn.titleLabel setFont:[UIFont waxLightOfSize:14]];
    [btn.titleLabel setTextAlignment:NSTextAlignmentCenter];
    return btn;
}
-(void)setImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated{
    if (animated) {
        [UIView transitionWithView:self.imageView duration:AIKDefaultAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setImage:image forState:state];
        } completion:nil];
    }
}
-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated{
    if (animated) {
        [UIView transitionWithView:self.imageView duration:AIKDefaultAnimationDuration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setBackgroundImage:image forState:state];
        } completion:nil];
    }
}

@end
