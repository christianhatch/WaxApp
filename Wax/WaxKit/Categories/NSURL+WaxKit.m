//
//  NSURL+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSURL+WaxKit.h"

@implementation NSURL (WaxKit)

+(NSURL *)currentVideoFileURL{
    NSURL *url = [NSURL libraryFileURLWithDirectory:@"uploads" filename:@"squared" extension:@"mp4"];
//    NSString *outputString = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"uploads/squared.mp4"]];
    
//    unlink([url.path UTF8String]); // If a file already exists, AVAssetWriter won't let you record new frames, so delete the old movie
    if ([[NSFileManager defaultManager] isDeletableFileAtPath:url.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    
    return url;
}
+(NSURL *)currentThumbnailFileURL{
    NSURL *url = [NSURL libraryFileURLWithDirectory:@"uploads" filename:@"thumbnail" extension:@"jpg"];

    if ([[NSFileManager defaultManager] isDeletableFileAtPath:url.path]) {
        [[NSFileManager defaultManager] removeItemAtURL:url error:nil];
    }
    
    return url;
}


+(NSURL *)videoUploadsDirectoryURL{
    return [NSURL libraryFileURLWithDirectory:@"uploads" filename:nil extension:nil]; 
}


+(NSURL *)streamingURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kThirdPartyCloudFrontBaseURL, userID, videoID]];
}
+(NSURL *)profilePictureURLFromUserID:(NSString *)userID{
    if ([[WaxUser currentUser] userIDIsCurrentUser:userID]) {
//        double lastChange = [[NSUserDefaults standardUserDefaults] doubleForKey:KWProfilePictureChangeDateKey];
//        double currentTime = [[NSDate date] timeIntervalSince1970];
//        double difference = (currentTime - lastChange) / 86400;
//
//        if (difference < 2) {
            return [NSURL s3ProfilePictureURLFromUserID:userID];
//        }else{
//            return [NSURL cloudFrontProfilePictureURLFromUserid:userid];
//        }
    }else{
        return [NSURL cloudFrontProfilePictureURLFromUserID:userID];
    }
}
+(NSURL *)cloudFrontProfilePictureURLFromUserID:(NSString *)userID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/profile_picture.jpg", kThirdPartyCloudFrontBaseURL, userID]];
}
+(NSURL *)s3ProfilePictureURLFromUserID:(NSString *)userID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.s3.amazonaws.com/%@/profile_picture.jpg", kThirdPartyAWSBucket, userID]];
}

+(NSURL *)videoThumbnailURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID{
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", videoID];
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@/%@", kThirdPartyCloudFrontBaseURL, userID, fileName]];
}
+(NSURL *)shareURLFromShareID:(NSString *)shareID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://wax.li/%@", shareID]];
}
+(NSURL *)categoryImageURLWithCategoryTitle:(NSString *)categoryTitle{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@.jpg", kThirdPartyCloudFrontImagesBaseURL, categoryTitle]];
}

@end
