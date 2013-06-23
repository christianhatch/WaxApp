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
+(NSURL *)currentMetaDataFileURL; 

+(NSURL *)thumbnailURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID;
+(NSURL *)streamingURLFromUserID:(NSString *)userID andVideoID:(NSString *)videoID;

+(NSURL *)shareURLFromShareID:(NSString *)shareID;

+(NSURL *)profilePictureURLFromUserID:(NSString *)userID;

+(NSURL *)categoryImageURLWithCategoryTitle:(NSString *)categoryTitle;


    
@end
