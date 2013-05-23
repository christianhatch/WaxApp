//
//  NSError+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NSError+WaxKit.h"
#import "WaxKit.h"

@implementation NSError (WaxKit)


-(NSError *)errorObjectFromAPIResponse:(NSDictionary *)dictionary{
    
    if (NSErrorFromCode([[dictionary objectForKeyOrNil:@"code"] intValue])) {
        return NSErrorFromCode([[dictionary objectForKeyOrNil:@"code"] intValue]);
    }else{
        return [NSError errorWithDomain:kWaxAPIErrorDomain code:[[dictionary objectForKeyOrNil:@"code"] intValue] userInfo:@{NSLocalizedDescriptionKey : [dictionary objectForKeyOrNil:@"message"] ? [dictionary objectForKeyOrNil:@"message"] : @"Unknown Error"}];
    }
}

static inline NSError * NSErrorFromCode(int errorCode) {

    NSString *errorReason = NSLocalizedString(@"Uknown Error", @"Unknown Error");
    NSString *recoverySuggestion = NSLocalizedString(@"Please try again!", @"Please try again!"); 
    
    switch (errorCode) {
        default:{
            //don't do anything :(
        }break;
        case 1001:{
            errorReason = NSLocalizedString(@"com.wax.api error=1001", @"Username and password do not match");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1001", @"Please try again!");
        }break;
        case 1002:{
            errorReason = NSLocalizedString(@"com.wax.api error=1002", @"This user used Facebook to signup");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1002", @"You must log in through Facebook");
        }break;
        case 1003:{
            errorReason = NSLocalizedString(@"com.wax.api error=1003", @"Username already exists");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1003", @"Please choose a different username");
        }break;
        case 1004:{
            errorReason = NSLocalizedString(@"com.wax.api error=1004", @"Email already exists");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1004", @"This email has already been registered with Wax. Either log in to your account, or create a new account with a different email address");
        }break;
        case 1005:{
            errorReason = NSLocalizedString(@"com.wax.api error=1005", @"Please enter valid email");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1005", @"This is not a real email address. Wax requires a valid email address or Facebook account to sign up");
        }break;
        case 1006:{
            errorReason = NSLocalizedString(@"com.wax.api error=1006", @"Username must be between 2-15 characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1006", @"Please either lengthen or shorten your username and try again");
        }break;
        case 1007:{
            errorReason = NSLocalizedString(@"com.wax.api error=1007", @"Username uses invalid characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1007", @"Usernames can only contain alphanumeric characters. Please remove any non-alphanumeric characters fromy your username and try again");
        }break;
        case 1008:{
            errorReason = NSLocalizedString(@"com.wax.api error=1008", @"Please enter full name");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1008", @"You must enter your full name to sign up with Wax");
        }break;
        case 1009:{
            errorReason = NSLocalizedString(@"com.wax.api error=1009", @"Password must be at least 6 characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1009", @"Your password is too short, it must be at least 6 characters long");
        }break;
        case 1010:{
            errorReason = NSLocalizedString(@"com.wax.api error=1010", @"There was an error creating your account");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1010", @"Sorry, we encountered and error creating your account. Please try again, and if the problem persists please email support@wax.li"); 
        }break;
    }
    return [NSError errorWithDomain:kWaxAPIErrorDomain code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorReason, NSLocalizedRecoverySuggestionErrorKey : recoverySuggestion}];
}

@end
