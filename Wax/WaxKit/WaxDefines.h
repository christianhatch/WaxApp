//
//  WaxDefines.h
//  Wax
//
//  Created by Christian Michael Hatch on 7/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


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




//Third party services
#define kAWSAccessKey                       @"AKIAJEU4MNQ7TAE53Z6Q"
#define kAWSSecretKey                       @"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"
#define kAWSBucket                          @"waxusers"

#ifdef DEBUG
#define kUrbanAirshipAppKey                 @"fwDHlfpLQqmEIqS2Y3ElDQ"
#define kUrbanAirshipAppSecret              @"Zx33iHAvRgm-4MhIS5qjFg"
#else
#define kUrbanAirshipAppKey                 @"KuL5-1QcTKupwNmaUmsnFA"
#define kUrbanAirshipAppSecret              @"R5R1VnxeSuug8r_wfK_0IQ"
#endif

#define kFlurryAPIKey                       @"TQYDF7654QX3TSKCPZ7T"
#define kTestFlightAPIKey                   @"cd37aa62-2d60-4e23-9c49-33561a1f3f3b"
#define kCrashlyticsAPIKey                  @"50bd7200ec2054f6ac2b747cc51ca6ae08298664"
#define kFacebookAppID                      @"181035102046368"

#define kTwitterStatusUpdateURL             [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update.json"]
#define kFacebookStatusUpdateURL            [NSURL URLWithString:@"https://graph.facebook.com/me/feed"]
#define kUserTokenSalt                     @"rO8j!AJp_uEvl(Y%)Go3LvZA5cOcSTt^t5Pon&8r"




/*
//networking stuff
#define kPostMethod                         @"POST"
#define kConnectionErrorNotify              @"connectionError"
#define kConnectionOffline                  @"globalConnectionOffline"
#define kConnectionOnline                   @"globalConnectionOnline"
#define kDevBaseURL                         @"https://dev.kiwi.ly/v1.2.8/"
#define kLiveBaseURL                        @"https://app.kiwi.ly/v1.2.8/"
#define kServerBaseURLKey                   @"serverBaseURL"
#define kToggleDevURL                       @"account/toggledev.php"
#define kKeyForJSON                         @"response"
#define KWKiwiBaseURL                       [NSURL URLWithString:kLiveBaseURL]

//urls
#define kForgotPasswordURL                  @"passwords/forgot.php"
#define kLoginURL                           @"logins/login.php"
#define kFBLoginURL                         @"logins/facebooklogin.php"
#define kSignupURL                          @"logins/signup.php"
#define kAllFollowersURL                    @"logins/allfollowing.php"
#define kFriendsFeedURL                     @"feeds/friend.php"
#define kTrendsFeedURL                      @"feeds/trend.php"
#define kPeopleFeedURL                      @"feeds/user.php"
#define kLikeFeedURL                        @"feeds/like.php"
#define kTagFeedURL                         @"feeds/tag.php"
#define kNotificationsURL                   @"notes/get.php"
#define kMarkNotesReadURL                   @"notes/view.php"
#define kNoteCountURL                       @"notes/count.php"
#define kVideoViewedURL                     @"videos/view.php"
#define kUploadVideoURL                     @"videos/put.php"
#define kFlagVideoURL                       @"videos/flag.php"
#define kLikeListURL                        @"videos/likelist.php"
#define kDeleteVideoURL                     @"videos/delete.php"
#define kLikeVideoURL                       @"videos/like.php"
#define kVideoInfoURL                       @"videos/get.php"
#define kVideoCommentsURL                   @"comments/get.php"
#define kSendCommentURL                     @"comments/put.php"
#define kDeleteCommentURL                   @"comments/delete.php"
#define kAddFollowURL                       @"users/put.php"
#define kRemoveFollowURL                    @"users/delete.php"
#define kFacebookFriendsURL                 @"users/fbfriends.php"
#define kContactsOnKiwiURL                  @"users/contactfriends.php"
#define kProfileInfoURL                     @"users/getprofile.php"
#define kFollowingURL                       @"users/following.php"
#define kFollowersURL                       @"users/followers.php"
#define kPeopleSearchURL                    @"users/search.php"
#define kDiscoverURL                        @"tags/trending.php"
#define kSearchTagsURL                      @"tags/search.php"
#define kUpdateSettingsURL                  @"settings/update.php"
#define kGetSettingsURL                     @"settings/get.php"
#define kChangeUsernameURL                  @"settings/changename.php"
#define kUpdateFacebookURL                  @"settings/fbconnect.php"
#define kChangePasswordURL                  @"passwords/update.php"

#define kRequestPrivateFollowURL            @"privateusers/put.php"
#define kPendingUsersListURL                @"privateusers/get.php"
#define kAcceptOrDelcineFollowerURL         @"privateusers/update.php" 
#define kDeletePrivateFollowerURL           @"privateusers/delete.php" 

#define kInfiniteScrollingBatchCount        10

//ui stuff
#define kDEFAULT_CORNER_RADIUS              5
#define KWAnimationDuration                 0.35
#define kHeaderHeightDefault                23
#define kUIImageViewKiwiBG                  @"UIImagebgKiwi@2x.png"

#define ksegueMeToSettings                  @"MeToSettings"
#define ksegueSettingsToPassword            @"SettingsToChangePassword"

#define kFeedCellFlagConfirmText            @"Are you sure you want to flag this Kiwi as innapropriate?"
#define kFeedCellDeleteConfirmText          @"Are you sure you want to delete your Kiwi?"
#define kFeedCellDefaultCaption             @"Check out my video on Kiwi!"
#define kFeedCellFlagInnapropriate          @"Flag Innapropriate" 


//nsuserdefaults keys
#define KWSaveToCameraRollKey               @"saveToCameraRoll"
#define KWUserTokenKey                      @"token"
#define KWUserIDKey                         @"userid"
#define KWUserNameKey                       @"username"
#define KWUserEmailKey                      @"email"
#define KWUserFirstNameKey                  @"firstname"
#define KWUserLastNameKey                   @"lastname"
#define KWUserPrivacyKey                    @"privateProfile"
#define KWUserNoFriendsKey                  @"noFriends"
#define KWTwitterAccountIDKey               @"twitterAccountID"
#define KWFacebookAccountIDKey              @"facebookAccountID"
#define KWProfilePictureChangeDateKey           @"profilePictureChangeDate"

#define KWLaunchOptionGotoIDKey             @"pID"
#define KWLaunchOptionGotoTypeKey           @"pType"
#define KWLaunchOptionUsernameKey           @"pName"

//nsnotification constants
#define KWProfilePictureChangedNotification     @"profilePictureDidChange"
#define KWAccountPrivacyChangedNotification     @"accountPrivacyDidChange"
#define KWTwitterAccountChangedNotification     @"twitterAccountDidChange"
#define KWFacebookAccountChangedNotification    @"facebookAccountDidChange"
//#define KWContactsChangedNotification           @"contactsDidChange"

 */
#ifndef RELEASE

#define kSuperUserFinalConfirmationText     @"Are you absolutely sure you want to invoke super user privileges and delete this?\n\nRemember, with great power comes great responsibility! Be careful sonny!\n\n - ONLY use this when a Kiwi or comment violates the Kiwi Terms of Service! - \n\n"
#define kSuperUserGuidelinesText            @"Does this Kiwi or comment contain:\nProfanity?\nNudity?\nRacially Offesnive content?\nGraphic Violence?\nObscenity?"
#define kInvokeSuPrivsButtonLabel           @" -Invoke Superuser Privs to Delete- "
#define KWSuperUserModeEnableKey            @"superUserModeEnabled"

#endif












