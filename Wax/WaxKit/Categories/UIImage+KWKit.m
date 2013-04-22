//
//  UIImage+KiwiImages.m
//  Kiwi
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIImage+KWKit.h"
#import "Import.h"
#import "CHKit.h"

@implementation UIImage (KWKit)


+(UIImage *)greenButton{
    return [UIImage stretchyImage:[UIImage imageNamed:@"button_green.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)greenButtonOn{
    return [UIImage stretchyImage:[UIImage imageNamed:@"button_greenOn.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)whiteButton{
    return [UIImage stretchyImage:[UIImage imageNamed:@"button.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)whiteButtonOn{
    return [UIImage stretchyImage:[UIImage imageNamed:@"button_on.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)oneCell{
    return [UIImage stretchyImage:[UIImage imageNamed:@"one_cell.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)twoCells{
    return [UIImage stretchyImage:[UIImage imageNamed:@"two_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)threeCells{
    return [UIImage stretchyImage:[UIImage imageNamed:@"three_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)fourCells{
    return [UIImage stretchyImage:[UIImage imageNamed:@"four_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)fiveCells{
    return [UIImage imageNamed:@"five_cells.png"];
//    return [UIImage stretchyImage:[UIImage imageNamed:@"five_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
}
+(UIImage *)selectionGradient{
    return [UIImage stretchyImage:[UIImage imageNamed:@"selectionGradient.png"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:YES];
}
+(UIImage *)splashImageForDevice{
    return [UIDevice isRetina4Inch] ? [UIImage imageNamed:@"Default-568h@2x.png"] : [UIImage imageNamed:@"Default.png"];
}
+(UIImage *)personErrorImage{
    return [UIImage imageNamed:@"nofollow.png"]; 
}
+(UIImage *)kiwiBirdErrorImage{
    return [UIImage imageNamed:@"nokiwi.png"];
}
+(UIImage *)profilePicturePlaceholder{
    return [UIImage imageNamed:@"noProfilePicture.png"]; 
}
+(UIImage *)logoBWPlaceholder{
    return [UIImage imageNamed:@"UIImageBGKiwiA1.png"]; 
}
+(UIImage *)cropImageWithRect:(CGRect)rect image:(UIImage *)image {
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, rect);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}
+(UIImage *)squareCropImage:(UIImage *)image{
    if (image.size.width == image.size.height) {
        return image;
    }
    
    CGRect croppity = CGRectZero;
    
    CGFloat dimensions = MIN(image.size.width, image.size.height);
    
    CGFloat y = ((image.size.height/2) - (image.size.width/2));
    CGFloat x = ((image.size.width/2) - (image.size.height/2));
    
    if (image.size.width > image.size.height) {
        croppity = CGRectMake(x, 0, dimensions, dimensions);
    }else{
        croppity = CGRectMake(0, y, dimensions, dimensions); 
    }

    return [UIImage cropImageWithRect:croppity image:image];
}

+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets{
    return [UIImage stretchyImage:image withCapInsets:edgeInsets useImageHeight:NO]; 
}
+(UIImage *)stretchyImage:(UIImage *)image withCapInsets:(UIEdgeInsets)edgeInsets useImageHeight:(BOOL)useHeight{
    if (IOS_6_OR_GREATER) {
//        return [image resizableImageWithCapInsets:useHeight ? edgeInsets : UIEdgeInsetsMake(image.size.height/2, edgeInsets.left, image.size.height/2, edgeInsets.right) resizingMode:UIImageResizingModeStretch];
        return [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    }else{
        return [image stretchableImageWithLeftCapWidth:edgeInsets.left topCapHeight:useHeight ? image.size.height : edgeInsets.top];
    }
}
//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}
//+(void)saveProfilePicture{
//    
//}
//+(UIImage *)loadProfilePicture{
//    
//}






@end
