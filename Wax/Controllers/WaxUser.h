//
//  WaxUser.h
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^WaxUserCompletionBlock)(NSError *error);

@interface WaxUser : NSObject

+(WaxUser *)currentUser;

#pragma mark - User Information Getters
-(NSString *)token;
-(NSString *)userid;
-(NSString *)username;
-(NSString *)email;
-(NSString *)firstname;
-(NSString *)lastname;
-(NSString *)twitterAccountId;
-(NSString *)facebookAccountId;
-(NSString *)twitterAccountName;
//-(BOOL)hasNoFriends;

#pragma mark - User Information Setters
-(void)saveToken:(NSString *)token;
-(void)saveUserid:(NSString *)userid;
-(void)saveUserame:(NSString *)username;
-(void)saveEmail:(NSString *)email;
-(void)saveFirstname:(NSString *)firstname;
-(void)saveLastname:(NSString *)lastname;
-(void)saveTwitterAccountId:(NSString *)twitterAccountId;
-(void)saveFacebookAccountId:(NSString *)facebookAccountId;
//-(void)saveNoFriends:(BOOL)noFriends;


#pragma mark - Signup/Login/Logout/Update Pic
-(void)connectFacebookWithCompletion:(WaxUserCompletionBlock)completion;

-(void)loginWithUsername:(NSString *)username
                password:(NSString *)password
              completion:(WaxUserCompletionBlock)completion;

-(void)signupWithUsername:(NSString *)username
                 password:(NSString *)password
                 fullName:(NSString *)fullName
                    email:(NSString *)email
                  picture:(UIImage *)picture
               completion:(WaxUserCompletionBlock)completion;

-(void)updateProfilePicture:(UIImage *)profilePicture completion:(WaxUserCompletionBlock)completion;
-(void)syncFacebookProfilePictureWithCompletion:(WaxUserCompletionBlock)completion;
-(void)logOut;

#pragma mark - Utility Methods
-(BOOL)isLoggedIn;
-(BOOL)twitterAccountConnected;
-(BOOL)facebookAccountConnected;
-(BOOL)useridIsCurrentUser:(NSString *)userid;
-(void)chooseTwitterAccountWithCompletion:(WaxUserCompletionBlock)completion;



-(void)resetForInitialLaunch; 


//#ifndef RELEASE
//-(BOOL)isSuperUser;
//#endif

@end
