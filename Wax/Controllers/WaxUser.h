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


typedef void(^WaxUserCompletionBlock)(NSError *error);

@interface WaxUser : NSObject

+(WaxUser *)currentUser;

#pragma mark - User Information Getters
-(NSString *)token;
-(NSString *)userID;

-(NSString *)username;
-(NSString *)fullName;
-(NSString *)email;

-(NSString *)facebookAccountID;
-(NSString *)twitterAccountID;
-(NSString *)twitterAccountName;

#pragma mark - User Information Setters
-(void)saveToken:(NSString *)token;
-(void)saveUserID:(NSString *)userID;

-(void)saveUserame:(NSString *)username;
-(void)saveFullName:(NSString *)fullName;
-(void)saveEmail:(NSString *)email;

-(void)saveFacebookAccountID:(NSString *)facebookAccountID;
-(void)saveTwitterAccountID:(NSString *)twitterAccountID;

#pragma mark - Signup/Login/Logout/Update Pic
-(void)createAccountWithUsername:(NSString *)username
                        fullName:(NSString *)fullName
                           email:(NSString *)email
            passwordOrFacebookID:(NSString *)passwordOrFacebookID
                      completion:(WaxUserCompletionBlock)completion;

-(void)loginWithFacebookID:(NSString *)facebookID
                  fullName:(NSString *)fullName
                     email:(NSString *)email
                completion:(WaxUserCompletionBlock)completion;

-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
              completion:(WaxUserCompletionBlock)completion;

-(void)chooseNewprofilePictureWithCompletion:(void(^)(NSError *error, UIImage *profilePicture))completion;
-(void)syncFacebookProfilePictureWithCompletion:(WaxUserCompletionBlock)completion;
-(void)logOut;

#pragma mark - Utility Methods
-(BOOL)isLoggedIn;
-(BOOL)twitterAccountConnected;
-(BOOL)facebookAccountConnected;
-(BOOL)userIDIsCurrentUser:(NSString *)userID;
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlock)completion;

-(void)resetForInitialLaunch; 


//#ifndef RELEASE
//-(BOOL)isSuperUser;
//#endif

@end
