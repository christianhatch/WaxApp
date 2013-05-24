//
//  WaxDataManager.m
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxDataManager.h"

@implementation WaxDataManager

+ (WaxDataManager *)sharedManager {
    static WaxDataManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[WaxDataManager alloc] init];
    });
    return sharedID;
}

-(id)validateResponseObject:(id)responseObject{
    
    id returnObject = responseObject;
    
    if (responseObject) {
        if ([[[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:kWaxAPIJSONKey] isEqualToString:kFalseString]) {
#ifdef DEBUG
            DLog(@"LOGGED OUT DUE TO INVALID TOKEN");
#else
            [[WaxUser currentUser] logOut];
#endif
            [[AIKErrorManager sharedManager] logMessageToAllServices:[NSString stringWithFormat:@"response object failed validation and logged user out %@", responseObject]];
            
            returnObject = nil; 
            
        }else if ([[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:@"error"]){
            NSError *error = [NSError waxAPIErrorFromResponse:[[[responseObject objectForKeyOrNil:kWaxAPIJSONKey] objectAtIndexOrNil:0] objectForKeyOrNil:@"error"]];
           
            returnObject = error;
        }
    }
    return returnObject;
}

@end
