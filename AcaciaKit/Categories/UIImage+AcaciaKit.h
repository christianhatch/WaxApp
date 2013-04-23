//
//  UIImage+AcaciaKit.h
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AcaciaKit)

-(UIImage *)cropImageWithRect:(CGRect)rect;
-(UIImage *)squareCropImage;

+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets;
+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets useImageHeight:(BOOL)useHeight;


@end
