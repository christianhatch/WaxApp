//
//  NSURL+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSURL+WaxKit.h"

@implementation NSURL (WaxKit)

+(NSURL *)videoURLForSquaring{
    NSString *outputString = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"exported.mp4"]];
    unlink([outputString UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    return [NSURL fileURLWithPath:outputString];
}
+(NSURL *)streamingURLFromUserid:(NSString *)userid videoLink:(NSString *)videoLink{
//    return [NSURL URLWithString:[NSString stringWithFormat:@"http://d3kr9whjwodb8q.cloudfront.net/%@/%@", userid, videoLink]];
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://stream.kiwi.ly/vods3/_definst_/mp4:amazons3/%@/%@/%@/playlist.m3u8", kThirdPartyAWSBucket, userid, videoLink]];
}
+(NSURL *)profilePictureURLFromUserid:(NSString *)userid{    
    if ([[WaxUser currentUser] userIDIsCurrentUser:userid]) {
//        double lastChange = [[NSUserDefaults standardUserDefaults] doubleForKey:KWProfilePictureChangeDateKey];
//        double currentTime = [[NSDate date] timeIntervalSince1970];
//        double difference = (currentTime - lastChange) / 86400;
//
//        if (difference < 2) {
            return [NSURL s3ProfilePictureURLFromUserid:userid];
//        }else{
//            return [NSURL cloudFrontProfilePictureURLFromUserid:userid];
//        }
    }else{
        return [NSURL cloudFrontProfilePictureURLFromUserid:userid];
    }
}
+(NSURL *)cloudFrontProfilePictureURLFromUserid:(NSString *)userid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://d3kr9whjwodb8q.cloudfront.net/%@/profile_picture.jpg", userid]];
}
+(NSURL *)s3ProfilePictureURLFromUserid:(NSString *)userid{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.s3.amazonaws.com/%@/profile_picture.jpg", kThirdPartyAWSBucket, userid]];
}

+(NSURL *)videoThumbnailURLFromUserid:(NSString *)userid videoLink:(NSString *)videoLink{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", videoLink];
    return [NSURL URLWithString:[NSString stringWithFormat:@"http://d3kr9whjwodb8q.cloudfront.net/%@/%@", userid, fileName]];
}
+(NSURL *)shareURLFromShareId:(NSString *)shareId{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://wax.li/%@", shareId]];
}

@end
