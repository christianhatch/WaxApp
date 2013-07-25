//
//  WaxUser.h
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const WaxUserDidLogInNotification;
extern NSString *const WaxUserDidLogOutNotification; 

@class PersonObject;

typedef void(^WaxUserCompletionBlockTypeList)(NSMutableArray *list, NSError *error);
typedef void(^WaxUserCompletionBlockTypeSimple)(NSError *error);
typedef void(^WaxUserCompletionBlockTypeProfilePicture)(UIImage *profilePicture, NSError *error);

@interface WaxUser : NSObject

+(WaxUser *)currentUser;

#pragma mark - User Information Properties
@property (nonatomic, strong) NSString *token;
@property (nonatomic, strong) NSString *userID;

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *email;

@property (nonatomic, strong) NSString *facebookAccountID;
@property (nonatomic, strong) NSString *twitterAccountID;
@property (nonatomic, strong) NSString *twitterAccountName;

@property (nonatomic) BOOL shouldSaveVideosToCameraRoll;
@property (nonatomic, readonly) BOOL isLoggedIn;
@property (nonatomic, readonly) BOOL twitterAccountConnected;
@property (nonatomic, readonly) BOOL facebookAccountConnected;

@property (nonatomic, copy, readonly) PersonObject *personObject;

#pragma mark - Signup/Login/Logout
-(void)createAccountWithUsername:(NSString *)username
                        fullName:(NSString *)fullName
                           email:(NSString *)email
            passwordOrFacebookID:(NSString *)passwordOrFacebookID
                      completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)loginWithFacebookID:(NSString *)facebookID
                  fullName:(NSString *)fullName
                     email:(NSString *)email
                completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
              completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)logOut;

#pragma mark - Profile Picture
-(void)chooseNewprofilePictureFromViewController:(UIViewController *)sender completion:(WaxUserCompletionBlockTypeProfilePicture)completion;

-(void)updateProfilePictureOnServer:(UIImage *)profilePicture
                 andShowUICallbacks:(BOOL)showUICallbacks
                         completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)syncFacebookProfilePictureShowingUICallbacks:(BOOL)showUICallbacks withCompletion:(WaxUserCompletionBlockTypeSimple)completion;

#pragma mark - Social Accounts
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)connectFacebookWithCompletion:(WaxUserCompletionBlockTypeSimple)completion; 

-(void)fetchMatchedContactsWithCompletion:(WaxUserCompletionBlockTypeList)completion;
-(void)fetchMatchedFacebookFriendsWithCompletion:(WaxUserCompletionBlockTypeList)completion; 

#pragma mark - Utility Methods
+(BOOL)userIDIsCurrentUser:(NSString *)userID;
+(void)resetForInitialLaunch;
+(void)saveCurrentUserToVendorSolutions; 




@end
