//
//  UIImage+KiwiImages.m
//  Kiwi
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <AcaciaKit/AcaciaKit.h>

@implementation UIImage (WaxKit)


//+(UIImage *)greenButton{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"button_green.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)greenButtonOn{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"button_greenOn.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)whiteButton{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"button.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)whiteButtonOn{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"button_on.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)oneCell{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"one_cell.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)twoCells{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"two_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)threeCells{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"three_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)fourCells{
//    return [UIImage stretchyImage:[UIImage imageNamed:@"four_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
//+(UIImage *)fiveCells{
//    return [UIImage imageNamed:@"five_cells.png"];
//    return [UIImage stretchyImage:[UIImage imageNamed:@"five_cells.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:YES];
//}
+(UIImage *)selectionGradient{
    return [UIImage stretchyImage:[UIImage imageNamed:@"selectionGradient.png"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:YES];
}
+(UIImage *)splashImageForDevice{
    return [UIDevice isRetina4Inch] ? [UIImage imageNamed:@"Default-568h@2x.png"] : [UIImage imageNamed:@"Default.png"];
}
//+(UIImage *)personErrorImage{
//    return [UIImage imageNamed:@"nofollow.png"]; 
//}
//+(UIImage *)kiwiBirdErrorImage{
//    return [UIImage imageNamed:@"nokiwi.png"];
//}
+(UIImage *)profilePicturePlaceholder{
    return [UIImage imageNamed:@"noProfilePicture.png"]; 
}
//+(UIImage *)logoBWPlaceholder{
//    return [UIImage imageNamed:@"UIImageBGKiwiA1.png"]; 
//}

//+ (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize {
//    //UIGraphicsBeginImageContext(newSize);
//    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
//    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


@end
