//
//  WaxDefines.h
//  Wax
//
//  Created by Christian Michael Hatch on 7/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


NSString *const kWaxVersionCodeName = @"Cinnamon Bear"; 

#pragma mark - URLS
NSString *const kWaxPrivacyPolicyURL = @"https://wax.li/documents/terms_of_service.html"; 
NSString *const kWaxTermsOfServiceURL = @"https://wax.li/documents/privacy-policy.html"; 
NSString *const kWaxAttributionsURL = @"https://wax.li/documents/acknowledgements.html"; 
NSString *const kWaxItunesStoreURL = @"http://bit.ly/DownloadWax";

#pragma mark - API
NSString *const kWaxAPIBaseURL = @"https://api.wax.li/v1/";
NSString *const kWaxAPISalt = @"pXOnay@E3p*#5lJC)D^t$8WBb4X_yDds0Z75t$@I";
NSString *const kWaxAPIErrorDomain = @"com.wax.api"; 
NSString *const kWaxAPIJSONKey = @"response";


#pragma mark - Third Party
NSString *const kThirdPartyAWSBucket = @"waxusers"; 
NSString *const kThirdPartyCloudFrontBaseURL = @"https://d21k04qwl5qjec.cloudfront.net";
NSString *const kThirdPartyCloudFrontImagesBaseURL = @"https://d3ivg2mevd4vgx.cloudfront.net/category_icons/";

#ifdef DEBUG
NSString *const kThirdPartyUrbanAirshipAppKey = @"fwDHlfpLQqmEIqS2Y3ElDQ";
NSString *const kThirdPartyUrbanAirshipAppSecret = @"Zx33iHAvRgm-4MhIS5qjFg";
#else
NSString *const kThirdPartyUrbanAirshipAppKey = @"KuL5-1QcTKupwNmaUmsnFA";
NSString *const kThirdPartyUrbanAirshipAppSecret = @"R5R1VnxeSuug8r_wfK_0IQ";
#endif

NSString *const kThirdPartyTapStreamAccountName = @"wax"; 
NSString *const kThirdPartyTapStreamAccountSecret = @"QeNEvXFrSeqe14bG9OHjAA";

NSString *const kThirdPartyFlurryAPIKey = @"TQYDF7654QX3TSKCPZ7T";
NSString *const kThirdPartyTestFlightAPIKey = @"cd37aa62-2d60-4e23-9c49-33561a1f3f3b";
NSString *const kThirdPartyCrashlyticsAPIKey = @"50bd7200ec2054f6ac2b747cc51ca6ae08298664";

NSString *const kThirdPartyFacebookAppID = @"181035102046368";
NSString *const kThirdPartyTwitterConsumerKey = @"CVR0lzKnwcyobFkt5X8xg"; 
NSString *const kThirdPartyTwitterConsumerSecret = @"JvJAvPfvEUFDTRXpHv3Iq1yABERa4naCrWo2vJfZQDw"; 

#pragma mark - User Defaults Keys
NSString *const kUserTokenKey = @"waxUserToken";
NSString *const kUserIDKey = @"waxUserID";
NSString *const kUserNameKey = @"waxUserName";
NSString *const kUserFirstNameKey = @"waxFirstName";
NSString *const kUserLastNameKey = @"waxLastName";
NSString *const kUserEmailKey = @"waxEmail"; 
NSString *const kUserTwitterAccountIDKey = @"waxTwitterAccountID";
NSString *const kUserFacebookAccountIDKey = @"waxFacebookAccountID";

NSString *const kShouldSaveToCameraRollKey = @"waxShouldSaveToCameraRoll"; 
NSString *const kFalseString = @"false";

#pragma mark - Notifications
NSString *const kWaxNotificationProfilePictureDidChange = @"waxUserProfilePictureDidChangeNotification";
NSString *const kWaxNotificationTwitterAccountDidChange = @"waxUserTwitterAccountDidChangeNotification"; 
NSString *const kWaxNotificationFacebookAccountDidChange = @"waxUserFacebookAccountDidChangeNotification"; 
NSString *const kWaxNotificationPresentVideoCamera = @"waxShowVideoCameraNotification"; 
NSString *const kWaxNotificationRemoteNotificationReceived = @"waxRemoteNotificationReceivedNotification"; 





