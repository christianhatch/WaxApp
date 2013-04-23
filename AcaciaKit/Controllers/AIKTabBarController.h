//
//  KWTabBarController.h
//  Kiwi
//
//  Created by Christian Michael Hatch on 7/24/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

#define KWShowHideTabbarNotification    @"KWTabbarControllerHideTabbar"
#define CHTabbarAnimationTypeKey        @"animationType"

enum{
    CHTabbarAnimationTypeSlideUpFromBottom = 1,
    CHTabbarAnimationTypeSlideDown,
    CHTabbarAnimationTypePushOntoView,
    CHTabbarAnimationTypePushOffofView,
    CHTabbarAnimationTypePopOntoView,
    CHTabbarAnimationTypePopOffofView,
//    CHTabbarAnimationTypeNone = 100, 
};
typedef NSInteger CHTabbarAnimationType;


@interface AIKTabBarController : UITabBarController <UITabBarControllerDelegate, UINavigationControllerDelegate>



@end

