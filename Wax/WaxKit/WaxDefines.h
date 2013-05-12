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


#define kKeyForJSON                         @"response"


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






//utilities
#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

//misc shortcuts
#define initViewControllerWithIdentifier(i) [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:i]
#define mainWindowView [[[[UIApplication sharedApplication] keyWindow] subviews] objectAtIndexNotNull:0]

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
//#define IOS_6_OR_GREATER                            SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")
//#define IOS_5_1_TO_IOS_6                            SYSTEM_VERSION_LESS_THAN(@"6.0")





