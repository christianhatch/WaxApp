//
//  AppDelegate.m
//  Wax
//
//  Created by Christian Hatch on 4/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kInitialLaunchKey   @"initialLaunch"


#import "AppDelegate.h"
#import "TestFlight.h"
#import "Flurry.h"
#import "TSApi.h"
#import "AFUrbanAirshipClient.h"
#import "DCIntrospect.h"

#import <AdSupport/AdSupport.h>
#import "WaxAPIErrorManagerService.h"

#import <TargetConditionals.h>

//#import "Appirater.h"
//#import "AppiraterDelegate.h" 

@protocol UIDeviceHack <NSObject>
-(NSString *)uniqueIdentifier;
@end

@interface AppDelegate () 

@end

@implementation AppDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
#ifdef DEBUG
//    [SBAPNSPusher start];
#endif
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:kInitialLaunchKey]) {
        [self initialLaunch];
    }
    
    if ([launchOptions objectForKeyOrNil:UIApplicationLaunchOptionsRemoteNotificationKey] != nil) {
        [self handleRemoteNotification:[launchOptions objectForKeyOrNil:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    if ([WaxUser currentUser].isLoggedIn) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound |UIRemoteNotificationTypeAlert)];
    }
    
    [self customizeAppearance];
    [self bootupThirdPartySDKs];
    
    DDLogInfo(@"Current User %@", [WaxUser currentUser]);
    
    return YES;
}

#pragma mark - InterApp Communication
-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    return [[AIKFacebookManager sharedManager] handleOpenURL:url];
}
-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    return [[AIKFacebookManager sharedManager] handleOpenURL:url];
}

#pragma mark - Remote Notifications
-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    AFUrbanAirshipClient *ship = [[AFUrbanAirshipClient alloc] initWithApplicationKey:kThirdPartyUrbanAirshipAppKey applicationSecret:kThirdPartyUrbanAirshipAppSecret];

    [ship registerDeviceToken:deviceToken withAlias:[WaxUser currentUser].userID success:^{
        //yay!
    } failure:^(NSError *error) {
        [AIKErrorManager logError:error withMessage:@"error registering device token with urban airship"];
    }];
}
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    [AIKErrorManager logError:error withMessage:@"Did Fail To Register For Remote Notifications"];
}
-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
 
    [self handleRemoteNotification:userInfo];

    [UIApplication resetBadge];
}

-(void)handleRemoteNotification:(NSDictionary *)note{
    
    switch ([UIApplication sharedApplication].applicationState) {
        case UIApplicationStateInactive:
        case UIApplicationStateBackground:{
            [WaxDataManager sharedManager].launchInfo = note;
        }break;
        case UIApplicationStateActive:{
            [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationRemoteNotificationReceived object:self userInfo:note];
        }break;
    }
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
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application{
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma Internal Methods & Misc. 
-(void)bootupThirdPartySDKs{
    
    /*
#ifdef DEBUG
    [Appirater setAppId:@"551174140"];
    [Appirater setDaysUntilPrompt:3];
    [Appirater setUsesUntilPrompt:10];
    [Appirater setTimeBeforeReminding:3];
    [Appirater setDelegate:self];
    [Appirater appLaunched:YES];
#endif
    */
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
   
    [AIKFacebookManager setFacebookAppID:kThirdPartyFacebookAppID];
    [AIKTwitterManager setTwitterConsumerKey:kThirdPartyTwitterConsumerKey];
    [AIKTwitterManager setTwitterConsumerSecret:kThirdPartyTwitterConsumerSecret];
    
    [AIKErrorManager enableFileLogger:YES];
    [AIKErrorManager addPassThroughErrorDomain:kWaxAPIErrorDomain];
    [AIKErrorManager addErrorManagerService:[WaxAPIErrorManagerService sharedInstance]]; 
    
    
#ifdef DEBUG
    [AIKErrorManager enableXcodeLogger:YES];
    
    [AIKErrorManager enableAppleSystemLogger:YES];
    [AIKErrorManager addPassThroughErrorDomain:AFNetworkingErrorDomain];
    
#if TARGET_IPHONE_SIMULATOR
    [[DCIntrospect sharedIntrospector] start];
#endif
    
#else

    #ifdef TESTFLIGHT
        [AIKErrorManager enableAppleSystemLogger:YES];
        [AIKErrorManager addPassThroughErrorDomain:AFNetworkingErrorDomain];

        [TestFlight setDeviceIdentifier:[(id<UIDeviceHack>)[UIDevice currentDevice] uniqueIdentifier]];

        TSConfig *config = [TSConfig configWithDefaults];
        config.collectWifiMac = NO;
        config.idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
        [TSTapstream createWithAccountName:kThirdPartyTapStreamAccountName developerSecret:kThirdPartyTapStreamAccountSecret config:config];
    #endif
        [TestFlight takeOff:kThirdPartyTestFlightAPIKey];
        [Flurry startSession:kThirdPartyFlurryAPIKey];
        [Crashlytics startWithAPIKey:kThirdPartyCrashlyticsAPIKey delegate:self];
        [WaxUser saveCurrentUserToVendorSolutions];
    
        [AIKErrorManager enableCrashlyticsLogger:YES];

#endif
    
}

-(void)customizeAppearance{
    
    NSDictionary *navTitleAttributes = @{UITextAttributeFont: [UIFont waxHeaderFontItalicsOfSize:20],
                                         UITextAttributeTextColor: [UIColor whiteColor],
                                         UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    [[UINavigationBar appearance] setTitleTextAttributes:navTitleAttributes];
    
    UIImage *navBarBG = [UIImage stretchyImage:[UIImage imageNamed:@"navbar_bg"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO]; 
    [[UINavigationBar appearance] setBackgroundImage:navBarBG forBarMetrics:UIBarMetricsDefault];
    [[UIToolbar appearance] setBackgroundImage:navBarBG forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIImage *tabBarBG = [UIImage stretchyImage:[UIImage imageNamed:@"tabbar_bg"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO]; 
    [[UITabBar appearance] setBackgroundImage:tabBarBG];
    [[UITabBar appearance] setSelectionIndicatorImage:[[UIImage alloc] init]]; 
    
        
    UIImage *backButtonDefault = [UIImage stretchyImage:[UIImage imageNamed:@"navbar_back_arrow"] withCapInsets:UIEdgeInsetsMake(0, 20, 0, 0) useImageHeight:NO];
    UIImage *backButtonHighlighted = [UIImage stretchyImage:[UIImage imageNamed:@"navbar_back_arrowOn"] withCapInsets:UIEdgeInsetsMake(0, 20, 0, 0) useImageHeight:NO];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonDefault forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonHighlighted forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault]; 
    
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    
    NSDictionary *barButtonTitleNormal = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                           UITextAttributeTextColor: [UIColor whiteColor],
                                           UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    NSDictionary *barButtonTitleHighlighted = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                                UITextAttributeTextColor: [UIColor waxHeaderFontColor],
                                                UITextAttributeTextShadowColor: [UIColor clearColor]};
        
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonTitleNormal  forState:UIControlStateNormal];
    [[UIBarButtonItem appearance] setTitleTextAttributes:barButtonTitleHighlighted forState:UIControlStateHighlighted];
    
    
    NSDictionary *tabBarItemTitleNormal = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                            UITextAttributeTextColor: [UIColor colorWithHex:0x798389],
                                            UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    NSDictionary *tabBarItemTitleHighlighted = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                                 UITextAttributeTextColor: [UIColor whiteColor],
                                                 UITextAttributeTextShadowColor: [UIColor clearColor]};

    [[UITabBarItem appearance] setTitleTextAttributes:tabBarItemTitleNormal forState:UIControlStateNormal];
    [[UITabBarItem appearance] setTitleTextAttributes:tabBarItemTitleHighlighted forState:UIControlStateSelected];

    UIImage *searchBG = [UIImage stretchyImage:[UIImage imageNamed:@"waxSearchBar_bg"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO];
    UIImage *scopeBGNormal = [UIImage stretchyImage:[UIImage imageNamed:@"waxSearchScope"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO];
    UIImage *scopeBGSelected = [UIImage stretchyImage:[UIImage imageNamed:@"waxSearchScope_on"] withCapInsets:UIEdgeInsetsMake(0, 1, 0, 1) useImageHeight:NO];
    
    [[UISearchBar appearance] setSearchFieldBackgroundImage:searchBG forState:UIControlStateNormal];
    [[UISearchBar appearance] setBackgroundImage:searchBG];
    [[UISearchBar appearance] setScopeBarButtonBackgroundImage:scopeBGNormal forState:UIControlStateNormal];
    [[UISearchBar appearance] setScopeBarButtonBackgroundImage:scopeBGSelected forState:UIControlStateSelected];
    [[UISearchBar appearance] setScopeBarBackgroundImage:searchBG];
    
    NSDictionary *searchBarButtonNormal = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                            UITextAttributeTextColor: [UIColor blackColor],
                                            UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    NSDictionary *searchBarButtonHighlighted = @{UITextAttributeFont: [UIFont waxDefaultFontOfSize:12],
                                                 UITextAttributeTextColor: [UIColor lightGrayColor],
                                                 UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:searchBarButtonNormal  forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:searchBarButtonHighlighted forState:UIControlStateHighlighted];
    
    NSDictionary *scopeButtonTextNormal = @{UITextAttributeFont: [UIFont waxDetailFontOfSize:12],
                                            UITextAttributeTextColor: [UIColor blackColor],
                                            UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    NSDictionary *scopeButtonTextSelected = @{UITextAttributeFont: [UIFont waxDetailFontOfSize:12],
                                              UITextAttributeTextColor: [UIColor whiteColor],
                                              UITextAttributeTextShadowColor: [UIColor clearColor]};
    
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:scopeButtonTextNormal forState:UIControlStateNormal];
    [[UISearchBar appearance] setScopeBarButtonTitleTextAttributes:scopeButtonTextSelected forState:UIControlStateSelected];
    
    
    [[UISwitch appearance] setOnTintColor:[UIColor waxRedColor]];
}

-(void)initialLaunch{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kInitialLaunchKey];
       
    [WaxUser resetForInitialLaunch];
}

-(void)crashlyticsDidDetectCrashDuringPreviousExecution:(Crashlytics *)crashlytics{
    [AIKErrorManager didCrash];
}





@end
