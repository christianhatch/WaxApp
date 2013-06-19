//
//  VideoUploadManager.h
//  Wax
//
//  Created by Christian Hatch on 5/31/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UploadObject, CLLocation;


@interface VideoUploadManager : NSObject

+(VideoUploadManager *)sharedManager;

-(void)askToCancelAndDeleteCurrentUploadWithBlock:(void(^)(BOOL cancelled))block;

-(void)beginUploadProcessWithVideoID:(NSString *)videoID competitionTag:(NSString *)tag category:(NSString *)category;

-(void)beginUploadProcessWithVideoFileURL:(NSURL *)videoFileURL videoDuration:(NSNumber *)duration;

-(void)addThumbnailImage:(UIImage *)thumbnail withOrientation:(UIInterfaceOrientation)orientation; 

-(void)addMetadataWithTag:(NSString *)tag
                 category:(NSString *)category
          shareToFacebook:(BOOL)shareToFacebook
           sharetoTwitter:(BOOL)sharetoTwitter
            shareLocation:(BOOL)shareLocation
               completion:(void(^)(void))completion;

-(void)retryUploadWithCompletion:(void(^)(void))completion;

@property (nonatomic, strong) UploadObject *currentUpload;

-(BOOL)isInChallengeMode; 
-(NSString *)challengeTag; 
-(NSString *)challengeCategory;


@end
