//
//  UIView+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AcaciaKit)

-(void)fadeIn;
-(void)fadeOut;
-(void)fadeOutandRemoveFromSuperview;

-(void)rotateByDegrees:(CGFloat)degrees duration:(CGFloat)duration;

-(void)dropShadowWithOpacity:(float)opacity;


+(UIView *)sectionHeaderWithTitle:(NSString *)title width:(CGFloat)width; 

@end
