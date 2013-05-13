//
//  UIView+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "UIView+WaxKit.h"


@implementation UIView (WaxKit)

+(UIView *)sectionHeaderWithTitle:(NSString *)title width:(CGFloat)width{ //height:(CGFloat)height{
    UILabel *header = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 23)];
    header.textColor = [UIColor darkTextColor];
    header.text = [NSString stringWithFormat:@" %@", title];
    header.font = [UIFont waxRegularOfSize:15];
    //    header.backgroundColor = [UIColor feedTableBGNoiseColor];
    //    header.backgroundColor = [UIColor coloredNoiseWithHex:0x393A3A opacity:0.05];
    header.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    UIView *top = [[UIView alloc] initWithFrame:CGRectMake(header.bounds.origin.x, header.bounds.origin.y, header.bounds.size.width, 1)];
    //    top.backgroundColor = [UIColor colorWithHex:0x5D5C5C];
    top.backgroundColor = [UIColor colorWithHex:0xFAFAFA];
    top.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [header addSubview:top];
    
    UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(header.bounds.origin.x, header.bounds.size.height - 1, header.bounds.size.width, 1)];
    //    bottom.backgroundColor = [UIColor colorWithHex:0x1C1D1D];
    bottom.backgroundColor = [UIColor colorWithHex:0xD8D8D8];
    bottom.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [header addSubview:bottom];
    
    return header;
}


@end
