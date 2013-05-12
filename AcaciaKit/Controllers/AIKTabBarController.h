//
//  KWTabBarController.h
//  Kiwi
//
//  Created by Christian Michael Hatch on 7/24/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const AIKTabbarShowHideNotification;
extern NSString *const AIKTabbarAnimationTypeKey;

enum{
    AIKTabbarAnimationTypeSlideUpFromBottom = 1,
    AIKTabbarAnimationTypeSlideDown,
    AIKTabbarAnimationTypePushOntoView,
    AIKTabbarAnimationTypePushOffofView,
    AIKTabbarAnimationTypePopOntoView,
    AIKTabbarAnimationTypePopOffofView,
//    CHTabbarAnimationTypeNone = 100, 
};
typedef NSInteger AIKTabbarAnimationType;


@interface AIKTabBarController : UITabBarController <UITabBarControllerDelegate, UINavigationControllerDelegate>



@end

