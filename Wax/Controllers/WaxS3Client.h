//
//  WaxS3Client.h
//  Wax
//
//  Created by Christian Hatch on 5/25/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "AFAmazonS3Client.h"

@interface WaxS3Client : AFAmazonS3Client

+ (WaxS3Client *)sharedClient;

-(void)uploadProfilePicture:(UIImage *)profilePicture
                   progress:(void (^)(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
                 completion:(void (^)(id responseObject, NSError *error))completion;

-(void)putObjectWithFile:(NSString *)path
         destinationPath:(NSString *)destinationPath
              parameters:(NSDictionary *)parameters
                progress:(void (^)(CGFloat percentage, NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite))progress
              completion:(void (^)(id responseObject, NSError *error))completion;


@end
