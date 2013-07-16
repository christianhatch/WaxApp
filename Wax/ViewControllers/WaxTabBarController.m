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
    
    AppDelegate *delly = (AppDelegate *)[UIApplication sharedApplication].delegate;
    delly.rootViewController = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showSplashScreen) name:WaxUserDidLogOutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(capture) name:kWaxNotificationPresentVideoCamera object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleRemoteNoteFromNotification:) name:kWaxNotificationRemoteNotificationReceived object:nil];
}

-(void)setUpView{    
    [[self.tabBar.items objectAtIndex:0] setFinishedSelectedImage:[UIImage imageNamed:@"homeTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"homeTab"]];
    [[self.tabBar.items objectAtIndex:1] setFinishedSelectedImage:[UIImage imageNamed:@"discoverTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"discoverTab"]];
    [[self.tabBar.items objectAtIndex:2] setFinishedSelectedImage:[UIImage imageNamed:@"camTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"camTab"]];
    [[self.tabBar.items objectAtIndex:3] setFinishedSelectedImage:[UIImage imageNamed:@"notesTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"notesTab"]];
    [[self.tabBar.items objectAtIndex:4] setFinishedSelectedImage:[UIImage imageNamed:@"profileTab_on"] withFinishedUnselectedImage:[UIImage imageNamed:@"profileTab"]];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if ([[WaxUser currentUser] isLoggedIn]) {
        [self handleAppLaunchFromRemoteNotificationOrUpdateNoteCountBadge];
    }else{
        [self presentInitialViewController];
    }
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
  
    UINavigationController *shouldSelectNavigationController = (UINavigationController *)viewController;

    BOOL shouldSelectReturnValue = YES;
     
    if ([viewController.title isEqualToString:@"Capture"]){
        
        shouldSelectReturnValue = NO;
        
        [AIKLocationManager getAuthorizationStatusOrAskIfUndetermined];
        [self captureFromTabBar];
       
    }else if ([viewController.title isEqualToString:@"Me"]){

        if ([shouldSelectNavigationController.viewControllers.firstObject respondsToSelector:@selector(setPerson:)]) {
            ProfileViewController *profile = shouldSelectNavigationController.viewControllers.firstObject;
            profile.person = [WaxUser currentUser].personObject;
        }
        
    }else if([viewController.title isEqualToString:@"Notifications"]){
        
        [WaxDataManager sharedManager].notificationCount = @0;
        [self updateNoteCountAndUpdateBadge];
        
    }else if ([self isThirdTapOnViewController:viewController]){
        
        shouldSelectReturnValue = NO;

        if ([shouldSelectNavigationController.visibleViewController respondsToSelector:@selector(scrollAllScrollViewSubviewsToTopAnimated:)]) {
            [shouldSelectNavigationController.visibleViewController scrollAllScrollViewSubviewsToTopAnimated:YES];
        }
        
    }
    
    return shouldSelectReturnValue;
}


-(void)captureFromTabBar{
    [AIKErrorManager logMessageToAllServices:@"Tapped Record On TabBar"];
    [self capture];
}
-(void)capture{
    [[VideoUploadManager sharedManager] askToCancelAndDeleteCurrentUploadWithBlock:^(BOOL cancelled) {
        if (cancelled) {
            VideoCameraViewController *video = [[VideoCameraViewController alloc] init];
            [self presentViewController:video animated:YES completion:nil];
        }
    }];
}

#pragma mark - Splash Screen
-(void)presentInitialViewController{
    
    BOOL initialLaunch = [[WaxDataManager sharedManager].launchInfo objectForKeyOrNil:@"initial"] != nil;
    
    initialLaunch ? [self presentTutorialAndRegistrationViewController] : [self presentRegistrationViewController];
}

-(void)presentRegistrationViewController{
    UINavigationController *splashAndLoginFlow = initViewControllerWithIdentifier(@"SplashNav");
    [self presentAnIntroVC:splashAndLoginFlow];
}
-(void)presentTutorialAndRegistrationViewController{
    TutorialParentViewController *tut = [TutorialParentViewController tutorialViewController];
    [self presentAnIntroVC:tut];
}
-(void)presentAnIntroVC:(UIViewController *)vc{
    [self presentViewController:vc animated:YES completion:^{
        [self popAllNavigationChildrenViewControllersToRootViewControllerAnimated:NO];
        [self setSelectedIndex:0];
    }];
}

#pragma mark - Remote Notifications
-(void)handleAppLaunchFromRemoteNotificationOrUpdateNoteCountBadge{
    if ([WaxDataManager sharedManager].launchInfo) {
        
        [self selectNotificationTab];
        [WaxDataManager sharedManager].launchInfo = nil;
        
    }else{
        [self updateNoteCountAndUpdateBadge]; 
    }
}
-(void)handleRemoteNoteFromNotification:(NSNotification *)note{
    [self updateNoteCountAndUpdateBadge];
}

#pragma mark - Notification Badges
-(void)updateNoteCountAndUpdateBadge{
    [[WaxDataManager sharedManager] updateNotificationCountWithCompletion:^(NSError *error) {
        if (!error) {
            [self setBadgeAsNoteCount];
        }
    }];
}
-(void)setBadgeAsNoteCount{
    NSString *count = [WaxDataManager sharedManager].notificationCount.intValue == 0 ? nil : [NSString stringWithFormat:@"%@", [WaxDataManager sharedManager].notificationCount];
    [[self.tabBar.items objectAtIndexOrNil:3] setBadgeValue:count];
}
-(void)selectNotificationTab{
    [self setSelectedIndex:3];
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}




@end
