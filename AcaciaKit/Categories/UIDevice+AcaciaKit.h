//
//  UIDevice+CHDeviceHardware.h
//  Kiwi
//
//  Created by Christian Hatch on 12/4/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

enum {
    iPhoneStandard          = 1,    // iPhone 1,3,3GS Standard Resolution   (320x480px)
    iPhoneRetina            = 2,    // iPhone 4,4S High Resolution          (640x960px)
    iPhoneRetina4           = 3,    // iPhone 5 High Resolution             (640x1136px)
    iPadStandard            = 4,    // iPad 1,2 Standard Resolution         (1024x768px)
    iPadRetina              = 5     // iPad 3 High Resolution               (2048x1536px)
}; typedef NSUInteger UIDeviceResolution;

@interface UIDevice (AcaciaKit)

+(CGFloat)currentModel;

+(UIDeviceResolution)currentResolution;
+(BOOL)isRetina4Inch; 

@end
