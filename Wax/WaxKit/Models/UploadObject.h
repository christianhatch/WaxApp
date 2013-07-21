//
//  UploadObject.h
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UploadStatus){
    UploadStatusWaitingForData = 0,
    UploadStatusWaiting,
    UploadStatusInProgress,
    UploadStatusCompleted,
    UploadStatusFailed,
};

static inline NSString * StringFromUploadStatus(UploadStatus uStatus) {
    switch (uStatus) {
        case UploadStatusCompleted:
            return @"Completed";
            break;
        case UploadStatusFailed:
            return @"Failed";
            break;
        case UploadStatusInProgress:
            return @"In Progress";
            break;
        case UploadStatusWaiting:
            return @"Waiting";
            break;
        case UploadStatusWaitingForData:
            return @"Waiting For Data";
            break;
        default:
            return @"";
            break;
    }
}

@interface UploadObject : NSObject

@property (nonatomic) UploadStatus status;
@property (nonatomic) UploadStatus videoStatus;
@property (nonatomic) UploadStatus thumbnailStatus;
@property (nonatomic) UploadStatus metadataStatus;

@property (nonatomic) BOOL shareToFacebook;
@property (nonatomic) BOOL shareToTwitter;
@property (nonatomic) BOOL shareLocation;

@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSNumber *videoLength; 
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lon;

@property (nonatomic, copy) NSURL *videoFileURL;
@property (nonatomic, copy) NSURL *thumbnailFileURL; 

-(void)saveToDisk;
-(void)removeFromDisk;

-(instancetype)initFromDisk;
-(instancetype)initWithVideoFileURL:(NSURL *)videoFileURL;













@end
