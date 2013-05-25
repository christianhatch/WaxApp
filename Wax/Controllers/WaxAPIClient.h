//
//  WaxAPIClient.h
//  Wax
//
//  Created by Christian Michael Hatch on 6/13/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h> 

@class LoginObject, PersonObject, VideoObject, SettingsObject, CLLocation;


/**
 @typedef
 
 @abstract Completion block type used when returning the results of a login request.
 @discussion This completion block type returns a valid login object and a nil error object if successful, or a nil login object and a valid error object if unsuccessful. 
 */
typedef void(^WaxAPIClientCompletionBlockTypeLogin)(LoginObject *loginResponse, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request that returns an array of model objects
 @discussion This completion block type returns a mutable array of model objects appropriate to the request and a nil error object if successful, or a nil mutable array and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeList)(NSMutableArray *list, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request for the profile information of a particular user.
 @discussion This completion block type returns a valid person object and a nil error object if successful, or a nil person object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeUser)(PersonObject *person, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request for the metadata of a particular video.
 @discussion This completion block type returns a valid video object and a nil error object if successful, or a nil video object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeVideo)(VideoObject *person, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a settings request.
 @discussion This completion block type returns a valid settings object and a nil error object if successful, or a nil settings object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeSettings)(SettingsObject *settings, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a video metadata upload request.
 @discussion This completion block type returns a valid login object and a nil error object if successful, or a nil login object and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeVideoUpload)(BOOL complete, NSString *shareID, NSError *error);

/**
 @typedef
 
 @abstract Completion block type used when returning the results of a request which returns a single success/failure boolean. 
 @discussion This completion block type returns a true boolean and a nil error object if successful, or a false boolean and a valid error object if unsuccessful.
 */
typedef void(^WaxAPIClientCompletionBlockTypeSimple)(BOOL complete, NSError *error);

enum{
    WaxAPIClientTagSortTypeRank,
    WaxAPIClientTagSortTypeRecent,
};
typedef NSInteger WaxAPIClientTagSortType;

enum{
    WaxAPIClientVideoActionTypeView,
    WaxAPIClientVideoActionTypeReport,
    WaxAPIClientVideoActionTypeDelete,
};
typedef NSInteger WaxAPIClientVideoActionType;


@interface WaxAPIClient : AFHTTPClient //<AmazonServiceRequestDelegate>

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
 
 @discussion This method is used to create a user account on the server.
 */
-(void)createAccountWithUsername:(NSString *)username
                        fullName:(NSString *)fullName
                           email:(NSString *)email
            passwordOrFacebookID:(NSString *)passwordOrFacebookID
                      completion:(WaxAPIClientCompletionBlockTypeLogin)completion;
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
                completion:(WaxAPIClientCompletionBlockTypeLogin)completion;
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
              completion:(WaxAPIClientCompletionBlockTypeLogin)completion;


#pragma mark - Feeds
-(void)fetchFeedForUser:(NSString *)personID
    infiniteScrollingID:(NSNumber *)infiniteScrollingID
             completion:(WaxAPIClientCompletionBlockTypeList)completion;

-(void)fetchHomeFeedWithInfiniteScrollingID:(NSNumber *)infiniteScrollingID
                                 completion:(WaxAPIClientCompletionBlockTypeList)completion;

-(void)fetchFeedForTag:(NSString *)tag
              sortedBy:(WaxAPIClientTagSortType)sortedBy
   infiniteScrollingID:(NSNumber *)infiniteScrollingID
            completion:(WaxAPIClientCompletionBlockTypeList)completion;


#pragma mark - Users
-(void)toggleFollowUser:(NSString *)personID
             completion:(WaxAPIClientCompletionBlockTypeSimple)completion;

-(void)fetchProfileInformationForUser:(NSString *)personID
                           completion:(WaxAPIClientCompletionBlockTypeUser)completion;

-(void)fetchFollowersForUser:(NSString *)personID
         infiniteScrollingID:(NSNumber *)infiniteScrollingID
                  completion:(WaxAPIClientCompletionBlockTypeList)completion;

-(void)fetchFollowingForUser:(NSString *)personID
         infiniteScrollingID:(NSNumber *)infiniteScrollingID
                  completion:(WaxAPIClientCompletionBlockTypeList)completion;

-(void)searchForUser:(NSString *)searchTerm
 infiniteScrollingID:(NSNumber *)infiniteScrollingID
          completion:(WaxAPIClientCompletionBlockTypeList)completion;

-(void)syncFacebookProfilePictureWithCompletion:(WaxAPIClientCompletionBlockTypeSimple)completion; 


#pragma mark - Videos
-(void)uploadVideoMetadata:(NSString *)videoLink
               videoLength:(NSNumber *)videoLength
                       tag:(NSString *)tag
                  category:(NSString *)category
                   caption:(NSString *)caption
                  location:(CLLocation *)location
                completion:(WaxAPIClientCompletionBlockTypeVideoUpload)completion;

-(void)fetchMetadataForVideo:(NSString *)videoID
                  completion:(WaxAPIClientCompletionBlockTypeVideo)completion;

-(void)voteUpVideo:(NSString *)videoID
            ofUser:(NSString *)personID
        completion:(WaxAPIClientCompletionBlockTypeSimple)completion;

-(void)performAction:(WaxAPIClientVideoActionType)actionType
           onVideoID:(NSString *)videoID
          completion:(WaxAPIClientCompletionBlockTypeSimple)completion;


#pragma mark - Settings
-(void)fetchSettingsWithCompletion:(WaxAPIClientCompletionBlockTypeSettings)completion;

-(void)updateSettings:(NSString *)email
             fullName:(NSString *)fullName
         pushSettings:(NSDictionary *)pushSettings
           completion:(WaxAPIClientCompletionBlockTypeSettings)completion;




#pragma mark - Internal Methods
-(void)processResponseObject:(id)responseObject forArrayOfModelClass:(Class)modelClass withCompletionBlock:(void (^)(NSMutableArray *processedResponse, NSError *error))completion;


/*
#ifndef RELEASE
-(void)deleteVideoWithFeedItem:(FeedObject *)feedItem andSuperUserPrivelages:(BOOL)admin; 
#endif
*/

@end
