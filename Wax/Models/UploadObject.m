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
@synthesize status = _status, videoStatus = _videoStatus, thumbnailStatus = _thumbnailStatus, metadataStatus = _metadataStatus, shareToFacebook = _shareToFacebook, shareToTwitter = _shareToTwitter, shareLocation = _shareLocation, videoLink = _videoLink, thumbnailLink = _thumbnailLink, lat = _lat, lon = _lon, tag = _tag, category = _category, videoLength = _videoLength, videoFileURL = _videoFileURL, thumbnailFileURL = _thumbnailFileURL; 

-(id)initWithVideoFileURL:(NSURL *)videoFileURL{
    
    NSParameterAssert(videoFileURL);
    
    self = [super init];
    if (self) {
        _videoFileURL = videoFileURL;
        _videoLink = [NSString stringWithFormat:@"%@.mp4", [NSString currentTenDigitUnixTimestamp]];
        _thumbnailLink = [NSString stringWithFormat:@"%@.jpg", self.videoLink];
        _status = UploadStatusWaitingForData;
        _videoStatus = UploadStatusWaitingForData;
        _thumbnailStatus = UploadStatusWaitingForData;
        _metadataStatus = UploadStatusWaitingForData;
    }
    return self;
}
-(id)initFromNSUserDefaults{
    return [[UploadObject alloc] initWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:CurrentUploadObjectUserDefaultsKey]];
}
-(id)initWithDictionary:(NSDictionary *)dictionary{
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
        
        _videoLink = [dictionary objectForKeyOrNil:@"videolink"];
        _thumbnailLink = [dictionary objectForKeyOrNil:@"thumbnaillink"];
        _lat = [dictionary objectForKeyOrNil:@"lat"];
        _lon = [dictionary objectForKeyOrNil:@"lon"];
        _tag = [dictionary objectForKeyOrNil:@"tag"];
        _category = [dictionary objectForKeyOrNil:@"category"];
        _videoLength = [dictionary objectForKeyOrNil:@"videolength"];
        _videoFileURL = [dictionary objectForKeyOrNil:@"videofileurl"];
        _thumbnailFileURL = [dictionary objectForKeyOrNil:@"thumbnailfileurl"];
    }
    return self;
}
-(void)saveToNSUserDefaults{
    [[NSUserDefaults standardUserDefaults] setObject:[self dictionaryRepresentation] forKey:CurrentUploadObjectUserDefaultsKey];
}
-(void)removeFromNSUserDefaults{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:CurrentUploadObjectUserDefaultsKey];
}
-(NSDictionary *)dictionaryRepresentation{
    NSArray *objects = [NSArray arrayWithObjects:[NSNumber numberWithInteger:self.status], [NSNumber numberWithInteger:self.videoStatus], [NSNumber numberWithInteger:self.thumbnailStatus], [NSNumber numberWithInteger:self.metadataStatus], [NSNumber numberWithBool:self.shareToFacebook], [NSNumber numberWithBool:self.shareToTwitter], [NSNumber numberWithBool:self.shareLocation], self.videoLink, self.thumbnailLink, _lat, _lon, self.tag, self.category, self.videoLength, self.videoFileURL, self.thumbnailFileURL, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"status", @"videostatus", @"thumbnailstatus", @"metadatastatus", @"sharetofacebook", @"sharetotwitter", @"sharelocation", @"videolink", @"thumbnaillink", @"lat", @"lon", @"tag", @"category", @"videolength", @"videofileurl", @"thumbnailfileurl", nil];
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



@end
