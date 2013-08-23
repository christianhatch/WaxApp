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
#import "TutorialParentViewController.h"

@interface WaxTabBarController ()

@end


@implementation WaxTabBarController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.delegate = self;
    [self setUpView];
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentInitialViewController) name:WaxUserDidLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(capture) name:kWaxNotificationPresentVideoCamera object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDidReceiveRemoteNotification:) name:kWaxNotificationRemoteNotificationReceived object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectHomeTab) name:@"kDidDismissSharePage" object:nil];
}

-(void)setUpView{    
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"homeTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeTab"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"discoverTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"discoverTab"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"camTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"camTab"]];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"notesTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"notesTab"]];
    [[self.tabBar.items objectAtIndex:4] setFinishedSelectedImage:[UIImage imageNamed:@"profileTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"profileTab"]];

    for (UITabBarItem *item in self.tabBar.items) {
        item.title = nil;
        item.imageInsets = UIEdgeInsetsMake(7, 0, -7, 0);
    }
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([WaxUser currentUser].isLoggedIn) {
        
        [self updateNoteCountAndBadgeFromServer];

        if ([self shouldHandleLaunchFromRemoteNotification]) {
            [self handleLaunchFromRemoteNotification];
        }
        
    }else{
        [self presentInitialViewController];
    }
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
  
    UINavigationController *shouldSelectNavigationController = (UINavigationController *)viewController;

    BOOL shouldSelect = YES; 
    
    if ([viewController.title isEqualToString:@"Capture"]){
                
        [AIKLocationManager getAuthorizationStatusOrAskIfUndetermined];
        [self captureFromTabBar];

        shouldSelect =  NO;
        
    }else if ([viewController.title isEqualToString:@"Me"]){

        if ([shouldSelectNavigationController.viewControllers.firstObject respondsToSelector:@selector(setPerson:)]) {
            ProfileViewController *profile = shouldSelectNavigationController.viewControllers.firstObject;
            profile.person = [WaxUser currentUser].personObject;
        }
                
    }else if([viewController.title isEqualToString:@"Notifications"]){
        
        [WaxDataManager sharedManager].notificationCount = @0;
        [self updateNotificationBadgeToReflectNoteCount];
                
    }
    
    if ([self isThirdTapOnViewController:viewController]){
        
        if ([shouldSelectNavigationController.visibleViewController respondsToSelector:@selector(scrollAllScrollViewSubviewsToTopAnimated:)]) {
            [shouldSelectNavigationController.visibleViewController scrollAllScrollViewSubviewsToTopAnimated:YES];
        }
        
    }
    
    return shouldSelect;
}


-(void)captureFromTabBar{
    [AIKErrorManager logMessage:@"Tapped Record On TabBar"];
    [self capture];
}
-(void)capture{
    [[VideoUploadManager sharedManager] askToCaptureFromTabbarWithBlock:^(BOOL allowedToProceed) {
        if (allowedToProceed) {
            VideoCameraViewController *video = [[VideoCameraViewController alloc] init];
            [self presentViewController:video animated:YES completion:nil];
        }
    }];
}

#pragma mark - Splash Screen
-(void)presentInitialViewController{
    UINavigationController *splashAndLoginFlow = initViewControllerWithIdentifier(@"SplashNav");
    [self presentViewController:splashAndLoginFlow animated:YES completion:^{
        [self popAllNavigationChildrenViewControllersToRootViewControllerAnimated:NO];
        [self setSelectedIndex:0];
    }];
}

#pragma mark - Remote Notifications
-(void)handleLaunchFromRemoteNotification{
    [self selectNotificationTab];
    [WaxDataManager sharedManager].launchInfo = nil;
}

-(void)handleDidReceiveRemoteNotification:(NSNotification *)note{
    [self updateNoteCountAndBadgeFromServer];
}


#pragma mark - Internal Methods
-(void)updateNoteCountAndBadgeFromServer{
    [[WaxDataManager sharedManager] updateNotificationCountWithCompletion:^(NSError *error) {
        if (!error) {
            [self updateNotificationBadgeToReflectNoteCount];
        }
    }];
}

#pragma mark - Convenience Methods
-(void)updateNotificationBadgeToReflectNoteCount{
    NSString *count = [WaxDataManager sharedManager].notificationCount.intValue == 0 ? nil : [NSString stringWithFormat:@"%@", [WaxDataManager sharedManager].notificationCount];
    [[self.tabBar.items objectAtIndexOrNil:3] setBadgeValue:count];
}

-(void)selectNotificationTab{
    [self setSelectedIndex:3];
}
-(void)selectHomeTab{
    [self setSelectedIndex:0];
}

-(BOOL)shouldHandleLaunchFromRemoteNotification{
    return [WaxDataManager sharedManager].launchInfo != nil;
}

- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




@end
