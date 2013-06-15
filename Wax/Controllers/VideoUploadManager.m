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
@property (nonatomic, strong) NSString *challengeVideoID;
@property (nonatomic, strong) NSString *challengeCompetitionTag;
@end

@implementation VideoUploadManager
@synthesize currentUpload = _currentUpload, challengeVideoID = _challengeVideoID, challengeCompetitionTag = _challengeCompetitionTag;

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
-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag{

    NSParameterAssert(videoID);
    NSParameterAssert(tag);
    
    self.challengeVideoID = videoID;
    self.challengeCompetitionTag = tag;
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
    
    UIImage *square = [UIImage squareCropThumbnail:thumbnail withVideoOrientation:orientation];
    UIImage *small = [UIImage resizeImage:square toSize:CGSizeMake(300, 300)];
    
    [UIImage asyncSaveImage:small toFileURL:[NSURL currentThumbnailFileURL] quality:0.8 completion:^(NSURL *filePath) {
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
-(NSString *)challengeTag{
    return [self.challengeCompetitionTag copy]; 
}

#pragma mark - Internal Methods
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
                        [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:nil logError:NO];
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
                        [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:nil logError:NO]; 
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
                                [AIKErrorManager showAlertWithTitle:error.localizedDescription error:error buttonHandler:nil logError:NO];
                            }
                        }
                    }];
                }else{
//                    [self retryUploadWithCompletion:completion];
                }
            }
        }];
    }else{
//        [self retryUploadWithCompletion:completion];
    }
}
-(void)finishUploadWithCompletion:(void(^)(void))completion{
    
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to facebook from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToFacebook]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to twitter from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToTwitter]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared location with video: %@", [NSString localizedStringFromBool:self.currentUpload.shareLocation]]];

    if ([self isInChallengeMode]) {
        [AIKErrorManager logMessageToAllServices:@"Uploaded video via challenge button"];
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.videoFileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.thumbnailFileURL error:nil];
    
    [self.currentUpload removeFromNSUserDefaults];
    self.currentUpload = nil;
    self.challengeVideoID = nil;
    self.challengeCompetitionTag = nil;
    
    if (completion) {
        completion();
    }
}


#pragma mark - Internal methods
-(BOOL)isUploading{
    return (self.currentUpload || /*[self checkUploadsDirectory] ||*/ [AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting);
}
//-(BOOL)checkUploadsDirectory{
//    return [[NSFileManager defaultManager] fileExistsAtPath:[NSURL currentVideoFileURL].path];
//}
-(BOOL)isInChallengeMode{
    return ((self.challengeCompetitionTag != nil) && (self.challengeVideoID != nil));
}

@end
