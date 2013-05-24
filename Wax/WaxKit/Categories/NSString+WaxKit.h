//
//  NSString+WaxKit.h
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>

//enum{
//    WaxAPIGroupTypeLogins = 1,
//    WaxAPIGroupTypeFeeds,
//    WaxAPIGroupTypeUsers,
//    WaxAPIGroupTypeVideos,
//    WaxAPIGroupTypeSettings,
//};
//typedef NSInteger WaxAPIGroupType;


@interface NSString (WaxKit)

+(NSString *)videoFilePathAfterSquaring;
+(NSString *)s3ProfilePictureKeyFromUserid:(NSString *)userid;
+(NSString *)s3VideoKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink;
+(NSString *)s3ThumbnailKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink;

//+(NSString *)apiPathWithGroup:(WaxAPIGroupType)group path:(NSString *)path;

@end
