//
//  SettingsObject.m
//  Wax
//
//  Created by Christian Hatch on 5/23/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


NSString *const WaxAPIPushSettingsKeyNewFollower = @"followers";
NSString *const WaxAPIPushSettingsKeyNewTitle = @"titles";
NSString *const WaxAPIPushSettingsKeyChallengeAccepted = @"challenges"; 

#import "SettingsObject.h"

@implementation SettingsObject
@synthesize facebookID = _facebookID;
@synthesize pushSettings = _pushSettings;

@synthesize username = _username;
@synthesize fullName = _fullName;
@synthesize email = _email;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.facebookID = [dictionary objectForKey:@"facebookid" orDefaultValue:@""];
        self.pushSettings = [dictionary objectForKey:@"pushsettings" orDefaultValue:[NSDictionary dictionary]];
        
        self.username = [dictionary objectForKey:@"username" orDefaultValue:@""];
        self.fullName = [dictionary objectForKey:@"name" orDefaultValue:@""];
        self.email = [dictionary objectForKey:@"email" orDefaultValue:@""];
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"SettingsObject Description: FacebookID=%@ PushSettings=%@ Username=%@ FullName=%@ Email=%@ ", self.facebookID, self.pushSettings, self.username, self.fullName, self.email];
    return descrippy;
}

@end
