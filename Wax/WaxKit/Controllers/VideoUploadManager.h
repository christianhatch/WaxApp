//
//  VideoUploadManager.h
//  Wax
//
//  Created by Christian Hatch on 5/31/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

extern NSString *const VideoUploadManagerDidCompleteEntireUploadSuccessfullyNotification;

typedef void(^VideoUploadManagerDidBeginUploadBlock)(void);
typedef void(^VideoUploadManagerDidUpdateProgressBlock)(CGFloat progress);
typedef void(^VideoUploadManagerDidCompleteUploadBlock)(BOOL success, NSError *error);


#import <Foundation/Foundation.h>


@class UploadObject; 

@interface VideoUploadManager : NSObject

+(VideoUploadManager *)sharedManager;

-(void)askToCancelAndDeleteCurrentUploadWithCompletion:(void(^)(BOOL cancelled))block;

-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag category:(NSString *)category;

-(void)beginUploadProcessWithVideoFileURL:(NSURL *)videoFileURL videoDuration:(NSNumber *)duration;

-(void)addThumbnailImage:(UIImage *)thumbnail withOrientation:(UIInterfaceOrientation)orientation; 

-(void)addMetadataWithTag:(NSString *)tag
                 category:(NSString *)category
          shareToFacebook:(BOOL)shareToFacebook
           sharetoTwitter:(BOOL)sharetoTwitter
            shareLocation:(BOOL)shareLocation;

-(void)retryUpload;

@property (nonatomic, readonly) UploadObject *currentUpload;

-(BOOL)isInChallengeMode;
@property (nonatomic, readonly) NSString *challengeVideoTag;
@property (nonatomic, readonly) NSString *challengeVideoCategory;


#pragma mark - Callback Blocks

@property (nonatomic, copy) VideoUploadManagerDidBeginUploadBlock       videoFileUploadBeginBlock;
@property (nonatomic, copy) VideoUploadManagerDidUpdateProgressBlock    videoFileUploadProgressBlock;
@property (nonatomic, copy) VideoUploadManagerDidCompleteUploadBlock    videoFileUploadCompletionBlock;

@property (nonatomic, readonly) UIImage *thumbnailImage;
@property (nonatomic, copy) VideoUploadManagerDidBeginUploadBlock       thumbnailUploadBeginBlock;
@property (nonatomic, copy) VideoUploadManagerDidUpdateProgressBlock    thumbnailUploadProgressBlock;
@property (nonatomic, copy) VideoUploadManagerDidCompleteUploadBlock    thumbnailUploadCompletionBlock;

@property (nonatomic, copy) VideoUploadManagerDidBeginUploadBlock       metadataUploadBeginBlock;
@property (nonatomic, copy) VideoUploadManagerDidCompleteUploadBlock    metadataUploadCompletionBlock;


@end











