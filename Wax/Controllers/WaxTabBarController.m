//
//  WaxTabBarController.m
//  Wax
//
//  Created by Christian Hatch on 5/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTabBarController.h"
#import "SplashViewController.h"
#import "ProfileViewController.h"
#import "VideoCameraViewController.h"

@interface WaxTabBarController ()

@end


@implementation WaxTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
//    self.tabBar.layer.masksToBounds = NO;
//    self.tabBar.layer.shadowOffset = CGSizeMake(0, 0);
//    self.tabBar.layer.shadowOpacity = 0.5;
//    self.tabBar.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.tabBar.bounds].CGPath;
    self.delegate = self;
    [self setupTabBarIcons];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSplashScreen) name:WaxUserDidLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(capture) name:kWaxNotificationPresentVideoCamera object:nil];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (![[WaxUser currentUser] isLoggedIn]) {
        [self showSplashScreen];
    }else{
        [[WaxDataManager sharedManager] updateNotificationCountWithCompletion:^(NSError *error) {
            if (!error) {
                [self updateNoteCountBadge];
            }
        }];
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
        [AIKLocationManager getAuthorizationStatusOrAskIfUndetermined];
        [self captureFromTabBar];
        return NO;
    }else if ([viewController.title isEqualToString:@"Me"]){
        UINavigationController *nav = (UINavigationController *)viewController;
        if ([[nav.viewControllers objectAtIndexOrNil:0] isKindOfClass:[ProfileViewController class]]) {
            ProfileViewController *profile = [nav.viewControllers objectAtIndexOrNil:0];
            profile.person = [[WaxUser currentUser] personObject];
        }
        return YES;
    }else if([viewController.title isEqualToString:@"Notifications"]){
        [self eraseNoteCountBadge];
        return YES; 
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
-(void)captureFromTabBar{
    [AIKErrorManager logMessageToAllServices:@"Tapped Record On TabBar"];
    [self capture]; 
}
-(void)capture{
    [[VideoUploadManager sharedManager] askToCancelAndDeleteCurrentUploadWithBlock:^(BOOL cancelled) {
        if (cancelled) {
            if (!SYSTEM_VERSION_IS_IOS_7) {
                VideoCameraViewController *video = [[VideoCameraViewController alloc] init];
                [[self.viewControllers objectAtIndex:0] presentViewController:video animated:YES completion:nil];
            }else{
                [SVProgressHUD showErrorWithStatus:@"Not on ios 7!"]; 
            }
        }
    }]; 
}
-(void)updateNoteCountBadge{
    NSString *count = [WaxDataManager sharedManager].notificationCount.intValue == 0 ? nil : [NSString stringWithFormat:@"%@", [WaxDataManager sharedManager].notificationCount]; 
    [[self.tabBar.items objectAtIndexOrNil:3] setBadgeValue:count];
}
-(void)eraseNoteCountBadge{
    [[self.tabBar.items objectAtIndexOrNil:3] setBadgeValue:nil];
}
-(void)showSplashScreen{
    UINavigationController *nav = initViewControllerWithIdentifier(@"SplashNav");
    SplashViewController *splashVC = initViewControllerWithIdentifier(@"SplashVC");
    nav.viewControllers = @[splashVC];
    
    [self presentViewController:nav animated:YES completion:^{
        for (UINavigationController *nav in self.viewControllers) {
            if ([nav respondsToSelector:@selector(popToRootViewControllerAnimated:)]) {
                [nav popToRootViewControllerAnimated:NO]; 
            }
        }
        [self setSelectedIndex:0];
    }];
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




@end
