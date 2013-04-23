//
//  KWContactsManager.h
//  Kiwi
//
//  Created by Christian Hatch on 3/8/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

#define KWContactsAvailableNotification              @"contactsAvailable"
#define KWContactsKiwiFriendsAvailableNotification   @"kiwiFriendsAvailable"


@interface AIKContactsManager : NSObject

+(AIKContactsManager *)sharedManager;

+(BOOL)isAuthorized;

+(BOOL)checkAuthorization;

-(void)searchContactsWithString:(NSString *)searchTerm;

-(void)prefetchKiwiFriends;
-(void)parseAndSortContacts; 

@property (nonatomic, strong) NSMutableArray *allContacts;
@property (nonatomic, strong) NSMutableDictionary *sortedContacts;
@property (nonatomic, strong) NSMutableArray *searchResults;
@property (nonatomic, strong) NSMutableArray *matchedContacts;

@property (nonatomic, assign) BOOL noMatchedContacts;

@end
