//
//  UIImage+KiwiImages.h
//  Kiwi
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KWKit)

+(UIImage *)greenButton;
+(UIImage *)greenButtonOn;
+(UIImage *)whiteButton;
+(UIImage *)whiteButtonOn;
+(UIImage *)oneCell;
+(UIImage *)twoCells;
+(UIImage *)threeCells;
+(UIImage *)fourCells;
+(UIImage *)fiveCells;
+(UIImage *)selectionGradient;
+(UIImage *)splashImageForDevice;
+(UIImage *)personErrorImage;
+(UIImage *)kiwiBirdErrorImage;
+(UIImage *)profilePicturePlaceholder;
+(UIImage *)logoBWPlaceholder;
+(UIImage *)cropImageWithRect:(CGRect)rect image:(UIImage *)image;
+(UIImage *)squareCropImage:(UIImage *)image;


+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets;
+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets useImageHeight:(BOOL)useHeight; 


@end