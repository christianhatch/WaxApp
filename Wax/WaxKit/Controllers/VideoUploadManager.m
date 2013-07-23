//
//  VideoUploadManager.m
//  Wax
//
//  Created by Christian Hatch on 5/31/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


NSString *const VideoUploadManagerDidCompleteEntireUploadSuccessfullyNotification = @"com.wax.VideoUploadManagerDidCompleteEntireUploadSuccessfullyNotification";

#import "VideoUploadManager.h"
#import <AcaciaKit/AIKVideoProcessor.h>

@interface VideoUploadManager ()
@property (nonatomic, strong) UploadObject *currentUpload;
@property (nonatomic, strong) NSString *challengeVideoID;
@property (nonatomic, strong) NSString *challengeVideoTag;
@property (nonatomic, strong) NSString *challengeVideoCategory;
@property (nonatomic, strong) UIImage *thumbnailImage;

@property (nonatomic, readonly) BOOL hasVideoFileOnDisk;
@end

@implementation VideoUploadManager
@synthesize currentUpload = _currentUpload, challengeVideoID = _challengeVideoID, challengeVideoTag = _challengeVideoTag, challengeVideoCategory = _challengeVideoCategory, thumbnailImage;

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
-(void)askToRespondToChallengeWithBlock:(VideoManagerCancelBlock)block{
    //standard question
    //clear everything
    [self askUserQuestion:nil withBlock:^(BOOL allowedToProceed) {
        
        if (allowedToProceed) {
            [self cancelAllOperationsAndCleanUpCurrentUpload];
            [self clearChallengeData];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(allowedToProceed);
            });
        }

    }];
}
-(void)askToCaptureFromTabbarWithBlock:(VideoManagerCancelBlock)block{
    //standard question
    //clear everything (esp. challenge since it couldn't possibly be a challenge!)
    
    [self askUserQuestion:nil withBlock:^(BOOL allowedToProceed) {
        
        if (allowedToProceed) {
            [self cancelAllOperationsAndCleanUpCurrentUpload];
            [self clearChallengeData];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(allowedToProceed);
            });
        }
    }];
}

-(void)askToExitThumbnailChooserWithBlock:(VideoManagerCancelBlock)block{
    //are you sure you want to take a new video? your current video will be deleted.
    //don't clear challenge data, but clear everything else
    
    [self askUserQuestion:NSLocalizedString(@"Are you sure you want to take another video?", @"cancel current upload confirmation from thumbnail chooser") withBlock:^(BOOL allowedToProceed) {
        
        if (allowedToProceed) {
            [self cancelAllOperationsAndCleanUpCurrentUpload];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(allowedToProceed);
            });
        }
    }];
}
-(void)askToExitVideoCameraWithBlock:(VideoManagerCancelBlock)block{
    //standard question
    //clear everything completely
    [self askUserQuestion:nil withBlock:^(BOOL allowedToProceed) {
        
        if (allowedToProceed) {
            [self cancelAllOperationsAndCleanUpCurrentUpload];
            [self clearChallengeData];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(allowedToProceed);
            });
        }
    }];
}
-(void)askToCancelFromUploadView:(VideoManagerCancelBlock)block{
    //you sure you want to cancel this video upload? it'll be deleted permanently
    //cler everything, since we are cancelling the upload entirely
    
    [self askUserQuestion:NSLocalizedString(@"Are you sure you want to cancel this video upload? \n\nIt'll be deleted permanently.", @"cancel from upload view string") withBlock:^(BOOL allowedToProceed) {
        
        if (allowedToProceed) {
            [self cancelAllOperationsAndCleanUpCurrentUpload];
            [self clearChallengeData];
        }
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(allowedToProceed);
            });
        }
    }];
}

-(void)askUserQuestion:(NSString *)question withBlock:(VideoManagerCancelBlock)block{
    
    if (!self.hasPendingOrFailedUpload) {
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(YES);
            });
        }
        
        return;
    }
        
    RIButtonItem *deleteUpload = [RIButtonItem itemWithLabel:NSLocalizedString(@"Delete", @"Delete")];
    deleteUpload.action = ^{

        [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"User attempted to capture new video while having an existing video that is %@, and decided to cancel it", StringFromUploadStatus(self.currentUpload.status)]];

        if (block) {
            block(YES);
        }        
    };
    
    RIButtonItem *cancel = [RIButtonItem itemWithLabel:NSLocalizedString(@"Cancel", @"Cancel")];
    cancel.action = ^{
        
        [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"User attempted to capture new video while having an existing video that is %@, and decided to retry or let it finish", StringFromUploadStatus(self.currentUpload.status)]];
        
        if (block) {
            block(NO);
        }

    };
    
    NSString *reason = @"";
    if (self.currentUpload) {
        reason = NSLocalizedString(@"You have a video that is currently uploading.\n", @"currently uploading message");
    }else if (self.hasVideoFileOnDisk){
        reason = NSLocalizedString(@"You have a video that failed to upload.\n", @"failed upload message");
    }

    if (!question) {
        question = [NSString stringWithFormat:NSLocalizedString(@"%@Are you sure you want to cancel your current video upload? \n\nThe video will be deleted permanently.", @"cancel current upload confirmation message"), reason];
    }

    
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Delete Current Upload?", @"cancel current upload title") message:question cancelButtonItem:cancel otherButtonItems:deleteUpload, nil] show];

}
-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag category:(NSString *)category{

    NSParameterAssert(videoID);
    NSParameterAssert(tag);
    NSParameterAssert(category);
    VLog();

    [self setchallengeVideoID:videoID challengeTag:tag challengeVideoCategory:category];
}

-(void)beginUploadProcessWithVideoFileURL:(NSURL *)videoFileURL videoDuration:(NSNumber *)duration{
    
    NSParameterAssert(videoFileURL);
    NSParameterAssert(duration); 
    VLog();
    
    [[WaxDataManager sharedManager] updateCategoriesWithCompletion:nil]; //update categories at the beginning of each upload process

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
        }else if(error.code == 1337){
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Recording Video", @"Error Recording Video") message:NSLocalizedString(@"There was an error recording your video. Please try again.", @"There was an error recording your video. Please try again.") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:^{
                [AIKErrorManager logMessageToAllServices:@"Canceled or failed video export"];
            } logError:YES];
        }else{
            [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Recording Video", @"Error Recording Video") message:NSLocalizedString(@"There was an error recording your video. Please try again.", @"There was an error recording your video. Please try again.") buttonTitle:NSLocalizedString(@"OK", @"OK") showsCancelButton:NO buttonHandler:^{
                [AIKErrorManager logMessageToAllServices:@"Canceled or failed video export"];
            } logError:YES];
        }
    }];
}
-(void)addThumbnailImage:(UIImage *)thumbnail withOrientation:(UIInterfaceOrientation)orientation{
    
    NSParameterAssert(thumbnail);
    NSParameterAssert(orientation);
    VLog();
    
    UIImage *square = [UIImage squareCropThumbnail:thumbnail withVideoOrientation:orientation];
    UIImage *small = [UIImage resizeImage:square toSize:CGSizeMake(300, 300)];
    
    self.thumbnailImage = small; 
    
    [UIImage asyncSaveImage:small toFileURL:[NSURL currentThumbnailFileURL] quality:0.8 completion:^(NSURL *filePath) {
        self.currentUpload.thumbnailFileURL = filePath;
        self.currentUpload.thumbnailStatus = UploadStatusWaiting;
        [self uploadThumbnailDataWithAttemptCount:@0];
    }];
}

-(void)addMetadataWithTag:(NSString *)tag category:(NSString *)category shareToFacebook:(BOOL)shareToFacebook sharetoTwitter:(BOOL)sharetoTwitter shareLocation:(BOOL)shareLocation{
    
    NSParameterAssert(tag);
    NSParameterAssert(category);
    VLog();

    self.currentUpload.tag = tag;
    self.currentUpload.category = category;
    self.currentUpload.shareToFacebook = shareToFacebook;
    self.currentUpload.shareToTwitter = sharetoTwitter;
    self.currentUpload.shareLocation = shareLocation; 

    [self.currentUpload saveToDisk];
    
    self.currentUpload.metadataStatus = UploadStatusWaiting;
    [self uploadMetaDataWithAttemptCount:@0];
}

#pragma mark - Internal Methods
-(void)retryUpload{
    VLog();

    if (self.currentUpload.videoStatus == UploadStatusFailed || self.currentUpload.videoStatus == UploadStatusWaiting) {
        [self uploadVideoDataWithAttemptCount:@0];
    }
    if (self.currentUpload.thumbnailStatus == UploadStatusFailed || self.currentUpload.thumbnailStatus == UploadStatusWaiting) {
        [self uploadThumbnailDataWithAttemptCount:@0];
    }
    if (self.currentUpload.metadataStatus == UploadStatusFailed || self.currentUpload.metadataStatus == UploadStatusWaiting) {
        [self uploadMetaDataWithAttemptCount:@0];
    }
}

-(void)uploadVideoDataWithAttemptCount:(NSNumber *)attemptCount{
    VLog();
    
    if (self.videoFileUploadBeginBlock) {
        self.videoFileUploadBeginBlock(); 
    }
    
    [[WaxAPIClient sharedClient] uploadVideoAtFileURL:self.currentUpload.videoFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        self.currentUpload.videoStatus = UploadStatusInProgress;

        if (self.videoFileUploadProgressBlock) {
            self.videoFileUploadProgressBlock(percentage); 
        }
        
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            
            VLog(@"video file uploaded successfully"); 
            
            self.currentUpload.videoStatus = UploadStatusCompleted;
            [self uploadMetaDataWithAttemptCount:@0];

        }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){
            
            VLog(@"video file upload failed!");
            self.currentUpload.videoStatus = UploadStatusFailed;
        }
        
        if (self.videoFileUploadCompletionBlock) {
            self.videoFileUploadCompletionBlock(complete, error);
        }

    }];
}
-(void)uploadThumbnailDataWithAttemptCount:(NSNumber *)attemptCount{
    VLog();

    if (self.thumbnailUploadBeginBlock) {
        self.thumbnailUploadBeginBlock(); 
    }
    
    [[WaxAPIClient sharedClient] uploadThumbnailAtFileURL:self.currentUpload.thumbnailFileURL videoID:self.currentUpload.videoID progress:^(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        
        self.currentUpload.thumbnailStatus = UploadStatusInProgress;
        
        if (self.thumbnailUploadProgressBlock) {
            self.thumbnailUploadProgressBlock(percentage);
        }
                
    } completion:^(BOOL complete, NSError *error) {
        
        if (!error) {
            
            VLog(@"thumbnail file uploaded");

            self.currentUpload.thumbnailStatus = UploadStatusCompleted;
            [self uploadMetaDataWithAttemptCount:@0];
            
        }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){            

            VLog(@"thumbnail file failed!");
            self.currentUpload.thumbnailStatus = UploadStatusFailed;
        }
        
        if (self.thumbnailUploadCompletionBlock) {
            self.thumbnailUploadCompletionBlock(complete, error); 
        }
        
    }];
}
-(void)uploadMetaDataWithAttemptCount:(NSNumber *)attemptCount{
    VLog();
    
    if (self.currentUpload.videoStatus == UploadStatusCompleted && self.currentUpload.thumbnailStatus == UploadStatusCompleted) {
        
        if (self.metadataUploadBeginBlock) {
            self.metadataUploadBeginBlock();
        }

        self.currentUpload.metadataStatus = UploadStatusInProgress;
        
        [[WaxAPIClient sharedClient] uploadVideoMetadataWithVideoID:self.currentUpload.videoID videoLength:self.currentUpload.videoLength tag:self.currentUpload.tag category:self.currentUpload.category lat:self.currentUpload.lat lon:self.currentUpload.lon challengeVideoID:self.challengeVideoID challengeVideoTag:self.challengeVideoTag shareToFacebook:self.currentUpload.shareToFacebook sharetoTwitter:self.currentUpload.shareToTwitter completion:^(BOOL complete, NSError *error) {
                        
            if (!error) {
                
                VLog(@"metadata uploaded");

                self.currentUpload.metadataStatus = UploadStatusCompleted;
                [self finishUploadProcessAndCleanUpCurrentUpload];
                
            }else if(![NSError NSURLRequestErrorIsRequestWasCancelled:error]){
                
                VLog(@"metadata upload failed!");
                self.currentUpload.thumbnailStatus = UploadStatusFailed;
            }
        }];
    }else{
        VLog(@"can't upload metadata because video and thumbnail haven't uploaded yet..");
    }
}
-(void)finishUploadProcessAndCleanUpCurrentUpload{
    VLog();
    
    if ([self isInChallengeMode]) {
        [AIKErrorManager logMessageToAllServices:@"Uploaded video via challenge button"];
    }
    
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to facebook from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToFacebook]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared to twitter from share page: %@", [NSString localizedStringFromBool:self.currentUpload.shareToTwitter]]];
    [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Shared location with video: %@", [NSString localizedStringFromBool:self.currentUpload.shareLocation]]];
    
    [self clearChallengeData]; 
    [self cleanUpCurrentUpload];
    
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:VideoUploadManagerDidCompleteEntireUploadSuccessfullyNotification object:self];
}
-(void)cancelAllOperationsAndCleanUpCurrentUpload{
    VLog();

    if ([AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting) {
        [[AIKVideoProcessor sharedProcessor].exporter cancelExport];
    }
    
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL currentVideoFileURL] error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:[NSURL currentThumbnailFileURL] error:nil];

    [[WaxAPIClient sharedClient] cancelVideoUploadingOperationWithVideoID:self.currentUpload.videoID];

    [self cleanUpCurrentUpload];
}
-(void)cleanUpCurrentUpload{
    VLog();

    [[AIKLocationManager sharedManager] stopUpdatingLocation];
    
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.videoFileURL error:nil];
    [[NSFileManager defaultManager] removeItemAtURL:self.currentUpload.thumbnailFileURL error:nil];
    
    [self.currentUpload removeFromDisk];
    self.currentUpload = nil;
}

#pragma mark - Convenience methods
-(BOOL)hasPendingOrFailedUpload{
    return (self.currentUpload || self.hasVideoFileOnDisk || self.isProcessingVideo);
}
-(BOOL)hasVideoFileOnDisk{
    return [[NSFileManager defaultManager] fileExistsAtPath:[NSURL currentVideoFileURL].path];
}
-(BOOL)isProcessingVideo{
    return [AIKVideoProcessor sharedProcessor].exporter.status == AVAssetExportSessionStatusExporting; 
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
