//
//  UploadObject.h
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const CurrentUploadObjectUserDefaultsKey;

@class CLLocation;

enum{
    UploadStatusWaitingForData = 0,
    UploadStatusWaiting,
    UploadStatusInProgress,
    UploadStatusCompleted,
    UploadStatusFailed,
};
typedef NSInteger UploadStatus;

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

@property (nonatomic, assign) UploadStatus status;
@property (nonatomic, assign) UploadStatus videoStatus;
@property (nonatomic, assign) UploadStatus thumbnailStatus;
@property (nonatomic, assign) UploadStatus metadataStatus;

@property (nonatomic, assign) BOOL shareToFacebook;
@property (nonatomic, assign) BOOL shareToTwitter;
@property (nonatomic, assign) BOOL shareLocation;

@property (nonatomic, copy) NSString *videoID;
@property (nonatomic, copy) NSString *tag;
@property (nonatomic, copy) NSString *category;

@property (nonatomic, copy) NSNumber *videoLength; 
@property (nonatomic, copy) NSNumber *lat;
@property (nonatomic, copy) NSNumber *lon;

@property (nonatomic, copy) NSURL *videoFileURL;
@property (nonatomic, copy) NSURL *thumbnailFileURL; 

-(void)saveToNSUserDefaults;
-(void)removeFromNSUserDefaults;

-(id)initFromNSUserDefaults;

-(id)initWithVideoFileURL:(NSURL *)videoFileURL;













@end
