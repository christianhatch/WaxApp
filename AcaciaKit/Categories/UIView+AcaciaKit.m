//
//  UIView+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIView+AcaciaKit.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+WaxKit.h"

@implementation UIView (AcaciaKit)

-(void)fadeIn{
    if (self.hidden || self.alpha < 1) {
        [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            self.alpha = 1;
        } completion:^(BOOL finished) {
            self.hidden = NO;
        }];
    }
}
-(void)fadeOut{
    if (!self.hidden || self.alpha > 0) {
        [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            self.hidden = YES;
        }];
    }
}
-(void)fadeOutandRemoveFromSuperview{
    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}
-(void)rotateByDegrees:(CGFloat)degrees duration:(CGFloat)duration{
    [UIView animateWithDuration:duration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.transform = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    } completion:nil];
}
- (void) dropShadowWithOpacity:(float)opacity {
    self.layer.masksToBounds = NO;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = opacity;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}
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
