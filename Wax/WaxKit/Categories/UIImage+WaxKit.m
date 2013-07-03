//
//  UIImage+KiwiImages.m
//  Kiwi
//
//  Created by Christian Hatch on 11/11/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <AcaciaKit/AcaciaKit.h>

@implementation UIImage (WaxKit)


+(UIImage *)waxButtonImageNormalGrey{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonNormalGrey"]]; 
}
+(UIImage *)waxButtonImageHighlightedGrey{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonHighlightedGrey"]]; 
}


+(UIImage *)waxButtonImageHighlightedChartreuse{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonHighlightedChartreuse"]]; 
}
+(UIImage *)waxButtonImageHighlightedRed{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonHighlightedRed"]];
}



+(UIImage *)waxButtonImageNormalWhite{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonNormalWhite"]];

}
+(UIImage *)waxButtonImageHighlightedWhite{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonHighlightedWhite"]];

}


+(UIImage *)waxButtonImageNormalBlue{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonNormalBlue"]];
}
+(UIImage *)waxButtonImageHighlightedBlue{
    return [UIImage waxButtonImageStretchyFromImage:[UIImage imageNamed:@"waxButtonHighlightedBlue"]];
}





#pragma mark - Internal Methods
+(UIImage *)waxButtonImageStretchyFromImage:(UIImage *)image{
    CGFloat sides = ((image.size.width - 1) / 2); 
    UIEdgeInsets insets = UIEdgeInsetsMake(0, sides, 0, sides); 
    return [UIImage stretchyImage:image withCapInsets:insets useImageHeight:NO];
}


@end
