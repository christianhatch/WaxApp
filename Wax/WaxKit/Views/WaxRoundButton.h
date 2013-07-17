//
//  WaxRoundButton.h
//  Wax
//
//  Created by Christian Hatch on 6/27/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WaxRoundButton : UIButton

+(id)waxRoundButtonGrey;
+(id)waxRoundButtonBlue;
+(id)waxRoundButtonWhite; 

-(void)styleAsWaxRoundButtonGreyWithTitle:(NSString *)title;
-(void)styleAsWaxRoundButtonBlueWithTitle:(NSString *)title;
-(void)styleAsWaxRoundButtonWhiteWithTitle:(NSString *)title;

-(void)setBorderAndFillColor:(UIColor *)color forState:(UIControlState)state; 

-(void)setBorderColor:(UIColor *)color forState:(UIControlState)state;
-(void)setFillColor:(UIColor *)color forState:(UIControlState)state;

-(UIColor *)borderColorForControlState:(UIControlState)state;
-(UIColor *)fillColorForControlState:(UIControlState)state;

@end
