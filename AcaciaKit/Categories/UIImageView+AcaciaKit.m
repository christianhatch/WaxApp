//
//  UIImageView+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 2/10/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIImageView+AcaciaKit.h"
#import "UIImageView+AFNetworking.h"

#define kDefaultDuration    0.2

@implementation UIImageView (AcaciaKit)


- (void)setImageWithURL:(NSURL *)url andPlaceholderAnimation:(BOOL)placeholderAnimation{
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    if (placeholderAnimation) {
        [self setAnimationImages:@[[UIImage imageNamed:@"UIImageBGKiwiA1.png"], [UIImage imageNamed:@"UIImageBGKiwiA2.png"], [UIImage imageNamed:@"UIImageBGKiwiA3.png"], [UIImage imageNamed:@"UIImageBGKiwiA4.png"],  [UIImage imageNamed:@"UIImageBGKiwiA5.png"], [UIImage imageNamed:@"UIImageBGKiwiA6.png"],  [UIImage imageNamed:@"UIImageBGKiwiA7.png"], [UIImage imageNamed:@"UIImageBGKiwiA7.5.png"], [UIImage imageNamed:@"UIImageBGKiwiA8.png"], [UIImage imageNamed:@"UIImageBGKiwiA9.png"], [UIImage imageNamed:@"UIImageBGKiwiA10.png"],  [UIImage imageNamed:@"UIImageBGKiwiA11.png"], [UIImage imageNamed:@"UIImageBGKiwiA12.png"],  [UIImage imageNamed:@"UIImageBGKiwiA13.png"], [UIImage imageNamed:@"UIImageBGKiwiA14.png"],  [UIImage imageNamed:@"UIImageBGKiwiA15.png"],  [UIImage imageNamed:@"UIImageBGKiwiA16.png"], [UIImage imageNamed:@"UIImageBGKiwiA17.png"]]];
        [self setAnimationDuration:.5];
        [self startAnimating];
    }
    [self setImageWithURLRequest:request placeholderImage:nil success:nil failure:nil];
}
-(void)setImage:(UIImage *)image animated:(BOOL)animated duration:(CGFloat)duration{
    if (animated) {
        [UIView transitionWithView:self duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self stopAnimating];
            self.image = image;
        } completion:nil];
    }else{
        [self stopAnimating];
        [self setImage:image];
    }

}
-(void)setImage:(UIImage *)image animated:(BOOL)animated{
    [self setImage:image animated:animated duration:kDefaultDuration];
}


@end
