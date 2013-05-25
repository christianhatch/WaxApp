//
//  WaxS3Client.m
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxS3Client.h"
#import <AFKissXMLRequestOperation/AFKissXMLRequestOperation.h>

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
        [self registerHTTPOperationClass:[AFKissXMLRequestOperation class]];
    }
    return self;
}

-(void)uploadProfilePicture:(UIImage *)profilePicture progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
    
    //resize to 100x100!!!

    NSData *picData = UIImageJPEGRepresentation([UIImage cropImageToSquare:profilePicture], 0.01);
    [picData writeToFile:[NSString libraryFilePathByAppendingFileName:@"profile_picture" andExtension:@"jpg"] atomically:YES];
    
    [self putObjectWithFile:[NSString libraryFilePathByAppendingFileName:@"profile_picture" andExtension:@"jpg"] destinationPath:[NSString s3ProfilePictureKeyFromUserid:[[WaxUser currentUser] userID]] parameters:nil progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
        if (progress) {
            CGFloat proggy = (totalBytesWritten/totalBytesExpectedToWrite);
            progress(proggy, bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
        }
    } completion:^(id responseObject, NSError *error) {
        if (completion) {
            completion(responseObject, error); 
        }
    }]; 
}
-(void)putObjectWithFile:(NSString *)path destinationPath:(NSString *)destinationPath parameters:(NSDictionary *)parameters progress:(void (^)(CGFloat, NSUInteger, long long, long long))progress completion:(void (^)(id, NSError *))completion{
    
     [self putObjectWithFile:path destinationPath:destinationPath parameters:parameters progress:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
         if (progress) {
             CGFloat proggy = (totalBytesWritten/totalBytesExpectedToWrite); 
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
