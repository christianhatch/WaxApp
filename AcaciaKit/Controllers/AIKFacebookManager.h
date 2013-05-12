//
//  KWFacebookConnect.h
//  Kiwi
//
//  Created by Christian Hatch on 1/28/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AIKFacebookNotificationFriendsAvailable;
extern NSString *const AIKFacebookNotificationMatchedFriendsAvailable;
extern NSString *const AIKFacebookNotificationDidLogIn;
extern NSString *const AIKFacebookNotificationDidLogOut;


@interface AIKFacebookManager : NSObject 

+(AIKFacebookManager *)sharedManager; 

-(BOOL)handleOpenURL:(NSURL *)url;
-(void)handleAppDidBecomeActive;

-(void)loginWithFacebook;
-(void)logoutFacebook;

-(BOOL)sessionIsActive; 
-(NSString *)accessToken;

-(BOOL)canPublish;
-(void)requestPublishPermissions;


@end
