//
//  NSDictionary+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AcaciaKit)

-(id)objectForKeyNotNull:(id)key;
-(BOOL)isEmptyOrNull;

@end
