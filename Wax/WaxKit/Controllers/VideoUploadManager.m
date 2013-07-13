//
//  VideoUploadManager.m
//  Wax
//
//  Created by Christian Hatch on 5/31/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "VideoUploadManager.h"
#import <AcaciaKit/AIKVideoProcessor.h>


@interface VideoUploadManager ()
@property (nonatomic, strong) UploadObject *currentUpload;
@property (nonatomic, strong) NSString *challengeVideoID;
@property (nonatomic, strong) NSString *challengeVideoTag;
@property (nonatomic, strong) NSString *challengeVideoCategory;
@end

@implementation VideoUploadManager
@synthesize currentUpload = _currentUpload, challengeVideoID = _challengeVideoID, challengeVideoTag = _challengeVideoTag, challengeVideoCategory = _challengeVideoCategory;

#pragma mark - Alloc & Init
+(VideoUploadManager *)sharedManager{
    static VideoUploadManager *sharedID = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedID = [[VideoUploadManager alloc] init];
    });
    return sharedID;
}
-(id)init{
    self = [super init];
    if (self) {
        self.currentUpload = nil; 
    }
    return self; 
}

#pragma mark - Public API
-(void)askToCancelAndDeleteCurrentUploadWithBlock:(void (^)(BOOL))block{
    [[WaxDataManager sharedManager] updateCategoriesWithCompletion:nil]; //update categories at the beginning of each upload process
   
    if ([self isUploading]) {
        RIButtonItem *sure = [RIButtonItem itemWithLabel:NSLocalizedString(@"Delete", @"Delete")];
        sure.action = ^{
            [self cancelAllOperationsAndClearCurrentUpload];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(YES);
                }
            });
        };
        
        RIButtonItem *cancel = [RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", @"Cancel")];
        cancel.action = ^{
            [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"User attempted to capture new video while having an existing video that is %@, and decided to retry or let it finish", StringFromUploadStatus(self.currentUpload.status)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(NO);
                }
            });
        };
        
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Current?", @"Delete Current?") message:NSLocalizedString(@"Are you sure you want to cancel the current video upload? The video will be deleted permanently.", @"Are you sure you want to cancel this video upload? The video will be gone forever") cancelButtonItem:cancel otherButtonItems:sure, nil] show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }
}
-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag category:(NSString *)category{

    NSParameterAssert(videoID);
    NSParameterAssert(tag);
    NSParameterAssert(category);
    
    [self setchallengeVideoID:videoID challengeTag:tag challengeVideoCategory:category]; 
}

-(void)beginUploadProcessWithVideoFileURL:(NSURL *)videoFileURL videoDuration:(NSNumber *)duration{
    
    NSParameterAssert(videoFileURL);
    NSParameterAssert(duration); 
        
    self.currentUpload = [[UploadObject alloc] initWithVideoFileURL:[NSURL currentVideoFileURL]];
    self.currentUpload.videoLength = duration; 
    self.currentUpload.videoStatus = UploadStatusWaiting;
    
    [[AIKLocationManager sharedManager] startUpdatingLocationWithBlock:^(CLLocationManager *manager, CLLocation *newLocation, CLLocation *oldLocation) {
        self.currentUpload.lat = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
        self.currentUpload.lon = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
    } errorBlock:^(CLLocationManager *manager, NSError *error) {
        [AIKErrorManager logMessage:@"location manager error" withError:error]; 
    }];
    
    [[AIKVideoProcessor sharedProcessor] cropToSquareAndCompressVideoAtFilePath:videoFileURL andSaveToFileURL:self.currentUpload.videoFileURL andSaveToCameraRoll:[WaxUser currentUser].shouldSaveVideosToCameraRoll withCompletionBlock:^(NSURL *exportedFileURL, NSError *error) {
        
        if (!error) {
            [self uploadVideoDataWithAttemptCount:@0];
        }else if (error.code == 1337){
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Recording Video", @"Error Recording Video") message:NSLocalizedString(@"There was an error recording your video. Please try again.", @"There was an error recording your video. Please try again.") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:^{
                [AIKErrorManager logMessageToAllServices:@"Canceled or failed video export"];
            } logError:YES];
        }
    }];
}
-(void)addThumbnailImage:(UIImage *)thumbnail withOrientation:(UIInterfaceOrientation)orientation{
    
    NSParameterAssert(thumbnail);
    NSParameterAssert(orientation);
    
    UIImage *square = [UIImage squareCropThumbnail:thumbnail withVideoOrientation:orientation];
    UIImage *small = [UIImage resizeImage:square toSize:CGSizeMake(300, 300)];
    
    [UIImage asyncSaveImage:small toFileURL:[NSURL currentThumbnailFileURL] quality:0.8 completion:^(NSURL *filePath) {
        self.currentUpload.thumbnailFileURL = filePath;
        self.currentUpload.thumbnailStatus = UploadStatusWaiting;
        [self uploadThumbnailDataWithAttemptCount:@0];
    }];
}
-(void)addMetadataWithTag:(NSString *)tag category:(NSString *)category shareToFacebook:(BOOL)shareToFacebook sharetoTwitter:(BOOL)sharetoTwitter shareLocation:(BOOL)shareLocation completion:(void (^)(void))completion{
    
    NSParameterAssert(tag);
    NSParameterAssert(category);
    
    self.currentUpload.tag = tag;
    self.currentUpload.category = category;
    self.currentUpload.shareToFacebook = shareToFacebook;
    self.currentUpload.shareToTwitter = sharetoTwitter;
    self.currentUpload.shareLocation = shareLocation; 

    [self.currentUpload saveToDisk];
    
    self.currentUpload.metadataStatus = UploadStatusWaiting;
    [self uploadMetaDataWithAttemptCount:@0 completion:completion];
}

#pragma mark - Internal Methods
-(void)retryUploadWithCompletion:(void(^)(void))completion{
    if (self.currentUpload.videoStatus == UploadStatusFailed || self.currentUpload.videoStatus == UploadStatusWaiting) {
        [self uploadVideoDataWithAttemptCount:@0];
    }
    if (self.currentUpload.thumbnailStatus == UploadStatusFailed || self.currentUpload.thumbnailStatus == UploadStatusWaiting) {
        [self uploadThumbnailDataWithAttemptCount:@0];
    }
    if (self.currentUpload.metadataStatus == UploadStatusFailed || self.currentUpload.metadataStatus == UploadStatusWaiting) {
        [self uploadMetaDataWithAttemptCount:@0 completion:completion];
    }
}

-(void)uploadVideoDataWithAttemptCount:(NSNumber *)attemptCount{

    [[WaxAPIClient sharedClient] uploadVideoAtFileURL:self.currentUpload.videoFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        self.currentUpload.videoStatus = UploadStatusInProgress;
        
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            self.currentUpload.videoStatus = UploadStatusCompleted;
            
        }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){
            
            switch (attemptCount.integerValue) {
                case 0:
                case 1:{
                    [self performSelector:@selector(uploadVideoDataWithAttemptCount:) withObject:[NSNumber numberWithInteger:attemptCount.integerValue + 1] afterDelay:5]; 
                }break;
                default:{
                    self.currentUpload.videoStatus = UploadStatusFailed;
                    [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:^{
                        
                    } logError:YES];
                }break;
            }
        }
    }];
}
-(void)uploadThumbnailDataWithAttemptCount:(NSNumber *)attemptCount{
    
    [[WaxAPIClient sharedClient] uploadThumbnailAtFileURL:self.currentUpload.thumbnailFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        self.currentUpload.thumbnailStatus = UploadStatusInProgress;
                
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            self.currentUpload.thumbnailStatus = UploadStatusCompleted;
                        
        }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){            
            
            switch (attemptCount.integerValue) {
                case 0:
                case 1:{
                    [self performSelector:@selector(uploadThumbnailDataWithAttemptCount:) withObject:[NSNumber numberWithInteger:attemptCount.integerValue + 1] afterDelay:5];
                }break;
                default:{
                    self.currentUpload.thumbnailStatus = UploadStatusFailed;
                    [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:^{
                        
                    } logError:YES];
                }break;
            }
        }
    }];
}
-(void)uploadMetaDataWithAttemptCount:(NSNumber *)attemptCount completion:(void(^)(void))completion{
    if (self.currentUpload.videoStatus == UploadStatusCompleted && self.currentUpload.thumbnailStatus == UploadStatusCompleted) {
        
        self.currentUpload.metadataStatus = UploadStatusInProgress;
        
        
        [[WaxAPIClient sharedClient] uploadVideoMetadataWithVideoID:self.currentUpload.videoID videoLength:self.currentUpload.videoLength tag:self.currentUpload.tag category:self.currentUpload.category lat:self.currentUpload.lat lon:self.currentUpload.lon challengeVideoID:self.challengeVideoID challengeVideoTag:self.challengeVideoTag shareToFacebook:self.currentUpload.shareToFacebook sharetoTwitter:self.currentUpload.shareToTwitter completion:^(BOOL complete, NSError *error) {
                        
            if (!error) {
                
                self.currentUpload.metadataStatus = UploadStatusCompleted;
                [self finishUploadWithCompletion:completion];
                
            }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){
                
                switch (attemptCount.integerValue) {
                    case 0:
                    case 1:{
                        [self uploadMetaDataWithAttemptCount:[NSNumber numberWithInteger:attemptCount.integerValue + 1] completion:completion];
                    }break;
                    default:{
                        self.currentUpload.thumbnailStatus = UploadStatusFailed;
                        [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:^{
                            
                        } logError:YES];
                    }break;
                }
            }
        }];
    }else{
//        [self retryUploadWithCompletion:completion];
    }
}
-(void)cancelAllOperationsAndClearCurrentUpload{
    if ([AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting) {
        [[AIKVideoProcessor sharedProcessor].exporter cancelExport];
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL currentVideoFileURL] error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL currentThumbnailFileURL] error:nil];

    [[WaxAPIClient sharedClient] cancelVideoUploadingOperationWithVideoID:self.currentUpload.videoID];

    [self cleanUpCurrentUpload];
}

-(void)finishUploadWithCompletion:(void(^)(void))completion{
    
    if ([self isInChallengeMode]) {
        [AIKErrorManager logMessageToAllServices:@"Uploaded video via challenge button"];
    }
    
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to facebook from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToFacebook]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to twitter from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToTwitter]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared location with video: %@", [NSString localizedStringFromBool:self.currentUpload.shareLocation]]];
    
    [self cleanUpCurrentUpload];

    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationVideoUploadCompleted object:self];

    if (completion) {
        completion();
    }
}

-(void)cleanUpCurrentUpload{
    [[AIKLocationManager sharedManager] stopUpdatingLocation];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.videoFileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.thumbnailFileURL error:nil];
    
    [self.currentUpload removeFromDisk];
    self.currentUpload = nil;
    
    [self clearChallengeData];
}

#pragma mark - Convenience methods
-(BOOL)isUploading{
    return (self.currentUpload || [self checkUploadsDirectory] || [AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting);
}
-(BOOL)checkUploadsDirectory{
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSURL currentVideoFileURL].path];
}

-(BOOL)isInChallengeMode{
    return ((self.challengeVideoTag != nil) && (self.challengeVideoID != nil) && (self.challengeVideoCategory != nil));
}
-(void)setchallengeVideoID:(NSString *)videoID challengeTag:(NSString *)tag challengeVideoCategory:(NSString *)category{
    self.challengeVideoID = videoID;
    self.challengeVideoTag = tag;
    self.challengeVideoCategory = category;
}
-(void)clearChallengeData{
    [self setchallengeVideoID:nil challengeTag:nil challengeVideoCategory:nil];
}




@end
