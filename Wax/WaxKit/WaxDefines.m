//
//  WaxDefines.h
//  Wax
//
//  Created by Christian Michael Hatch on 7/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//




#pragma mark - API
NSString *const kWaxAPIBaseURL = @"http://app.wax.li/v0.0.1/";
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
NSString *const kThirdPartyFlurryAPIKey = @"TQYDF7654QX3TSKCPZ7T";
NSString *const kThirdPartyTestFlightAPIKey = @"cd37aa62-2d60-4e23-9c49-33561a1f3f3b";
NSString *const kThirdPartyCrashlyticsAPIKey = @"50bd7200ec2054f6ac2b747cc51ca6ae08298664";
NSString *const kThirdPartyFacebookAppID = @"181035102046368";


#pragma mark - User Defaults Keys
NSString *const kUserSaveToCameraRollKey = @"saveToCameraRoll";
NSString *const kUserTokenKey = @"waxUserToken";
NSString *const kUserIDKey = @"waxUserID";
NSString *const kUserNameKey = @"waxUserName";
NSString *const kUserFirstNameKey = @"waxFirstName";
NSString *const kUserLastNameKey = @"waxLastName";
NSString *const kUserEmailKey = @"waxEmail"; 
NSString *const kUserTwitterAccountIDKey = @"waxTwitterAccountID";
NSString *const kUserFacebookAccountIDKey = @"waxFacebookAccountID"; 
NSString *const kFalseString = @"false";

#pragma mark - Notifications
NSString *const kWaxNotificationProfilePictureDidChange = @"waxUserProfilePictureDidChangeNotification";
NSString *const kWaxNotificationTwitterAccountDidChange = @"waxUserTwitterAccountDidChangeNotification"; 
NSString *const kWaxNotificationFacebookAccountDidChange = @"waxUserFacebookAccountDidChangeNotification"; 
NSString *const kWaxNotificationPresentVideoCamera = @"waxShowVideoCameraNotification"; 




//networking stuff
#define kInfiniteScrollingBatchCount        10

//ui stuff
#define kHeaderHeightDefault                23


#define kFeedCellFlagConfirmText            @"Are you sure you want to flag this Kiwi as innapropriate?"
#define kFeedCellDeleteConfirmText          @"Are you sure you want to delete your Kiwi?"
#define kFeedCellDefaultCaption             @"Check out my video on Kiwi!"
#define kFeedCellFlagInnapropriate          @"Flag Innapropriate" 

#define KWLaunchOptionGotoIDKey             @"pID"
#define KWLaunchOptionGotoTypeKey           @"pType"
#define KWLaunchOptionUsernameKey           @"pName"



#ifndef RELEASE

#define kSuperUserFinalConfirmationText     @"Are you absolutely sure you want to invoke super user privileges and delete this?\n\nRemember, with great power comes great responsibility! Be careful sonny!\n\n - ONLY use this when a Kiwi or comment violates the Kiwi Terms of Service! - \n\n"
#define kSuperUserGuidelinesText            @"Does this Kiwi or comment contain:\nProfanity?\nNudity?\nRacially Offesnive content?\nGraphic Violence?\nObscenity?"
#define kInvokeSuPrivsButtonLabel           @" -Invoke Superuser Privs to Delete- "
#define KWSuperUserModeEnableKey            @"superUserModeEnabled"

#endif












