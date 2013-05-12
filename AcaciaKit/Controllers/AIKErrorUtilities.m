//
//  AIKErrorUtilities.m
//  Kiwi
//
//  Created by Christian Hatch on 10/22/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AIKErrorUtilities.h"
#import "TestFlight.h"
#import "Flurry.h"
#import <Crashlytics/Crashlytics.h>

@implementation AIKErrorUtilities

+ (AIKErrorUtilities *)sharedUtilities{
    static AIKErrorUtilities *_sharedUtlities = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedUtlities = [[AIKErrorUtilities alloc] init];
    });
    return _sharedUtlities;
}
-(void)didEncounterError:(NSString *)description{
    [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:description];
    RIButtonItem *cancel = [RIButtonItem item];
    cancel.label = @"No Thanks";
    cancel.action = nil;
    
    RIButtonItem *feedback = [RIButtonItem item];
    feedback.label = @"Sure!";
    feedback.action = ^{
        [TestFlight openFeedbackView]; 
    };

    UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Kiwi Encountered Internal Error! :(" message:@"Could you please tell us exactly what you were doing before this message appeared?" cancelButtonItem:cancel otherButtonItems:feedback, nil]; 
    [error show];
}
-(void)didCrash{
    RIButtonItem *cancel = [RIButtonItem item];
    cancel.label = @"No Thanks";
    cancel.action = nil;
    
    RIButtonItem *feedback = [RIButtonItem item]; 
    feedback.label = @"Sure!";
    feedback.action = ^{
        [TestFlight openFeedbackView];
    };
    UIAlertView *crashed = [[UIAlertView alloc] initWithTitle:@"Oh no! It looks like Kiwi crashed! :(" message:@"Could you please tell us exactly what you were doing before it crashed?" cancelButtonItem:cancel otherButtonItems:feedback, nil];
    [crashed show];
}
-(void)logMessageToAllServices:(NSString *)message{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"%@", message]];
    CLSLog(@"Logged Message: %@", message);
    [Flurry logEvent:message];
    DLog(@"Log message to all services \"%@\"", message);
}
-(void)logErrorWithMessage:(NSString *)message error:(NSError *)error{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Logged error. My message: %@ Error description: %@", message, error.localizedDescription]];
    [Flurry logError:message message:error.localizedDescription error:error];
    CLSLog(@"Logged error. My message: %@ Error description: %@", message, error.localizedDescription);
    DLog(@"Error. My message: \"%@\", Error description %@",message, error.localizedDescription);
}
-(void)logExceptionWithMessage:(NSString *)message exception:(NSException *)exception{
    [TestFlight passCheckpoint:[NSString stringWithFormat:@"Logged exception. My message: %@ Exception description: %@", message, exception.reason]];
    [Flurry logError:message message:exception.reason exception:exception];
    CLSLog(@"Logged exception. My message: %@ Exception description: %@", message, exception.reason);
    DLog(@"Exception. My message: \"%@\", Exception description %@",message, exception.reason);
}

-(void)logErrorWithMessage:(NSString *)message error:(NSError *)error andShowAlertWithButtonHandler:(void (^)(void))handler{
    [self logErrorWithMessage:message error:error];
   
    RIButtonItem *cancel = [RIButtonItem randomDismissalButton];
    cancel.action = handler;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:error.localizedDescription cancelButtonItem:nil otherButtonItems:cancel, nil];
    [alert show];
}




@end
