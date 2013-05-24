//
//  SettingsObject.h
//  Wax
//
//  Created by Christian Hatch on 5/23/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

extern NSString *const WaxAPIPushSettingsKeyNewFollower;
extern NSString *const WaxAPIPushSettingsKeyNewTitle;
extern NSString *const WaxAPIPushSettingsKeyChallengeAccepted;

@interface SettingsObject : ModelObject

@property (nonatomic, copy) NSString *facebookID;
@property (nonatomic, copy) NSDictionary *pushSettings;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;


@end
