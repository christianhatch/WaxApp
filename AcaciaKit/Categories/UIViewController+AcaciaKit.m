//
//  UIViewController+Swipe.m
//  Kiwi
//
//  Created by Christian Hatch on 9/3/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "UIViewController+AcaciaKit.h"

@implementation UIViewController (AcaciaKit)

-(void)addSwipeToPopVC{
    UISwipeGestureRecognizer *swiper = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(popper:)];
    swiper.direction = UISwipeGestureRecognizerDirectionRight;
    swiper.cancelsTouchesInView = NO;
    swiper.delaysTouchesBegan = NO;
    swiper.delaysTouchesEnded = NO;
    swiper.delegate = self; 
    [self.view addGestureRecognizer:swiper];
}
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return NO; 
}
-(void)popper:(UISwipeGestureRecognizer *)swiper{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
