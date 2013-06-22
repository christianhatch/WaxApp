//
//  AppDelegate.m
//  Wax
//
//  Created by Christian Hatch on 4/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "AppDelegate.h"
#import <AcaciaKit/TestFlight.h>
#import <AcaciaKit/Flurry.h>

@protocol UIDeviceHack <NSObject>
-(NSString *)uniqueIdentifier;
@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"initialLaunch"]) {
        [self initialLaunch];
    }
    if ([[WaxUser currentUser] isLoggedIn]) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    }
    [self customizeAppearance];
    [self bootupThirdPartySDKs];
        
    return YES;
}

#pragma mark - Interapp Communication
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[AIKFacebookManager sharedManager] handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[AIKFacebookManager sharedManager] handleOpenURL:url];
}

#pragma mark - Remote Notifications
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    AFUrbanAirshipClient *ship = [[AFUrbanAirshipClient alloc] initWithApplicationKey:kThirdPartyUrbanAirshipAppKey applicationSecret:kThirdPartyUrbanAirshipAppSecret];

    [ship registerDeviceToken:deviceToken withAlias:[[WaxUser currentUser] userID] success:^{
        //yay!
    } failure:^(NSError *error) {
        [AIKErrorManager logMessage:@"error registering device token with urban airship" withError:error];
    }];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [AIKErrorManager logMessage:@"Did Fail To Register For Remote Notifications" withError:error];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    //do lots of fun things here!
    [UIApplication resetBadge];
}



#pragma mark - Application State Change Callbacks
- (void)applicationWillResignActive:(UIApplication *)application{
    [UIApplication resetBadge];
    [UIApplication clearTempDirectory];
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    [[AIKFacebookManager sharedManager] handleAppDidBecomeActive];
//    [[WaxDataManager sharedManager] updateNotificationCountWithCompletion:nil];
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma Internal Methods & Misc. 
-(void)bootupThirdPartySDKs{
#ifdef DEBUG
    //    [Appirater setAppId:@"551174140"];
    //    [Appirater setDaysUntilPrompt:3];
    //    [Appirater setUsesUntilPrompt:10];
    //    [Appirater setTimeBeforeReminding:3];
    //    [Appirater setDelegate:self];
    //    [Appirater appLaunched:YES];
#endif
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    [AIKFacebookManager setFacebookAppID:kThirdPartyFacebookAppID];
    [AIKTwitterManager setTwitterConsumerKey:kThirdPartyTwitterConsumerKey];
    [AIKTwitterManager setTwitterConsumerSecret:kThirdPartyTwitterConsumerSecret];
    
#ifndef DEBUG
#ifdef TESTFLIGHT
    [TestFlight setDeviceIdentifier:[(id<UIDeviceHack>)[UIDevice currentDevice] uniqueIdentifier]];
#endif
    [TestFlight takeOff:kThirdPartyTestFlightAPIKey];
    [Flurry startSession:kThirdPartyFlurryAPIKey];
    [Crashlytics startWithAPIKey:kThirdPartyCrashlyticsAPIKey delegate:self];
#endif
}
-(void)customizeAppearance{
    /*
    NSDictionary *navTitle = [NSDictionary dictionaryWithObjectsAndKeys: [UIColor blackColor], UITextAttributeTextColor, [[UIColor whiteColor] colorWithAlphaComponent:0.8], UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, [UIFont kiwiLightOfSize:0.0], UITextAttributeFont, nil];
    [[UINavigationBar appearance] setTitleTextAttributes:navTitle];
    
    [[UINavigationBar appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"navbar_bg.png"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO] forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"navbar_bg.png"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"back_arrow.png"] withCapInsets:UIEdgeInsetsMake(0, 20, 0, 0) useImageHeight:NO] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"nav_button.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:NO] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"nav_buttonOn.png"] withCapInsets:UIEdgeInsetsMake(0, 7, 0, 7) useImageHeight:NO] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UITabBar appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"tabbar_bg.png"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO]];
    
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"glass.png"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    [[UISearchBar appearance] setImage:[UIImage imageNamed:@"clearX.png"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
    [[UISearchBar appearance] setSearchFieldBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"search_field.png"] withCapInsets:UIEdgeInsetsMake(0, 6, 0, 6) useImageHeight:YES] forState:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundImage:[UIImage stretchyImage:[UIImage imageNamed:@"searchbg_stretch.png"] withCapInsets:UIEdgeInsetsMake(0, 2, 0, 6) useImageHeight:YES]];
    
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor grayColor]];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(1200, 0) forBarMetrics:UIBarMetricsDefault];
    
    NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys: [[UIColor blackColor] colorWithAlphaComponent:1.0], UITextAttributeTextColor, [[UIColor blackColor] colorWithAlphaComponent:1.0], UITextAttributeTextShadowColor, [NSValue valueWithUIOffset:UIOffsetMake(0, 0)], UITextAttributeTextShadowOffset, [UIFont kiwiLightOfSize:0.0], UITextAttributeFont, nil];
    
    [[UIBarButtonItem appearance] setTitleTextAttributes:titleAttributes  forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:titleAttributes forState:UIControlStateHighlighted];
    
    
    
    
    [[UISlider appearance] setMaximumTrackImage:[UIImage stretchyImage:[UIImage imageNamed:@"slider_maximum.png"] withCapInsets:UIEdgeInsetsMake(0, 5, 0, 0) useImageHeight:YES] forState:UIControlStateNormal];
    [[UISlider appearance] setMinimumTrackImage:[UIImage stretchyImage:[UIImage imageNamed:@"slider_minimum.png"] withCapInsets:UIEdgeInsetsMake(0, 5, 0, 0) useImageHeight:YES] forState:UIControlStateNormal];
    
    [[UISlider appearance] setThumbImage:[UIImage imageNamed:@"slider_Thumb.png"] forState:UIControlStateNormal];
    */
}
-(void)initialLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"initialLaunch"]; //set the flag so this is run only the first time the app is opened
    [WaxUser resetForInitialLaunch];
}
-(void)crashlyticsDidDetectCrashDuringPreviousExecution:(Crashlytics *)crashlytics{
    [AIKErrorManager didCrash];
}
@end
