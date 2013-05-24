//
//  UIButton+KiwiButtons.h
//  Kiwi
//
//  Created by Christian Hatch on 11/12/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WaxKit)

+(UIButton *)whiteButtonWithTitle:(NSString *)title;
+(UIButton *)greenButtonWithTitle:(NSString *)title;

-(void)setImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated; 
-(void)setBackgroundImage:(UIImage *)image forState:(UIControlState)state animated:(BOOL)animated;

@end
