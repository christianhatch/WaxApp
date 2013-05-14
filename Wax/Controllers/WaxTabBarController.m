//
//  WaxTabBarController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTabBarController.h"
#import "SplashViewController.h"

@interface WaxTabBarController ()

@end

@implementation WaxTabBarController


- (void)viewDidLoad{
    [super viewDidLoad];
    self.tabBar.layer.masksToBounds = NO;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
    self.tabBar.layer.shadowOpacity = 0.5;
    self.tabBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tabBar.bounds].CGPath;
    self.delegate = self;
    [self setupTabBarIcons];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[WaxUser currentUser] isLoggedIn]) {
        [self showSplashScreen];
    }
}
-(void)setupTabBarIcons{
    /*
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"homeOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home.png"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"discoverOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"discover.png"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"profileOn.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"profile.png"]];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"capture.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"capture.png"]];
    [[UITabBar appearance] setSelectionIndicatorImage:[UIImage imageNamed:@"tabbar_selected.png"]];
    
    for (UITabBarItem *tabItem in self.tabBar.items) {
        tabItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
     */
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.title isEqualToString:@"Capture"]){
        [AIKLocationManager locationPermittedOrAsk];
        [self capture];
        return NO;
    }else{
        /*
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
         */
        return YES; 
    }
}
-(void)capture{
    [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:@"Tapped record on tabbar"];
//    VideoCaptureViewController *vcc = [[VideoCaptureViewController alloc] init];
//    [self presentViewController:vcc animated:YES completion:nil];
}
-(void)showSplashScreen{
    UINavigationController *nav = initViewControllerWithIdentifier(@"SplashNav");
    SplashViewController *splashVC = initViewControllerWithIdentifier(@"SplashVC");
    nav.viewControllers = @[splashVC];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

@end
