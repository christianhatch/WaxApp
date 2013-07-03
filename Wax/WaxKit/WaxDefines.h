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
extern NSString *const kWaxAPIErrorDomain; 
extern NSString *const kWaxAPIJSONKey; 

#pragma mark - Third Party
extern NSString *const kThirdPartyAWSBucket;
extern NSString *const kThirdPartyCloudFrontBaseURL;
extern NSString *const kThirdPartyCloudFrontImagesBaseURL; 

extern NSString *const kThirdPartyUrbanAirshipAppKey;
extern NSString *const kThirdPartyUrbanAirshipAppSecret;

extern NSString *const kThirdPartyFlurryAPIKey;
extern NSString *const kThirdPartyTestFlightAPIKey;
extern NSString *const kThirdPartyCrashlyticsAPIKey;

extern NSString *const kThirdPartyFacebookAppID;
extern NSString *const kThirdPartyTwitterConsumerKey;
extern NSString *const kThirdPartyTwitterConsumerSecret;

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
extern NSString *const kWaxNotificationPresentVideoCamera;
extern NSString *const kWaxNotificationRemoteNotificationReceived; 

#define kCornerRadiusDefault                5
#define kAPIBatchCountDefault               10




