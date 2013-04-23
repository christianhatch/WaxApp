//
//  UIDevice+CHDeviceHardware.m
//  Kiwi
//
//  Created by Christian Hatch on 12/4/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIDevice+AcaciaKit.h"
#include <sys/types.h>
#include <sys/sysctl.h>


@implementation UIDevice (AcaciaKit)

+(CGFloat)currentModel{
    NSString *platform = [UIDevice platform];
    if ([platform isEqualToString:@"iPhone1,1"])    return 1.0; //@"iPhone 1G"
    if ([platform isEqualToString:@"iPhone1,2"])    return 2.0; //@"iPhone 3G"
    if ([platform isEqualToString:@"iPhone2,1"])    return 2.1; //@"iPhone 3GS"
    
    if ([platform isEqualToString:@"iPhone3,1"])    return 4.0; //@"iPhone 4"
    if ([platform isEqualToString:@"iPhone3,3"])    return 4.0; //@"Verizon iPhone 4"
    if ([platform isEqualToString:@"iPhone4,1"])    return 4.1; //@"iPhone 4S"
    
    if ([platform isEqualToString:@"iPod1,1"])      return 1.1; //@"iPod Touch 1G"
    if ([platform isEqualToString:@"iPod2,1"])      return 1.1; //@"iPod Touch 2G"
    if ([platform isEqualToString:@"iPod3,1"])      return 4.1; //@"iPod Touch 3G"
    if ([platform isEqualToString:@"iPod4,1"])      return 4.1; //@"iPod Touch 4G"
    
    if ([platform isEqualToString:@"iPad1,1"])      return 1.1; //@"iPad"
    if ([platform isEqualToString:@"iPad2,1"])      return 4.1; //@"iPad 2 (WiFi)"
    if ([platform isEqualToString:@"iPad2,2"])      return 4.1; //@"iPad 2 (GSM)"
    if ([platform isEqualToString:@"iPad2,3"])      return 4.1; //@"iPad 2 (CDMA)"
    if ([platform isEqualToString:@"iPad3,1"])      return 4.1; //@"iPad-3G (WiFi)"
    if ([platform isEqualToString:@"iPad3,2"])      return 4.1; //@"iPad-3G (4G)"
    if ([platform isEqualToString:@"iPad3,3"])      return 4.1; //@"iPad-3G (4G)"
    
    if ([platform isEqualToString:@"i386"])         return 0.1; //@"Simulator"
    if ([platform isEqualToString:@"x86_64"])       return 0.1; //@"Simulator"
    
    return 0.0;
}
+(NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    return platform;
}
+(UIDeviceResolution) currentResolution {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if ([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) {
            CGSize result = [[UIScreen mainScreen] bounds].size;
            result = CGSizeMake(result.width * [UIScreen mainScreen].scale, result.height * [UIScreen mainScreen].scale);
            if (result.height == 480) return iPhoneStandard;
            return (result.height == 960 ? iPhoneRetina : iPhoneRetina4);
        } else
            return iPhoneStandard;
    } else
        return (([[UIScreen mainScreen] respondsToSelector: @selector(scale)]) ? iPadStandard : iPadRetina);
}
+(BOOL)isRetina4Inch{
    return [UIDevice currentResolution] == iPhoneRetina4; 
}

@end
