//
//  KWContactsManager.h
//  Kiwi
//
//  Created by Christian Hatch on 3/8/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const AIKContactsNotificationAllContactsAvailable;
extern NSString *const AIKContactsNotificationMatchedContactsAvailable;

@interface AIKContactsManager : NSObject

+(AIKContactsManager *)sharedManager;

-(void)requestPermissions;
-(BOOL)checkPermissions;


@end
