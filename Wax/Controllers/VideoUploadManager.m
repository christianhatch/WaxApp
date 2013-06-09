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
@end

@implementation VideoUploadManager
@synthesize currentUpload = _currentUpload;


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
-(void)askToCancelAndDeleteCurrentUploadWithBlock:(void (^)(BOOL))block{
    [[WaxDataManager sharedManager] updateCategories]; //update categories at the beginning of each upload process
    if ([self isUploading]) {
        RIButtonItem *sure = [RIButtonItem item];
        sure.label = NSLocalizedString(@"Delete", @"Delete");
        sure.action = ^{
            [[WaxAPIClient sharedClient] cancelVideoUploadingOperationWithVideoID:self.currentUpload.videoID];
            [self finishUploadWithCompletion:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(YES);
                }
            });
        };
        RIButtonItem *cancel = [RIButtonItem item];
        cancel.label = NSLocalizedString(@"Cancel", @"Cancel");
        cancel.action = ^{
            [[AIKErrorManager sharedManager] logMessageToAllServices:[NSString stringWithFormat:@"User attempted to capture new video while having an existing video that is %@, and decided to retry or let it finish", StringFromUploadStatus(self.currentUpload.status)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(NO);
                }
            });
        };
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Current?", @"Delete Current?") message:NSLocalizedString(@"Are you sure you want to cancel the current video upload? The video will be deleted permanently.", @"Are you sure you want to cancel this video upload? The video will be gone forever") cancelButtonItem:cancel otherButtonItems:sure, nil];
        [alert show];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) {
                block(YES);
            }
        });
    }
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
        DLog(@"location manager error %@", error);
    }];
    
    [[AIKVideoProcessor sharedProcessor] cropToSquareAndCompressVideoAtFilePath:videoFileURL andSaveToFileURL:self.currentUpload.videoFileURL andSaveToCameraRoll:[[NSUserDefaults standardUserDefaults] boolForKey:kUserSaveToCameraRollKey] withCompletionBlock:^(NSURL *exportedFileURL, NSError *error) {
        
        if (!error) {
            [self uploadVideoData];
        }else{
            DLog(@"error exporting! %@", error);
        }
    }];
}
-(void)addThumbnailImage:(UIImage *)thumbnail withOrientation:(UIInterfaceOrientation)orientation{
    
    NSParameterAssert(thumbnail);
    NSParameterAssert(orientation);
    
    [UIImage asyncSaveImage:[UIImage squareCropThumbnail:thumbnail withVideoOrientation:orientation] toFileURL:[NSURL currentThumbnailFileURL] quality:0.8 completion:^(NSURL *filePath) {
        self.currentUpload.thumbnailFileURL = filePath;
        self.currentUpload.thumbnailStatus = UploadStatusWaiting;
        [self uploadThumbnailData];
    }];
}
-(void)addMetadataWithTag:(NSString *)tag category:(NSString *)category shareToFacebook:(BOOL)shareToFacebook sharetoTwitter:(BOOL)sharetoTwitter shareLocation:(BOOL)shareLocation completion:(void (^)(void))completion{
    
    NSParameterAssert(tag);
    NSParameterAssert(category);
    NSParameterAssert(shareToFacebook);
    NSParameterAssert(sharetoTwitter);
    NSParameterAssert(shareLocation);
    
    self.currentUpload.tag = tag;
    self.currentUpload.category = category;
    self.currentUpload.shareToFacebook = shareToFacebook;
    self.currentUpload.shareToTwitter = sharetoTwitter;
    self.currentUpload.shareLocation = shareLocation; 

    [self.currentUpload saveToNSUserDefaults];
    
    self.currentUpload.metadataStatus = UploadStatusWaiting;
    [self uploadMetaDataWithCompletion:completion];
}
-(void)finishUploadWithCompletion:(void(^)(void))completion{
    
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.videoFileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.thumbnailFileURL error:nil];

    [self.currentUpload removeFromNSUserDefaults];
    self.currentUpload = nil; 
    
    if (completion) {
        completion();
    }
}

-(void)retryUploadWithCompletion:(void(^)(void))completion{
    if (self.currentUpload.videoStatus == UploadStatusFailed || self.currentUpload.videoStatus == UploadStatusWaiting) {
        [self uploadVideoData];
    }
    if (self.currentUpload.thumbnailStatus == UploadStatusFailed || self.currentUpload.thumbnailStatus == UploadStatusWaiting) {
        [self uploadThumbnailData];
    }
    if (self.currentUpload.metadataStatus == UploadStatusFailed || self.currentUpload.metadataStatus == UploadStatusWaiting) {
        [self uploadMetaDataWithCompletion:completion];
    }
}

-(void)uploadVideoData{
    [[WaxAPIClient sharedClient] uploadVideoAtFileURL:self.currentUpload.videoFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {

        self.currentUpload.videoStatus = UploadStatusInProgress;
                
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            self.currentUpload.videoStatus = UploadStatusCompleted;
            DLog(@"video upload completed");
            
        }else if(error.domain != NSURLErrorDomain && error.code != -999){
            //retry
            [[WaxAPIClient sharedClient] uploadVideoAtFileURL:self.currentUpload.videoFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                
                self.currentUpload.videoStatus = UploadStatusInProgress;
                                
            } completion:^(BOOL complete, NSError *error) {
                
                if (!error) {
                    self.currentUpload.videoStatus = UploadStatusCompleted;
                    
                }else{
                    self.currentUpload.videoStatus = UploadStatusFailed;
                    DLog(@"video upload failed with error %@", error);
                    
                    if(error.domain != NSURLErrorDomain && error.code != -999){
                        [[AIKErrorManager sharedManager] showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                            
                        }];
                    }
                }
            }];
        }
    }];
}
-(void)uploadThumbnailData{
    
    [[WaxAPIClient sharedClient] uploadThumbnailAtFileURL:self.currentUpload.thumbnailFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        self.currentUpload.thumbnailStatus = UploadStatusInProgress;
                
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            self.currentUpload.thumbnailStatus = UploadStatusCompleted;
            
            DLog(@"thumb upload completed");
            
        }else if(error.domain != NSURLErrorDomain && error.code != -999){
            //retry!!
            [[WaxAPIClient sharedClient] uploadThumbnailAtFileURL:self.currentUpload.thumbnailFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
                
                self.currentUpload.thumbnailStatus = UploadStatusInProgress;
                                
            } completion:^(BOOL complete, NSError *error) {
                
                if (!error) {
                    self.currentUpload.thumbnailStatus = UploadStatusCompleted;
                    
                }else{
                    self.currentUpload.thumbnailStatus = UploadStatusFailed;
                    DLog(@"thumb upload failed with error %@", error);
                    
                    if(error.domain != NSURLErrorDomain && error.code != -999){
                        [[AIKErrorManager sharedManager] showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                            
                        }];
                    }
                }
            }];
        }
    }];
}
-(void)uploadMetaDataWithCompletion:(void(^)(void))completion{
    if (self.currentUpload.videoStatus == UploadStatusCompleted && self.currentUpload.thumbnailStatus == UploadStatusCompleted) {
        
        self.currentUpload.metadataStatus = UploadStatusInProgress;
        
        [[WaxAPIClient sharedClient] uploadVideoMetadataWithVideoID:self.currentUpload.videoID videoLength:self.currentUpload.videoLength tag:self.currentUpload.tag category:self.currentUpload.category lat:self.currentUpload.lat lon:self.currentUpload.lon completion:^(BOOL complete, NSError *error) {
            
            if (!error) {
                
                self.currentUpload.metadataStatus = UploadStatusCompleted;
                [self finishUploadWithCompletion:completion];
                
            }else if(error.domain != NSURLErrorDomain && error.code != -999){
                //retry
                if (self.currentUpload.videoStatus == UploadStatusCompleted && self.currentUpload.thumbnailStatus == UploadStatusCompleted) {
                    
                    self.currentUpload.metadataStatus = UploadStatusInProgress;
                    
                    [[WaxAPIClient sharedClient] uploadVideoMetadataWithVideoID:self.currentUpload.videoID videoLength:self.currentUpload.videoLength tag:self.currentUpload.tag category:self.currentUpload.category lat:self.currentUpload.lat lon:self.currentUpload.lon completion:^(BOOL complete, NSError *error) {
                        
                        if (!error) {
                            
                            self.currentUpload.metadataStatus = UploadStatusCompleted;
                            [self finishUploadWithCompletion:completion];
                            
                        }else{
                            self.currentUpload.metadataStatus = UploadStatusFailed;
                            
                            if(error.domain != NSURLErrorDomain && error.code != -999){
                                [[AIKErrorManager sharedManager] showAlertWithTitle:error.localizedDescription message:error.localizedRecoverySuggestion buttonHandler:^{
                                    
                                }];
                            }
                        }
                    }];
                }else{
                    [self retryUploadWithCompletion:completion];
                }
            }
        }];
    }else{
        [self retryUploadWithCompletion:completion];
    }
}


#pragma mark - Internal methods
-(BOOL)isUploading{
    return (self.currentUpload || /*[self checkUploadsDirectory] ||*/ [AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting);
}
//-(BOOL)checkUploadsDirectory{
//    return [[NSFileManager defaultManager] fileExistsAtPath:[NSURL currentVideoFileURL].path];
//}

@end
