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
@property (nonatomic, strong) NSString *challengeCategory;
@end

@implementation VideoUploadManager
@synthesize currentUpload = _currentUpload, challengeVideoID = _challengeVideoID, challengeCompetitionTag = _challengeCompetitionTag, challengeCategory = _challengeCategory; 

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
-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag category:(NSString *)category{

    NSParameterAssert(videoID);
    NSParameterAssert(tag);
    NSParameterAssert(category);
    
    [self setchallengeVideoID:videoID challengeTag:tag challengeCategory:category]; 
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
            [self uploadVideoDataWithAttemptCount:@0];
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
        [self uploadThumbnailDataWithAttemptCount:@0];
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

    [self.currentUpload saveToDisk];
    
    self.currentUpload.metadataStatus = UploadStatusWaiting;
    [self uploadMetaDataWithAttemptCount:@0 completion:completion];
}
-(NSString *)challengeVideoTag{
    return [self.challengeCompetitionTag copy]; 
}
-(NSString *)challengeVideoCategory{
    return [self.challengeCategory copy];
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
                
        [[WaxAPIClient sharedClient] uploadVideoMetadataWithVideoID:self.currentUpload.videoID videoLength:self.currentUpload.videoLength tag:self.currentUpload.tag category:self.currentUpload.category lat:self.currentUpload.lat lon:self.currentUpload.lon challengeID:self.challengeVideoID shareToFacebook:self.currentUpload.shareToFacebook sharetoTwitter:self.currentUpload.shareToTwitter completion:^(BOOL complete, NSError *error) {
            
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
-(void)finishUploadWithCompletion:(void(^)(void))completion{
    
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to facebook from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToFacebook]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to twitter from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToTwitter]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared location with video: %@", [NSString localizedStringFromBool:self.currentUpload.shareLocation]]];

    if ([self isInChallengeMode]) {
        [AIKErrorManager logMessageToAllServices:@"Uploaded video via challenge button"];
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.videoFileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.thumbnailFileURL error:nil];
    
    [self.currentUpload removeFromDisk];
    self.currentUpload = nil;
    
    [self clearChallengeData];
    
    if (completion) {
        [[WaxDataManager sharedManager] updateHomeFeedWithInfiniteScroll:NO completion:nil];
        [[WaxDataManager sharedManager] updateMyFeedWithInfiniteScroll:NO completion:nil];
        completion();
    }
}

#pragma mark - Convenience methods
-(BOOL)isUploading{
    return (self.currentUpload || /*[self checkUploadsDirectory] ||*/ [AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting);
}
//-(BOOL)checkUploadsDirectory{
//    return [[NSFileManager defaultManager] fileExistsAtPath:[NSURL currentVideoFileURL].path];
//}
-(BOOL)isInChallengeMode{
    return ((self.challengeCompetitionTag != nil) && (self.challengeVideoID != nil) && (self.challengeCategory != nil));
}
-(void)setchallengeVideoID:(NSString *)videoID challengeTag:(NSString *)tag challengeCategory:(NSString *)category{
    self.challengeVideoID = videoID;
    self.challengeCompetitionTag = tag;
    self.challengeCategory = category;
}
-(void)clearChallengeData{
    [self setchallengeVideoID:nil challengeTag:nil challengeCategory:nil];
}




@end
