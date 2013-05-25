//
//  WaxS3Client.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxS3Client.h"

@implementation WaxS3Client

+ (WaxS3Client *)sharedClient{
    static WaxS3Client *_sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedClient = [[WaxS3Client alloc] initWithAccessKeyID:kThirdPartyAWSAccessKey secret:kThirdPartyAWSSecretKey];
    });
    return _sharedClient;
}
-(id)initWithAccessKeyID:(NSString *)accessKey secret:(NSString *)secret{
    self = [super initWithAccessKeyID:accessKey secret:secret];
    if (self) {
        self.bucket = kThirdPartyAWSBucket; 
    }
    return self;
}

-(void)uploadProfilePicture:(UIImage *)profilePicture progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
    
    //resize to 100x100!!!

    [UIImage asyncSaveImage:[UIImage cropImageToSquare:profilePicture] asJPEGInLibraryWithFilename:@"profile_picture" quality:0.01 completion:^(NSString *path) {
        [self putObjectWithFile:path destinationPath:[NSString s3ProfilePictureKeyFromUserid:[[WaxUser currentUser] userID]] parameters:nil progress:progress completion:completion];
    }];
}

-(void)uploadVideoAtPath:(NSString *)path progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
    
    [self putObjectWithFile:path destinationPath:[NSString s3VideoKeyFromUserid:[[WaxUser currentUser] userID] andVideoLink:nil] parameters:nil progress:progress completion:completion];
}
-(void)uploadThumbnail:(UIImage *)thumbnail progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
        
    [UIImage asyncSaveImage:thumbnail asJPEGInLibraryWithFilename:@"thumbnail" quality:0.8 completion:^(NSString *path) {
        [self putObjectWithFile:path destinationPath:[NSString s3ProfilePictureKeyFromUserid:[[WaxUser currentUser] userID]] parameters:nil progress:progress completion:completion];
    }];

}










-(void)putObjectWithFile:(NSString *)path destinationPath:(NSString *)destinationPath parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
    
     [self putObjectWithFile:path destinationPath:destinationPath parameters:parameters progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
         if (progress) {
             CGFloat proggy = (float)(totalBytesWritten/totalBytesExpectedToWrite); 
             progress(proggy, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
         }
     } success:^(id responseObject) {
         if (completion) {
             completion(responseObject, nil);
         }
     } failure:^(NSError *error) {
         if (completion) {
             completion(nil, error);
         }
     }]; 
}




@end
