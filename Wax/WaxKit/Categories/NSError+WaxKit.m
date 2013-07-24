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


+(NSError *)waxAPIErrorFromResponse:(NSDictionary *)response{
    
    NSString *errorReason = nil;
    NSString *recoverySuggestion = nil;
    
    int code = [[response objectForKeyOrNil:@"code"] intValue];
    
    switch (code) {
        default:{
            errorReason = [response objectForKey:@"message" orDefaultValue:NSLocalizedString(@"Unknown Error", @"Unknown Error")];
            recoverySuggestion = NSLocalizedString(@"Unknown Error", @"Unknown Error");
        }break;
    //1000s
        case 1001:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1001", @"Username and password do not match");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1001", @"Please try again!");
        }break;
        case 1002:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1002", @"This user used Facebook to signup");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1002", @"You must log in through Facebook");
        }break;
        case 1003:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1003", @"Username already exists");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1003", @"Please choose a different username");
        }break;
        case 1004:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1004", @"Email already exists");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1004", @"This email has already been registered with Wax. Either log in to your account, or create a new account with a different email address");
        }break;
        case 1005:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1005", @"Please enter valid email");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1005", @"This is not a real email address. Wax requires a valid email address or Facebook account to sign up");
        }break;
        case 1006:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1006", @"Username must be between 1-15 characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1006", @"Please either lengthen or shorten your username and try again");
        }break;
        case 1007:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1007", @"Username uses invalid characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1007", @"Usernames can only contain alphanumeric characters. Please remove any non-alphanumeric characters fromy your username and try again");
        }break;
        case 1008:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1008", @"Please enter full name");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1008", @"You must enter your full name to sign up with Wax");
        }break;
        case 1009:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1009", @"Password must be at least 6 characters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1009", @"Your password is too short, it must be at least 6 characters long");
        }break;
        case 1010:{
            errorReason = NSLocalizedString(@"com.wax.api.error=1010", @"No Account");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=1010", @"It looks like you haven't yet created a Wax account. You can sign up by simply choosing a username to use on Wax");
        }break;
    //3000s
        case 3001:{
            errorReason = NSLocalizedString(@"com.wax.api.error=3001", @"Upload Failed");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=3001", @"The file upload failed. Please try again!");
        }break;
        case 3002:{
            errorReason = NSLocalizedString(@"com.wax.api.error=3002", @"No Account");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=3002", @"The file upload failed. Please try again!");
        }break;
    //9000s
        case 9001:{
            errorReason = NSLocalizedString(@"com.wax.api.error=9001", @"Incorrect Credentials");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=9001", @"Please try again, and if the problem persists please email dev@wax.li");
        }break;
        case 9002:{
            errorReason = NSLocalizedString(@"com.wax.api.error=9002", @"Script failed");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=9002", @"Please try again, and if the problem persists please email dev@wax.li");
        }break;
        case 9003:{
            errorReason = NSLocalizedString(@"com.wax.api.error=9003", @"User already performed action");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=9003", @"Please try again, and if the problem persists please email dev@wax.li");
        }break;
        case 9004:{
            errorReason = NSLocalizedString(@"com.wax.api.error=9004", @"User does not have permission to perform action");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=9004", @"Please try again, and if the problem persists please email dev@wax.li");
        }break;
        case 9005:{
            errorReason = NSLocalizedString(@"com.wax.api.error=9005", @"Missing post parameters");
            recoverySuggestion = NSLocalizedString(@"com.wax.api.suggestion=9005", @"Please try again, and if the problem persists please email dev@wax.li");
        }break;
    }
    return [NSError errorWithDomain:kWaxAPIErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey : errorReason, NSLocalizedRecoverySuggestionErrorKey : recoverySuggestion}];

}

+(BOOL)errorIsEqualToNSURLErrorRequestCanceled:(NSError *)error{
    return ([error.domain isEqualToString:NSURLErrorDomain] && error.code == -999);
}




@end
