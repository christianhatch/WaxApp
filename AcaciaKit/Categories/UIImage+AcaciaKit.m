//
//  UIImage+AcaciaKit.m
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "UIImage+AcaciaKit.h"

@implementation UIImage (AcaciaKit)

-(UIImage *)cropImageWithRect:(CGRect)rect{
    // CGImageCreateWithImageInRect's `rect` parameter is in pixels of the image's coordinates system. Convert from points.
	CGFloat scale = self.scale;
	rect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
	
	CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
	UIImage *cropped = [UIImage imageWithCGImage:imageRef scale:scale orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return cropped;
}
-(UIImage *)squareCropImage{
    CGSize imageSize = self.size;
	CGFloat shortestSide = fminf(imageSize.width, imageSize.height);
	return [self cropImageWithRect:CGRectMake(0.0f, 0.0f, shortestSide, shortestSide)];
}

+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets{
    return [UIImage stretchyImage:image withCapInsets:edgeInsets useImageHeight:NO];
}
+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets useImageHeight:(BOOL)useHeight{
    return [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
}

@end
