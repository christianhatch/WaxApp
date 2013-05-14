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
    if (responseObject) {
        if ([[[[responseObject objectForKeyNotNull:kWaxAPIJSONKey] objectAtIndexNotNull:0] objectForKeyNotNull:kWaxAPIJSONKey] isEqualToString:@"false"]) {
#ifdef DEBUG
            DLog(@"LOGGED OUT DUE TO INVALID TOKEN");
#else
            [[WaxUser currentUser] logOut:YES];
#endif
            [[AIKErrorUtilities sharedUtilities] logMessageToAllServices:[NSString stringWithFormat:@"response object failed validation and logged user out %@", responseObject]];
            return nil;
        }else if ([[[[responseObject objectForKeyNotNull:kWaxAPIJSONKey] objectAtIndexNotNull:0] objectForKeyNotNull:@"error"] integerValue] == 103){
            return nil;
        }else{
            return responseObject;
        }
    }else{
        return responseObject;
    }
}

@end
