//
//  NSString+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 10/17/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSString+AcaciaKit.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSArray+AcaciaKit.h"

@implementation NSString (AcaciaKit)

+(NSString *)stringFromBool:(BOOL)abool{
    NSString *astring = abool ? @"1" : @"0";
    return astring;
}
+(BOOL)boolFromString:(NSString *)string{
    return [string isEqualToString:@"1"];
}
-(BOOL)isEmptyOrNull{
    if ([self isKindOfClass:[NSNull class]]) {
        return YES; 
    }else{
        if ([self isEqualToString:@""] || [[self lowercaseString] containsString:@"null"])
            return YES;
        else
            return NO;
    }
}
- (BOOL)containsString:(NSString *)aString{
	NSRange range = [[self lowercaseString] rangeOfString:[aString lowercaseString]];
	return range.location != NSNotFound;
}
-(BOOL)startsWithAlphabeticalLetter{
    NSArray *letters = [NSArray alphabet];
	
    BOOL isLetter = NO;
	
	for (int i = 0; i < letters.count; i++){
		if ([[[self substringToIndex:1] uppercaseString] isEqualToString:[letters objectAtIndex:i]])
		{
			isLetter = YES;
			break;
		}
	}
	return isLetter;
}
-(NSString *)removeEmoji {
#ifndef DEBUG
    __block NSMutableString* temp = [NSMutableString string];
    
    [self enumerateSubstringsInRange: NSMakeRange(0, [self length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop){
         
         const unichar hs = [substring characterAtIndex: 0];
         
         // surrogate pair
         if (0xd800 <= hs && hs <= 0xdbff) {
             const unichar ls = [substring characterAtIndex: 1];
             const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
             
             [temp appendString: (0x1d000 <= uc && uc <= 0x1f77f)? @"": substring]; // U+1D000-1F77F
             
             // non surrogate
         } else {
             [temp appendString: (0x2100 <= hs && hs <= 0x26ff)? @"": substring]; // U+2100-26FF
         }
     }];
    return temp;
#else
    return self;
#endif
}
-(NSString *)MD5{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

+(NSString *)randomDismissalMessage{
    NSArray *options = @[@"Darn!", @"Drat!", @"Dang!", @"Okay :(", @"Okay...", @"Go Away!", @"Fine!", @"Crikey!", @"Argh!", @"Bummer!", @"Shucks!", @"kthxbi", @"Ruh Roh!"];
    NSInteger index = arc4random_uniform((options.count -1));
    return [options objectAtIndex:index]; 
}

+(NSString *)prettyTimeStamp:(NSNumber *)timeStamp{
    NSInteger currentTime = [[NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970]]integerValue];
    NSInteger calculatedTime = currentTime - [timeStamp integerValue];
    if (calculatedTime < 5)
        return @"just now";
    else if (calculatedTime < 60)
        return [NSString stringWithFormat:@"%is ago", calculatedTime];
    else if (calculatedTime < 3600)
        return [NSString stringWithFormat:@"%im ago", calculatedTime/60];
    else if (calculatedTime < 86400)
        return [NSString stringWithFormat:@"%ih ago", calculatedTime/3600];
    else if (calculatedTime < 2592000)
        return [NSString stringWithFormat:@"%id ago", calculatedTime/86400];
    else if (calculatedTime < 933120000)
        return [NSString stringWithFormat:@"%imo ago", calculatedTime/2592000];
    else
        return @"-";
}








@end
