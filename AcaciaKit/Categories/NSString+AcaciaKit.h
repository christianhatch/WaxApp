//
//  NSString+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AcaciaKit)

-(BOOL)isEmptyOrNull;
-(NSString *)removeEmoji;
-(NSString *)MD5;
+(NSString *)stringFromBool:(BOOL)abool;
+(BOOL)boolFromString:(NSString *)string; 

-(BOOL)startsWithAlphabeticalLetter;

+(NSString *)randomDismissalMessage;
+(NSString *)prettyTimeStamp:(NSNumber *)timeStamp;



@end
