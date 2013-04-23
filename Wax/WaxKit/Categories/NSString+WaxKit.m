//
//  NSString+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NSString+WaxKit.h"

@implementation NSString (WaxKit)

+(NSString *)s3ProfilePictureKeyFromUserid:(NSString *)userid{
    return [[NSString stringWithFormat:@"userinfo-%@/profilepicture", userid] lowercaseString];
}

+(NSString *)s3VideoKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink{
    return [[NSString stringWithFormat:@"userinfo-%@/%@", userid, videoLink] lowercaseString];
}

+(NSString *)s3ThumbnailKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink{
    return [[NSString stringWithFormat:@"userinfo-%@/%@.jpg", userid, videoLink] lowercaseString];
}

+(NSString *)videoFilePathAfterSquaring{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"exported.mp4"];
}


@end
