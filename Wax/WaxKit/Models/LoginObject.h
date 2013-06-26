//
//  LoginObject.h
//  Wax
//
//  Created by Christian Hatch on 5/23/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "ModelObject.h"

@interface LoginObject : ModelObject

@property (nonatomic, copy) NSString *userID;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *facebookID;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *fullName;
@property (nonatomic, copy) NSString *email;

@end
