//
//  WaxAPIErrorManagerService.h
//  Wax
//
//  Created by Christian Hatch on 8/15/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "AFNetworking.h"
#import <AcaciaKit/AIKErrorManagerService.h>


@class WaxAPIBugObject;


@interface WaxAPIErrorManagerService : AFHTTPClient <AIKErrorManagerService>

+ (WaxAPIErrorManagerService *)sharedInstance;



@end
