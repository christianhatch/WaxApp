//
//  NSString+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 4/22/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NSString+WaxKit.h"

@implementation NSString (WaxKit)

+(NSString *)videoFilePathAfterSquaring{
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"exported.mp4"];
}

+(NSString *)s3ProfilePictureKeyFromUserid:(NSString *)userid{
    return [[NSString stringWithFormat:@"%@/profile_picture.jpg", userid] lowercaseString];
}
+(NSString *)s3VideoKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink{
    return [[NSString stringWithFormat:@"%@/%@", userid, videoLink] lowercaseString];
}
+(NSString *)s3ThumbnailKeyFromUserid:(NSString *)userid andVideoLink:(NSString *)videoLink{
    return [[NSString stringWithFormat:@"%@/%@.jpg", userid, videoLink] lowercaseString];
}


//+(NSString *)apiPathWithGroup:(WaxAPIGroupType)group path:(NSString *)path{
//    return [NSString stringWithFormat:@"%@/%@", StringFromGroupType(group), path];
//}
//
//static inline NSString * StringFromGroupType(NSInteger groupType) {
//    
//    NSString *groupString = nil;
//    
//    switch (groupType) {
//        default:{
//            groupString = @"no_group_provided"; 
//        }break;
//        case 1:{
//            groupString = @"logins"; 
//        }break;
//        case 2:{
//            groupString = @"feeds"; 
//        }break;
//        case 3:{
//            groupString = @"users";
//        }break;
//        case 4:{
//            groupString = @"videos";
//        }break;
//        case 5:{
//            groupString = @"settings";
//        }break;
//    }
//    return groupString; 
//}

@end
