//
//  KWFacebookConnect.h
//  Kiwi
//
//  Created by Christian Hatch on 1/28/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *const kAIKNotificationFacebookFriendsAvailable;
extern NSString *const kAIKNotificationFacebookFriendsMatchedAvailable;


@interface AIKFacebookConnect : NSObject 

+(AIKFacebookConnect *)sharedFB; 

-(BOOL)handleOpenURL:(NSURL *)url;
-(void)handleAppDidBecomeActive;

-(void)loginWithFacebook;
-(void)logoutFacebook;

-(BOOL)sessionIsActive; 
-(NSString *)accessToken;
-(BOOL)canPublish;
-(void)requestPublishPermissions;

-(void)prefetchAllFBFriends; 
-(void)prefetchKiwiFriends;

-(void)postStatus:(NSString *)status; 

-(void)searchFriendsWithString:(NSString *)searchTerm;

@property (nonatomic, strong) NSMutableArray *fbFriendsOnKiwi;
@property (nonatomic, strong) NSMutableDictionary *fbFriends;
@property (nonatomic, strong) NSMutableArray *searchResults;

@end
