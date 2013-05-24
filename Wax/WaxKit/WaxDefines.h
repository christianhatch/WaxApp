//
//  WaxDefines.h
//  Wax
//
//  Created by Christian Michael Hatch on 7/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


#ifdef DEBUG
#ifndef UNITTESTING
#define UNITTESTING
#endif
#endif

#pragma mark - API
extern NSString *const kWaxAPIBaseURL;
extern NSString *const kWaxAPISalt;
extern NSString *const kWaxAPIErrorDomain; 
extern NSString *const kWaxAPIJSONKey; 

#pragma mark - Third Party
extern NSString *const kThirdPartyAWSAccessKey;
extern NSString *const kThirdPartyAWSSecretKey;
extern NSString *const kThirdPartyAWSBucket;

extern NSString *const kThirdPartyUrbanAirshipAppKey;
extern NSString *const kThirdPartyUrbanAirshipAppSecret;

extern NSString *const kThirdPartyFlurryAPIKey;
extern NSString *const kThirdPartyTestFlightAPIKey;
extern NSString *const kThirdPartyCrashlyticsAPIKey;
extern NSString *const kThirdPartyUrbanAirshipAppSecret;
extern NSString *const kThirdPartyFacebookAppID;

#pragma mark - User Defaults Keys
extern NSString *const kUserSaveToCameraRollKey;
extern NSString *const kUserTokenKey;
extern NSString *const kUserIDKey;
extern NSString *const kUserNameKey;
extern NSString *const kUserFirstNameKey;
extern NSString *const kUserLastNameKey;
extern NSString *const kUserEmailKey;
extern NSString *const kUserTwitterAccountIDKey;
extern NSString *const kUserFacebookAccountIDKey;
extern NSString *const kFalseString;


#pragma mark - Notifications
extern NSString *const kWaxNotificationProfilePictureDidChange;
extern NSString *const kWaxNotificationTwitterAccountDidChange;
extern NSString *const kWaxNotificationFacebookAccountDidChange;

#pragma mark - Contstants
#define kCornerRadiusDefault                5



#pragma mark - Macro Functions


//utilities
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

//misc shortcuts
#define initViewControllerWithIdentifier(i) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:i]
#define mainWindowView [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndex:0]

//custom logging
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__); //log only in debug builds
#	define VLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); //verbose log only in debug builds
#else
#	define DLog(...) //don't log in production builds
#	define VLog(...) //don't verbose log in production builds
#endif
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); //always log, production or debug builds


//system version
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)





