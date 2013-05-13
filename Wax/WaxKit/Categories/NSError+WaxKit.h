//
//  NSError+WaxKit.h
//  Wax
//
//  Created by Christian Hatch on 5/12/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (WaxKit)

-(NSError *)errorObjectFromAPIResponse:(NSDictionary *)dictionary;



@end
