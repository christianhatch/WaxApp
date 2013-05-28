//
//  LoginObject.m
//  Wax
//
//  Created by Christian Hatch on 5/23/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "LoginObject.h"

@implementation LoginObject
@synthesize userID = _userID;
@synthesize token = _token;
@synthesize facebookID = _facebookID;

@synthesize username = _username;
@synthesize fullName = _fullName;
@synthesize email = _email;

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.userID = [dictionary objectForKey:@"userid" orDefaultValue:@""];
        self.token = [dictionary objectForKey:@"token" orDefaultValue:@""];
        self.facebookID = [dictionary objectForKey:@"facebookid" orDefaultValue:@""];
        
        self.username = [dictionary objectForKey:@"username" orDefaultValue:@""];
        self.fullName = [dictionary objectForKey:@"name" orDefaultValue:@""];
        self.email = [dictionary objectForKey:@"email" orDefaultValue:@""];
    }
    return self;
}

-(NSString *)description{
    NSString *descrippy = [NSString stringWithFormat:@"LoginObject Description: UserID=%@ Token=%@ FacebookID=%@ Username=%@ FullName=%@ Email=%@", self.userID, self.token, self.facebookID, self.username, self.fullName, self.email];
    return descrippy;
}

@end
