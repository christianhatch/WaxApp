//
//  WaxUser.h
//  Kiwi
//
//  Created by Christian Hatch on 1/21/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WaxUser : NSObject

+(WaxUser *)currentUser;

-(NSString *)token;
-(NSString *)userid;
-(NSString *)username;
-(NSString *)email;
-(NSString *)firstname;
-(NSString *)lastname;
-(NSString *)twitterAccountId;
-(NSString *)facebookAccountId;
-(NSString *)twitterAccountName;
-(BOOL)isPrivate;
-(BOOL)hasNoFriends;

-(BOOL)twitterAccountSaved;
-(BOOL)facebookAccountSaved;

-(void)saveToken:(NSString *)token;
-(void)saveUserid:(NSString *)userid;
-(void)saveUserame:(NSString *)username;
-(void)saveEmail:(NSString *)email;
-(void)saveFirstname:(NSString *)firstname;
-(void)saveLastname:(NSString *)lastname;
-(void)saveTwitterAccountId:(NSString *)twitterAccountId;
-(void)saveFacebookAccountId:(NSString *)facebookAccountId;
-(void)savePrivacyPrivate:(BOOL)privateProfile;
-(void)saveNoFriends:(BOOL)noFriends;

-(void)logInWithResponse:(NSDictionary *)response;
-(void)signedUpWithResponse:(NSDictionary *)response andProfilePic:(UIImage *)profilePicture;
-(void)logOut:(BOOL)fromTokenError;
-(void)uploadNewProfilePicture:(UIImage *)profilePicture; 
-(void)fetchFacebookProfilePictureAndShowUser:(BOOL)showUser;

-(BOOL)useridIsCurrentUser:(NSString *)userid;

-(void)authorizeTwitterFromSwitch:(UISwitch *)toggle;
-(void)chooseNewTwitterAccount;

-(void)resetForInitialLaunch; 

-(BOOL)isLoggedIn;

#ifndef RELEASE
-(BOOL)isSuperUser;
#endif

@end
