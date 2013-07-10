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
    self.delegate = self;
    [self setUpView];
    
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
        [self handleAppLaunchFromRemoteNotificationIfApplicable];
    }else{
        [self showSplashScreen];
    }
}
-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
  
    UINavigationController *navigationController = (UINavigationController *)viewController;

    BOOL shouldSelectReturnValue = YES;
     
    if ([viewController.title isEqualToString:@"Capture"]){
        
        shouldSelectReturnValue = NO;
        
        [AIKLocationManager getAuthorizationStatusOrAskIfUndetermined];
        [self captureFromTabBar];
       
    }else if ([viewController.title isEqualToString:@"Me"]){

        if ([navigationController.viewControllers.firstObject isKindOfClass:[ProfileViewController class]]) {
            ProfileViewController *profile = navigationController.viewControllers.firstObject;
            profile.person = [[WaxUser currentUser] personObject];
        }
        
    }else if([viewController.title isEqualToString:@"Notifications"]){
        
        [WaxDataManager sharedManager].notificationCount = @0;
        [self updateNoteCountAndUpdateBadge];
        
    }else if ([self isThirdTapOnViewController:viewController]){
        
        shouldSelectReturnValue = NO;

        if ([navigationController.visibleViewController respondsToSelector:@selector(scrollAllScrollViewSubviewsToTopAnimated:)]) {
            [navigationController.visibleViewController scrollAllScrollViewSubviewsToTopAnimated:YES];
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

#pragma mark - Internal Methods
-(void)handleAppLaunchFromRemoteNotificationIfApplicable{
    if ([WaxDataManager sharedManager].remoteNotification) {
        
        [self selectNotificationTab];
        [WaxDataManager sharedManager].remoteNotification = nil;
        
    }
}
-(void)handleRemoteNoteFromNotification:(NSNotification *)note{
    [self updateNoteCountAndUpdateBadge];
}

-(void)showSplashScreen{
    UINavigationController *splashAndLoginFlow = initViewControllerWithIdentifier(@"SplashNav");
    
    [self presentViewController:splashAndLoginFlow animated:YES completion:^{
        [self popAllNavigationChildrenViewControllersToRootViewControllerAnimated:NO]; 
        [self setSelectedIndex:0];
    }];
}

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
