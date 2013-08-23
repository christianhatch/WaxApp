//
//  WaxAPIBugObject.h
//  Wax
//
//  Created by Christian Hatch on 8/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

typedef NS_ENUM(NSInteger, WaxAPIBugObjectType){
    WaxAPIBugObjectTypeAPI = 1,
    WaxAPIBugObjectTypeIOS,
    WaxAPIBugObjectTypeUserFeedback,
};

#import <Foundation/Foundation.h>

@class AFHTTPRequestOperation; 

@interface WaxAPIBugObject : NSObject

+(WaxAPIBugObject *)bugForAPIWithRequestOperation:(AFHTTPRequestOperation *)requestion error:(NSError *)error description:(NSString *)description;

+(WaxAPIBugObject *)bugForIOSWithError:(NSError *)error description:(NSString *)description;


@property (nonatomic, readonly) WaxAPIBugObjectType bugType;

@property (nonatomic, copy) NSString *bugDescription;
@property (nonatomic, copy) NSError *error;
@property (nonatomic, copy) AFHTTPRequestOperation *APIRequestOperation;


@property (nonatomic, copy, readonly) NSDictionary *dictionaryRepresentation;

@property (nonatomic, copy, readonly) NSString *userID;
@property (nonatomic, copy, readonly) NSString *username;
@property (nonatomic, copy, readonly) NSString *appVersion;
@property (nonatomic, copy, readonly) NSString *systemVersion;
  


@end
