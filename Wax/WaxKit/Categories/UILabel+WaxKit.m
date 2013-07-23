//
//  UILabel+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 6/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "UILabel+WaxKit.h"

@implementation UILabel (WaxKit)


-(void)setWaxDefaultFont{
    [self setFont:[UIFont waxDefaultFont] andColor:[UIColor waxDefaultFontColor]];
}
-(void)setWaxDefaultFontOfSize:(CGFloat)size{
    [self setWaxDefaultFontOfSize:size color:[UIColor waxDefaultFontColor]]; 
}
-(void)setWaxDefaultFontOfSize:(CGFloat)size color:(UIColor *)color{
    [self setFont:[UIFont waxDefaultFontOfSize:size] andColor:color]; 
}


-(void)setWaxHeaderFont{
    [self setFont:[UIFont waxHeaderFont] andColor:[UIColor waxHeaderFontColor]]; 
}
-(void)setWaxHeaderFontOfSize:(CGFloat)size{
    [self setWaxHeaderFontOfSize:size color:[UIColor waxHeaderFontColor]];
}
-(void)setWaxHeaderFontOfSize:(CGFloat)size color:(UIColor *)color{
    [self setFont:[UIFont waxHeaderFontOfSize:size] andColor:color]; 
}

-(void)setWaxHeaderItalicsFont{
    [self setFont:[UIFont waxHeaderFontItalics] andColor:[UIColor waxRedColor]]; 
}
-(void)setWaxHeaderItalicsFontOfSize:(CGFloat)size{
    [self setWaxHeaderItalicsFontOfSize:size color:[UIColor waxRedColor]]; 
}
-(void)setWaxHeaderItalicsFontOfSize:(CGFloat)size color:(UIColor *)color{
    [self setFont:[UIFont waxHeaderFontItalicsOfSize:size] andColor:color]; 
}


-(void)setWaxDetailFont{
    [self setFont:[UIFont waxDetailFont] andColor:[UIColor waxDetailFontColor]]; 
}
-(void)setWaxDetailFontOfSize:(CGFloat)size{
    [self setWaxDetailFontOfSize:size color:[UIColor waxDetailFontColor]]; 
}
-(void)setWaxDetailFontOfSize:(CGFloat)size color:(UIColor *)color{
    [self setFont:[UIFont waxDetailFontOfSize:size] andColor:color];
}


#pragma mark - Internal Methods
-(void)setFont:(UIFont *)font andColor:(UIColor *)color{
    self.font = font;
    self.textColor = color; 
}


@end
