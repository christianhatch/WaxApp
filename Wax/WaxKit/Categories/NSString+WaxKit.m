//
//  NSString+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NSString+WaxKit.h"

@implementation NSString (WaxKit)

+(NSString *)sharingTextFromCompetitionTag:(NSString *)tag andShareURL:(NSURL *)shareURL{
    return [NSString stringWithFormat:NSLocalizedString(@"I challenge you to do %@ on Wax!\n%@\n\nDon't have Wax? Get it: %@", @"send challenge via text"), tag, shareURL, kWaxItunesStoreURL];
}

@end
