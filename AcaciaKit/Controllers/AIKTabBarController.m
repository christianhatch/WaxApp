//
//  KWTabBarController.m
//  Kiwi
//
//  Created by Christian Michael Hatch on 7/24/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKTabBarController.h"
#import "AIKLocationManager.h"

#define VIEW_HEIGHT_FULLSCREEN ([[UIApplication sharedApplication] keyWindow].frame.size.height - 20)
#define VIEW_HEIGHT_WITH_TABBAR (([[UIApplication sharedApplication] keyWindow].frame.size.height - 20) - self.tabBar.frame.size.height)

@interface AIKTabBarController ()


@end

@implementation AIKTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tabBar.layer.masksToBounds = NO;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tabBar.bounds].CGPath;
    self.delegate = self;
    [self setupTabBarIcons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showHideTabbarWithAnimationType:) name:KWShowHideTabbarNotification object:nil];
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@"CaptureNil"]){
        [AIKLocationManager locationPermittedOrAsk]; 
        [self capture]; 
        return NO;
    }else{
        UINavigationController *nav = (UINavigationController *)self.selectedViewController;
        if (viewController == self.selectedViewController && nav.visibleViewController == [nav.viewControllers objectAtIndex:0]) {
            for (UIView *view in nav.visibleViewController.view.subviews) {
                if ([view isKindOfClass:[UIScrollView class]] && [view respondsToSelector:@selector(setContentOffset:animated:)]) {
                    UIScrollView *scroller = (UIScrollView *)view;
                    [scroller setContentOffset:CGPointMake(0, 0) animated:YES];
                }
            }
            return NO;
        }else{
            return YES; 
        }
    }
}
-(void)capture{
    //   [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"Tapped record on tabbar"];
    //  VideoCaptureViewController *vcc = [[VideoCaptureViewController alloc] init];
    // [self presentViewController:vcc animated:YES completion:nil];
}
-(void)setupTabBarIcons{
    /* 
     old images 
     
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"homeTab_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeTab.png"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"peopleTab_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"peopleTab.png"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"meTab_on.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"meTab.png"]];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"captureTab.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"captureTab.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selectedNEW.png"]];
    */
        
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"homeOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"discoverOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"discover.png"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"profileOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"profile.png"]];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"capture.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"capture.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
    
    for (UITabBarItem *tabItem in self.tabBar.items) {
        tabItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
}
-(void)showHideTabbarWithAnimationType:(NSNotification *)note{
    NSNumber *typeNumber = [note.userInfo objectForKeyNotNull:CHTabbarAnimationTypeKey];
    CHTabbarAnimationType type = typeNumber.intValue;
    
    switch (type) {
//        case CHTabbarAnimationTypeNone:{
//            
//        }break;
        case CHTabbarAnimationTypeSlideDown:{
            [self slideTabbarDown];
        }break;
        case CHTabbarAnimationTypeSlideUpFromBottom:{
            [self slideTabbarUp]; 
        }break;
//        case CHTabbarAnimationTypePushOffofView:{
//            [self pushTabbarOffofView];
//        }break;
//        case CHTabbarAnimationTypePushOntoView:{
//            [self pushTabbarOntoView]; 
//        }break;
//        case CHTabbarAnimationTypePopOffofView:{
//            [self popTabbarOffofView]; 
//        }break;
//        case CHTabbarAnimationTypePopOntoView:{
//            [self popTabbarOntoView]; 
//        }break;
    }
}

#pragma mark - Show/Hide Tabbar Convenience Methods
-(void)slideTabbarDown{
    //slides down below screen, enlarging current view to take its place
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y += tabFrame.size.height; 
    
    CGRect viewFrame = [[self.view.subviews objectAtIndexNotNull:0] frame];
    viewFrame.size.height = VIEW_HEIGHT_FULLSCREEN;

    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [[self.view.subviews objectAtIndex:0] setFrame:viewFrame];
        self.tabBar.frame = tabFrame;
    } completion:^(BOOL finished) {
    }];
}
-(void)slideTabbarUp{
    //slides up to normal position, shortening current view to compensate for the space now occupied by the tabbar
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.origin.y = VIEW_HEIGHT_FULLSCREEN - self.tabBar.frame.size.height;

    CGRect viewFrame = [[self.view.subviews objectAtIndexNotNull:0] frame];
    viewFrame.size.height = VIEW_HEIGHT_WITH_TABBAR;

    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        [[self.view.subviews objectAtIndex:0] setFrame:viewFrame];
        self.tabBar.frame = tabFrame;
    } completion:^(BOOL finished) {
    }];
}
-(void)setTabbarFrameCenter{
    CGRect resetFrame = self.tabBar.frame;
    resetFrame.origin.x = 0;
    self.tabBar.frame = resetFrame;
    //    DLog(@"tabbar center frame %@", NSStringFromCGRect(self.tabBar.frame));
}
-(void)setViewHeightFullScreen{
    CGRect viewFrame = [[self.view.subviews objectAtIndexNotNull:0] frame];
    viewFrame.size.height = VIEW_HEIGHT_FULLSCREEN;
    [[self.view.subviews objectAtIndex:0] setFrame:viewFrame];
}
-(void)setViewHeightWithTabbar{
    CGRect viewFrame = [[self.view.subviews objectAtIndexNotNull:0] frame];
    viewFrame.size.height = VIEW_HEIGHT_WITH_TABBAR;
    [[self.view.subviews objectAtIndex:0] setFrame:viewFrame];
}

/*
-(void)pushTabbarOntoView{
    //we are pushing from a view without a tabbar to a view with a tabbar
    //we want the tabbar to slide from OFF SCREEN RIGHT onto screen
    
    [self setTabbarFrameOffRight];
    
    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.slidingVC.view.backgroundColor = [UIColor whiteColor];
        [self setTabbarFrameCenter];
        [self setViewHeightWithTabbar];
    } completion:^(BOOL finished) {
        self.slidingVC.view.backgroundColor = [UIColor clearColor];
    }];
}
-(void)pushTabbarOffofView{
    //pushes tabbar to the LEFT, off screen
    //looks like new view has been pushed normally, but without a tabbar
    //starts on screen normally, moves to off screen left
    
    [self setTabbarFrameCenter];
    
    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.slidingVC.view.backgroundColor = [UIColor whiteColor];
        [self setTabbarFrameOffLeft];
        [self setViewHeightFullScreen];
    } completion:^(BOOL finished) {
        self.slidingVC.view.backgroundColor = [UIColor clearColor];
    }];
}
-(void)popTabbarOntoView{
    //slides tabbar from the off screen LEFT TO THE RIGHT onto the screen
    //works for when a view is popping and wants to show the tabbar again
    //starts off screen left, moves to on screen normally
    
    [self setTabbarFrameOffLeft];
    
    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.slidingVC.view.backgroundColor = [UIColor whiteColor];
        [self setTabbarFrameCenter];
        [self setViewHeightWithTabbar];
    } completion:^(BOOL finished) {
        self.slidingVC.view.backgroundColor = [UIColor clearColor];
    }];
}
-(void)popTabbarOffofView{
    //we are popping a view with a tabbar to a view without a tabbar
    //we want it to start in the normal position, and slide to the RIGHT, off screen
    //starts in normal position, slides off screen RIGHT
    
    [self setTabbarFrameCenter];
    
    [UIView animateWithDuration:KWAnimationDuration delay:0 options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionTransitionCrossDissolve) animations:^{
        self.slidingVC.view.backgroundColor = [UIColor whiteColor];
        [self setTabbarFrameOffRight];
        [self setViewHeightFullScreen];
    } completion:^(BOOL finished) {
        self.slidingVC.view.backgroundColor = [UIColor clearColor];
    }];
}
-(void)setTabbarFrameOffRight{
    CGRect resetFrame = self.tabBar.frame;
    resetFrame.origin.x = resetFrame.size.width;
    self.tabBar.frame = resetFrame;
//    DLog(@"tabbar off right frame %@", NSStringFromCGRect(self.tabBar.frame));
}
-(void)setTabbarFrameOffLeft{
    CGRect resetFrame = self.tabBar.frame;
    resetFrame.origin.x = -resetFrame.size.width;
    self.tabBar.frame = resetFrame;
//    DLog(@"tabbar off left frame %@", NSStringFromCGRect(self.tabBar.frame));
}
*/
-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}


@end
