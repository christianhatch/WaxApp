//
//  NSURL+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WaxKit)

+(NSURL *)videoUploadsDirectoryURL;
+(NSURL *)currentVideoFileURL; 
+(NSURL *)currentThumbnailFileURL;

+(NSURL *)streamingURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID;
+(NSURL *)videoThumbnailURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID;

+(NSURL *)shareURLFromShareID:(NSString *)shareID;
+(NSURL *)categoryImageURLWithCategoryTitle:(NSString *)categoryTitle;


+(NSURL *)profilePictureURLFromUserID:(NSString *)userID;
    
@end
