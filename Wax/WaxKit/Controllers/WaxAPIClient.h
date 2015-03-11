//
//  WaxAPIClient.h
//  Wax
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//


#import "AFNetworking.h"

@class LoginObject, PersonObject, VideoObject, SettingsObject, CLLocation;


/**
 @typedef
 
 @abstract Completion block type used when returning the results of a login request.
 @discussion This completion block type returns a valid login object and a nil error object if successful, or a nil login object and a valid error object if unsuccessful. 
 */
typedef void(^WaxAPIClientBlockTypeCompletionLogin)(LoginObject *loginResponse, NSError *error);

/** 
 @typedef
 
 @abstract Completion block type used when returning the results of a request that returns an array of model objects
 @discussion This completion block type returns a mutable array of model objects appropriate to the request and a nil error object if successful, or a nil mutable array and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientBlockTypeCompletionList)(NSMutableArray *list, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request for the profile information of a particular user.
 @discussion This completion block type returns a valid person object and a nil error object if successful, or a nil person object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientBlockTypeCompletionUser)(PersonObject *person, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request for the metadata of a particular video.
 @discussion This completion block type returns a valid video object and a nil error object if successful, or a nil video object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientBlockTypeCompletionVideo)(VideoObject *video, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a settings request.
 @discussion This completion block type returns a valid settings object and a nil error object if successful, or a nil settings object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientBlockTypeCompletionSettings)(SettingsObject *settings, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request which returns a single success/failure boolean. 
 @discussion This completion block type returns a true boolean and a nil error object if successful, or a false boolean and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientBlockTypeCompletionSimple)(BOOL complete, NSError *error);

/**
 @typedef
 
 @abstract Progress block type used to report the upload progress for a multipart form request.
 @discussion This progress block type returns a CGFloat which represents the percentage of the file uploaded, an NSUInteger which represents the bytes written thus far, a long long which represents the total bytes written, and a long long which represents teh total bytes expected to write.
 */

typedef void (^WaxAPIClientBlockTypeProgressUpload)(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite);



typedef NS_ENUM(NSInteger, WaxAPIClientTagSortType){
    WaxAPIClientTagSortTypeRank = 1,
    WaxAPIClientTagSortTypeRecent,
};

typedef NS_ENUM(NSInteger, WaxAPIClientVideoActionType){
    WaxAPIClientVideoActionTypeView = 1,
    WaxAPIClientVideoActionTypeReport,
    WaxAPIClientVideoActionTypeDelete,
};


@interface WaxAPIClient : AFHTTPClient

+ (WaxAPIClient *)sharedClient;

#pragma mark - Logins
/**
 @abstract
 Creates a user account with the information passed into the method.
 
 @param username The desired username of the user signing up.
 @param fullName The full name of the user signing up.
 @param email The email address of the user signing up.
 @param passwordOrFacebookID If signing up with an email address, this is the user's desired password. If signing up with Facebook, this is that user's FacebookID.
 @param completion The completion block to be executed upon completion of the request. Will be executed regardless of whether the request is successful or not. 
 @param isFacebookLogin If the user is using Facebook to create their account, pass YES for this parameter. If the user is creating an account with their email address, pass NO for this parameter. 
 
 @discussion This method is used to create a user account on the server.
 */
-(void)createAccountWithUsername:(NSString *)username
                        fullName:(NSString *)fullName
                           email:(NSString *)email
            passwordOrFacebookID:(NSString *)passwordOrFacebookID
                 isFacebookLogin:(BOOL)isFacebookLogin
                      completion:(WaxAPIClientBlockTypeCompletionLogin)completion;
/**
 @abstract
 Logs in a user via Facebook. 
 
 @param facebookID The user's FacebookID.
 @param fullName The full name of the user signing up.
 @param email The email address of the user signing up.
 @param completion The completion block to be executed upon completion of the request. Will be executed regardless of whether the request is successful or not.
 
 @discussion This method is used to log in a user using Facebook authentication.
 */
-(void)loginWithFacebookID:(NSString *)facebookID
                  fullName:(NSString *)fullName
                     email:(NSString *)email
                completion:(WaxAPIClientBlockTypeCompletionLogin)completion;
/**
 @abstract
 Logs in a user via their username and password.
 
 @param username The desired username of the user signing up.
 @param password The user's password. 
 @param completion The completion block to be executed upon completion of the request. Will be executed regardless of whether the request is successful or not.
 
 @discussion This method is used to log in a user using their username and password.
 */
-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
              completion:(WaxAPIClientBlockTypeCompletionLogin)completion;


#pragma mark - Feeds
-(void)fetchFeedForUserID:(NSString *)personID
  feedInfiniteScrollingID:(NSNumber *)feedInfiniteScrollingID
      infiniteScrollingID:(NSNumber *)infiniteScrollingID
               completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchHomeFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID
                    feedInfiniteScrollingID:(NSNumber *)feedInfiniteScrollingID
                                 completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchMyFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID
                  feedInfiniteScrollingID:(NSNumber *)feedInfiniteScrollingID
                               completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchFeedForTag:(NSString *)tag
              sortedBy:(WaxAPIClientTagSortType)sortedBy
feedInfiniteScrollingID:(NSNumber *)feedInfiniteScrollingID
   infiniteScrollingID:(NSNumber *)infiniteScrollingID
            completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchFeedForCategory:(NSString *)category
    feedInfiniteScrollingID:(NSNumber *)feedInfiniteScrollingID
        infiniteScrollingID:(NSNumber *)infiniteScrollingID
                 completion:(WaxAPIClientBlockTypeCompletionList)completion;


#pragma mark - Users
-(void)toggleFollowUserID:(NSString *)personID
               completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)fetchProfileInformationForUserID:(NSString *)personID
                             completion:(WaxAPIClientBlockTypeCompletionUser)completion;

-(void)fetchFollowersForUserID:(NSString *)personID
           infiniteScrollingID:(NSNumber *)infiniteScrollingID
                    completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchFollowingForUserID:(NSString *)personID
           infiniteScrollingID:(NSNumber *)infiniteScrollingID
                    completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)searchForUsersWithSearchTerm:(NSString *)searchTerm
                infiniteScrollingID:(NSNumber *)infiniteScrollingID
                         completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)syncFacebookProfilePictureWithCompletion:(WaxAPIClientBlockTypeCompletionSimple)completion; 

-(void)uploadProfilePicture:(UIImage *)profilePicture
                   progress:(WaxAPIClientBlockTypeProgressUpload)progress
                 completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

#pragma mark - Social
-(void)fetchMatchedContactsOnWaxWithContacts:(NSArray *)contacts
                                  completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchMatchedFacebookFriendsOnWaxWithFacebookID:(NSString *)facebookID
                                  facebookAccessToken:(NSString *)facebookAccessToken
                                           completion:(WaxAPIClientBlockTypeCompletionList)completion;

#pragma mark - Videos
-(void)uploadVideoAtFileURL:(NSURL *)fileURL
                    videoID:(NSString *)videoID
                   progress:(WaxAPIClientBlockTypeProgressUpload)progress
                 completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)uploadThumbnailAtFileURL:(NSURL *)fileURL
                        videoID:(NSString *)videoID
                       progress:(WaxAPIClientBlockTypeProgressUpload)progress
                     completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)uploadVideoMetadataWithVideoID:(NSString *)videoID
                          videoLength:(NSNumber *)videoLength
                                  tag:(NSString *)tag
                             category:(NSString *)category
                                    //optional//
                                  lat:(NSNumber *)lat
                                  lon:(NSNumber *)lon
                     challengeVideoID:(NSString *)challengeVideoID
                    challengeVideoTag:(NSString *)challengeVideoTag
                      shareToFacebook:(BOOL)shareToFacebook
                       sharetoTwitter:(BOOL)shareToTwitter
                           completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)cancelVideoUploadingOperationWithVideoID:(NSString *)videoID;

-(void)fetchMetadataForVideoID:(NSString *)videoID
                    completion:(WaxAPIClientBlockTypeCompletionVideo)completion;

-(void)voteUpVideoID:(NSString *)videoID
            ofUser:(NSString *)personID
        completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)performAction:(WaxAPIClientVideoActionType)actionType
           onVideoID:(NSString *)videoID
          completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)fetchCategoriesWithCompletion:(WaxAPIClientBlockTypeCompletionList)completion; 

-(void)fetchDiscoverWithCompletion:(WaxAPIClientBlockTypeCompletionList)completion;

#pragma mark - Tags
-(void)searchForTagsWithSearchTerm:(NSString *)searchTerm
               infiniteScrollingID:(NSNumber *)infiniteScrollingID
                        completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)sendChallengeTag:(NSString *)tag
                videoID:(NSString *)videoID
              toUserIDs:(NSArray *)userIDs
             completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

#pragma mark - Settings
-(void)connectFacebookAccountWithFacebookID:(NSString *)facebookID
                                 completion:(WaxAPIClientBlockTypeCompletionSimple)completion;

-(void)fetchSettingsWithCompletion:(WaxAPIClientBlockTypeCompletionSettings)completion;

-(void)updateSettingsWithEmail:(NSString *)email
             fullName:(NSString *)fullName
         pushSettings:(NSDictionary *)pushSettings
           completion:(WaxAPIClientBlockTypeCompletionSettings)completion;

-(void)fetchNotificationsWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID
                                      completion:(WaxAPIClientBlockTypeCompletionList)completion;

-(void)fetchNoteCountWithCompletion:(void(^)(NSNumber *noteCount, NSError *error))completion;






@end
