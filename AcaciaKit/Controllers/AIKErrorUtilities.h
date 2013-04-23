//
//  AIKErrorUtilities.h
//  Kiwi
//
//  Created by Christian Hatch on 10/22/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AIKErrorUtilities : NSObject <UIAlertViewDelegate>

+(AIKErrorUtilities *)sharedUtilities;

-(void)didCrash;
-(void)didEncounterError:(NSString *)description; 

-(void)logMessageToAllServices:(NSString *)message;
-(void)logErrorWithMessage:(NSString *)message error:(NSError *)error;
-(void)logErrorWithMessage:(NSString *)message error:(NSError *)error andShowAlertWithButtonHandler:(void (^)(void))handler;
-(void)logExceptionWithMessage:(NSString *)message exception:(NSException *)exception; 

@end
