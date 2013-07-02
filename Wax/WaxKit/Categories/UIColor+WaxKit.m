//
//  UIColor+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 6/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "UIColor+WaxKit.h"


@implementation UIColor (WaxKit)

+(UIColor *)waxDefaultFontColor{
    return [UIColor colorWithHex:0x31373A]; 
}
+(UIColor *)waxHeaderFontColor{
    return [UIColor colorWithHex:0x31373A]; 
}
+(UIColor *)waxDetailFontColor{
    return [UIColor colorWithHex:0xA5B1B7]; 
}

+(UIColor *)waxRedColor{
    return [UIColor colorWithHex:0xF5372D]; 
}

+(UIColor *)waxTableViewCellSelectionColor{
    return [UIColor colorWithHex:0xE4F0F4]; 
}

@end
