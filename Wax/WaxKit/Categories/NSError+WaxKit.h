//
//  NSError+WaxKit.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


typedef NS_ENUM(NSInteger, WaxAPIError){
    
    //general
    WaxAPIErrorIncorrectCredentials = 9001,
    WaxAPIErrorScriptFailed = 9002,
    WaxAPIErrorUserAlreadyPerformedAction = 9003,
    WaxAPIErrorNoPermission = 9004,
    WaxAPIErrorMissingPostParameters = 9005,
    
    //login
    WaxAPIErrorLoginUsernameAndPasswordNoMatch = 1001,
    WaxAPIErrorLoginNoPasswordFacebookOnlyAccount = 1002,
    
    //signup
    WaxAPIErrorRegistrationUsernameTaken = 1003,
    WaxAPIErrorRegistrationEmailTaken = 1004,
    WaxAPIErrorRegistrationEmailInvalid = 1005,
    WaxAPIErrorRegistrationUsernameTooLongOrTooShort = 1006,
    WaxAPIErrorRegistrationUsernameUsesInvalidCharacters = 1007,
    WaxAPIErrorRegistrationNoFullName = 1008,
    WaxAPIErrorRegistrationPasswordTooLongOrTooShort = 1009,
    
    //facebook
    WaxAPIErrorRegistrationMustCreateUsernameForFacebookSignup = 1010,
    
    //uploads
    WaxAPIErrorUploadFilePostFailed = 3001,
    WaxAPIErrorUploadFileMoveToS3Failed = 3002,
    
};



#import <Foundation/Foundation.h>

@interface NSError (WaxKit)

+(NSError *)waxAPIErrorFromResponse:(NSDictionary *)response;

+(BOOL)errorIsEqualToNSURLErrorRequestCanceled:(NSError *)error;

@end
