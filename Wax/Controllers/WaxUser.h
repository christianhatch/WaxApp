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

typedef void(^WaxUserCompletionBlockTypeSimple)(NSError *error);
typedef void(^WaxUserCompletionBlockTypeProfilePicture)(NSError *error, UIImage *profilePicture);

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
                      completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)loginWithFacebookID:(NSString *)facebookID
                  fullName:(NSString *)fullName
                     email:(NSString *)email
                completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
              completion:(WaxUserCompletionBlockTypeSimple)completion;

-(void)chooseNewprofilePicture:(UIViewController *)sender completion:(WaxUserCompletionBlockTypeProfilePicture)completion;

-(void)updateProfilePictureOnServer:(UIImage *)profilePicture
                 andShowUICallbacks:(BOOL)showUICallbacks
                         completion:(WaxUserCompletionBlockTypeProfilePicture)completion;

-(void)syncFacebookProfilePictureWithCompletion:(WaxUserCompletionBlockTypeProfilePicture)completion;

-(void)logOut;

#pragma mark - Utility Methods
-(PersonObject *)personObject; 

-(BOOL)isLoggedIn;
-(BOOL)twitterAccountConnected;
-(BOOL)facebookAccountConnected;
-(BOOL)userIDIsCurrentUser:(NSString *)userID;
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlockTypeSimple)completion;

+(void)resetForInitialLaunch;


//#ifndef RELEASE
//-(BOOL)isSuperUser;
//#endif

@end
