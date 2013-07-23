//
//  NSURL+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "NSURL+WaxKit.h"

@implementation NSURL (WaxKit)

+(NSURL *)videoUploadsDirectoryURL{
    return [NSURL libraryFileURLWithDirectory:@"uploads" filename:nil extension:nil];
}
+(NSURL *)currentVideoFileURL{
    NSURL *url = [NSURL libraryFileURLWithDirectory:@"uploads" filename:@"squared" extension:@"mp4"];    
    return url;
}
+(NSURL *)currentThumbnailFileURL{
    NSURL *url = [NSURL libraryFileURLWithDirectory:@"uploads" filename:@"thumbnail" extension:@"jpg"];
    return url;
}
+(NSURL *)currentMetaDataFileURL{
    NSURL *url = [NSURL libraryFileURLWithDirectory:@"uploads" filename:@"metadata" extension:@"plist"];
    
    return url; 
}



+(NSURL *)thumbnailURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/thumbnail/%@/%@", [NSURL baseFileString], userID, videoID]];
}
+(NSURL *)streamingURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/video/%@/%@", [NSURL baseFileString], userID, videoID]];
}

+(NSURL *)shareURLFromShareID:(NSString *)shareID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://wax.li/%@", shareID]];
}
+(NSURL *)categoryImageURLWithCategoryTitle:(NSString *)categoryTitle{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/category_image/%@", [NSURL baseFileString], categoryTitle]];
}

+(NSURL *)profilePictureURLFromUserID:(NSString *)userID{
    if ([WaxUser userIDIsCurrentUser:userID]) {
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


#pragma mark - Internal Methods
+(NSURL *)cloudFrontProfilePictureURLFromUserID:(NSString *)userID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/profile_picture/%@", [NSURL baseFileString], userID]];
}
+(NSURL *)s3ProfilePictureURLFromUserID:(NSString *)userID{
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://%@.s3.amazonaws.com/%@/profile_picture.jpg", kThirdPartyAWSBucket, userID]];
}

+(NSString *)baseFileString{
    return [NSString stringWithFormat:@"%@files", kWaxAPIBaseURL];
}




@end
