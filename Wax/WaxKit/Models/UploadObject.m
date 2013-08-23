//
//  UploadObject.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#import "UploadObject.h"


@implementation UploadObject
@synthesize status = _status, videoStatus = _videoStatus, thumbnailStatus = _thumbnailStatus, metadataStatus = _metadataStatus, shareToFacebook = _shareToFacebook, shareToTwitter = _shareToTwitter, shareLocation = _shareLocation, videoID = _videoID, lat = _lat, lon = _lon, tag = _tag, category = _category, videoLength = _videoLength, videoFileURL = _videoFileURL, thumbnailFileURL = _thumbnailFileURL;

#pragma mark - Alloc & Init
-(instancetype)initWithVideoFileURL:(NSURL *)videoFileURL{
    
    NSParameterAssert(videoFileURL);
    
    self = [super init];
    if (self) {
        _videoFileURL = videoFileURL;
        _videoID = [[NSString stringWithFormat:@"%f%i", [[NSDate date] timeIntervalSince1970], arc4random_uniform(5000000)] MD5];
        
        _status = UploadStatusWaitingForData;
        _videoStatus = UploadStatusWaitingForData;
        _thumbnailStatus = UploadStatusWaitingForData;
        _metadataStatus = UploadStatusWaitingForData;
    }
    return self;
}
-(instancetype)initFromDisk{
    
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:[NSURL currentMetaDataFileURL].path]; 
    
    UploadObject *obj = [[UploadObject alloc] initWithDictionary:dict];
 
//    DDLogVerbose(@"upload object %@", obj);
    
    if ([UploadObject isValidUploadObject:obj]) {
        return obj;
    }
    
    return nil; 
}

#pragma mark - Public API
-(void)saveToDisk{
    NSDictionary *dict = [self dictionaryRepresentation];
    BOOL success = [dict writeToURL:[NSURL currentMetaDataFileURL] atomically:YES];
    
    if (!success) {
        DDLogError(@"Failed to save uploadObject to disk %@", [self dictionaryRepresentation]);
    }else{
        DDLogInfo(@"Saved uploadObject to disk %@", [self dictionaryRepresentation]);
    }
}
-(void)removeFromDisk{
    DDLogVerbose(@"");
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL currentMetaDataFileURL] error:nil];
}

#pragma mark - Setters
-(void)setVideoStatus:(UploadStatus)videoStatus{
    _videoStatus = videoStatus;
    [self updateOverallStatus];
}
-(void)setThumbnailStatus:(UploadStatus)thumbnailStatus{
    _thumbnailStatus = thumbnailStatus;
    [self updateOverallStatus];
}
-(void)setMetadataStatus:(UploadStatus)metadataStatus{
    _metadataStatus = metadataStatus;
    [self updateOverallStatus];
}

#pragma mark - Getters
-(NSNumber *)lat{
    return self.shareLocation ? _lat : nil;
}
-(NSNumber *)lon{
    return self.shareLocation ? _lon : nil;
}


#pragma mark - Internal Methods
-(instancetype)initWithDictionary:(NSDictionary *)dictionary{
    if (!dictionary) {
        return nil;
    }
    self = [super init];
    if (self) {
        _status = [[dictionary objectForKeyOrNil:@"status"] integerValue];
        _videoStatus = [[dictionary objectForKeyOrNil:@"videostatus"] integerValue];
        _thumbnailStatus = [[dictionary objectForKeyOrNil:@"thumbnailstatus"] integerValue];
        _metadataStatus = [[dictionary objectForKeyOrNil:@"metadatastatus"] integerValue];
        
        _shareToFacebook = [[dictionary objectForKeyOrNil:@"sharetofacebook"] boolValue];
        _shareToTwitter = [[dictionary objectForKeyOrNil:@"sharetotwitter"] boolValue];
        _shareLocation = [[dictionary objectForKeyOrNil:@"sharelocation"] boolValue];
        
        _videoID = [dictionary objectForKeyOrNil:@"videoid"];
        _tag = [dictionary objectForKeyOrNil:@"tag"];
        _category = [dictionary objectForKeyOrNil:@"category"];

        _videoLength = [dictionary objectForKeyOrNil:@"videolength"];
        _lat = [dictionary objectForKeyOrNil:@"lat"];
        _lon = [dictionary objectForKeyOrNil:@"lon"];
        
        _videoFileURL = [NSURL URLWithString:[dictionary objectForKeyOrNil:@"videofileurl"]];
        _thumbnailFileURL = [NSURL URLWithString:[dictionary objectForKeyOrNil:@"thumbnailfileurl"]];
    }
    return self;
}
-(NSDictionary *)dictionaryRepresentation{
        NSDictionary *me = @{@"status": CollectionSafeObject([NSNumber numberWithInteger:self.status]),
                             @"videostatus": CollectionSafeObject([NSNumber numberWithInteger:self.videoStatus]),
                             @"thumbnailstatus":CollectionSafeObject([NSNumber numberWithInteger:self.thumbnailStatus]),
                             @"metadatastatus":CollectionSafeObject([NSNumber numberWithInteger:self.metadataStatus]),
                            
                             @"sharetofacebook":CollectionSafeObject([NSNumber numberWithBool:self.shareToFacebook]),
                             @"sharetotwitter":CollectionSafeObject([NSNumber numberWithBool:self.shareToTwitter]),
                             @"sharelocation":CollectionSafeObject([NSNumber numberWithBool:self.shareLocation]),
                             
                             @"videoid":CollectionSafeObject(self.videoID),
                             @"tag":CollectionSafeObject(self.tag),
                             @"category":CollectionSafeObject(self.category),

                             @"videolength":CollectionSafeObject(self.videoLength),
                             @"lat":CollectionSafeObject(_lat),
                             @"lon":CollectionSafeObject(_lon),
                             
                             @"videofileurl":CollectionSafeObject(self.videoFileURL.path),
                             @"thumbnailfileurl":CollectionSafeObject(self.thumbnailFileURL.path)};
        return me;
}

-(void)updateOverallStatus{
    if (self.videoStatus == self.thumbnailStatus == self.metadataStatus) {
        self.status = self.videoStatus;
    }else if (self.videoStatus == UploadStatusFailed || self.thumbnailStatus == UploadStatusFailed || self.metadataStatus == UploadStatusFailed) {
        self.status = UploadStatusFailed;
    }else if (self.videoStatus == UploadStatusInProgress || self.thumbnailStatus == UploadStatusInProgress || self.metadataStatus == UploadStatusInProgress){
        self.status = UploadStatusInProgress;
    }
}


+(BOOL)isValidUploadObject:(UploadObject *)object{

//    DDLogVerbose(@"%@", object);
    
    if (!object) {
        [AIKErrorManager logMessage:[NSString stringWithFormat:@"upload object failed validation: %@", object]];
        return NO;
    }

    if (object.videoFileURL) {
        
        NSError *error = nil;
        BOOL fileExists = [object.videoFileURL checkResourceIsReachableAndReturnError:&error];
        
        if (!fileExists || error) {
            [AIKErrorManager logError:error withMessage:@"upload object video file failed validation!"];
            return NO;
        }
    }
    
    if (object.thumbnailFileURL) {
        
        NSError *error = nil;
        BOOL fileExists = [object.thumbnailFileURL checkResourceIsReachableAndReturnError:&error];
        
        if (!fileExists || error) {
            [AIKErrorManager logError:error withMessage:@"upload object video file failed validation!"];
            return NO;
        }
    }
    
    if (!object.videoID || !object.tag || !object.category || !object.videoLength.integerValue > 0) {
        return NO;
    }
    
    
    return YES;
}

#pragma mark - Overrides
-(NSString *)description{
    return [NSString stringWithFormat:@"Upload Object description: %@", [self dictionaryRepresentation]];
}


@end
