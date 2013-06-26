//
//  UploadObject.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#import "UploadObject.h"

NSString *const CurrentUploadObjectUserDefaultsKey = @"currentUploadObject";

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
    return [[UploadObject alloc] initWithDictionary:dict];
}

#pragma mark - Public API
-(void)saveToDisk{
    NSDictionary *dict = [self dictionaryRepresentation];
    [dict writeToURL:[NSURL currentMetaDataFileURL] atomically:YES];
    VLog(@"Saved uploadObject to disk %@", [self dictionaryRepresentation]); 
}
-(void)removeFromDisk{
    VLog(); 
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
        _lat = [dictionary objectForKeyOrNil:@"lat"];
        _lon = [dictionary objectForKeyOrNil:@"lon"];
        _tag = [dictionary objectForKeyOrNil:@"tag"];
        _category = [dictionary objectForKeyOrNil:@"category"];
        _videoLength = [dictionary objectForKeyOrNil:@"videolength"];
        _videoFileURL = [NSURL URLWithString:[dictionary objectForKeyOrNil:@"videofileurl"]];
        _thumbnailFileURL = [NSURL URLWithString:[dictionary objectForKeyOrNil:@"thumbnailfileurl"]];
    }
    return self;
}
-(NSDictionary *)dictionaryRepresentation{
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.status], [NSNumber numberWithInteger:self.videoStatus], [NSNumber numberWithInteger:self.thumbnailStatus], [NSNumber numberWithInteger:self.metadataStatus], [NSNumber numberWithBool:self.shareToFacebook], [NSNumber numberWithBool:self.shareToTwitter], [NSNumber numberWithBool:self.shareLocation], self.videoID, _lat, _lon, self.tag, self.category, self.videoLength, self.videoFileURL.path, self.thumbnailFileURL.path, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"status", @"videostatus", @"thumbnailstatus", @"metadatastatus", @"sharetofacebook", @"sharetotwitter", @"sharelocation", @"videoid", @"lat", @"lon", @"tag", @"category", @"videolength", @"videofileurl", @"thumbnailfileurl", nil];
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    return dict;
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


@end
