//
//  WaxDefines.h
//  Wax
//
//  Created by Christian Michael Hatch on 7/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


#pragma mark - API
extern NSString *const kWaxAPIBaseURL;
extern NSString *const kWaxAPISalt;


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


#pragma mark - Notifications
extern NSString *const kWaxNotificationProfilePictureDidChange;
extern NSString *const kWaxNotificationTwitterAccountDidChange;
extern NSString *const kWaxNotificationFacebookAccountDidChange;












//Macros
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#define IOS_6_OR_GREATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
#define IOS_5_1_TO_IOS_6                            SYSTEM_VERSION_LESS_THAN(@"6.0")

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((fmt), ##__VA_ARGS__);
#	define VLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#	define VLog(...)
#endif
// ALog always displays output regardless of the DEBUG setting
#define ALog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#define initViewControllerWithIdentifier(i) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:i]

#define mainWindowView [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndexNotNull:0]



