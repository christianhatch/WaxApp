//
//  UIButton+AFNetworking.m
//
//  Created by David Pettigrew on 6/12/12.
//  Copyright (c) 2012 ELC Technologies. All rights reserved.
//

// Based upon UIImageView+AFNetworking.m
//
// Copyright (c) 2011 Gowalla (http://gowalla.com/)
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UIButton+AcaciaKit.h"
#import <objc/runtime.h>
#import "AcaciaKit.h"


#if __IPHONE_OS_VERSION_MIN_REQUIRED

@interface AFButtonImageCache : NSCache
- (UIImage *)cachedImageForRequest:(NSURLRequest *)request;
- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request;
@end

#pragma mark -

static char kAFImageRequestOperationObjectKey;

@interface UIButton (_AFNetworking)
@property (readwrite, nonatomic, retain, setter = af_setImageRequestOperation:) AFImageRequestOperation *af_imageRequestOperation;
@end

@implementation UIButton (_AFNetworking)
@dynamic af_imageRequestOperation;
@end

#pragma mark -

@implementation UIButton (AFNetworking)

+(void)clearAFImageCache{
    [[[self class] af_sharedImageCache] removeAllObjects];
}

//- (void)setImageWithURL:(NSURL *)url
//andPlaceholderAnimation:(BOOL)placeholderAnimation{
//    
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPShouldHandleCookies:NO];
//    [request setHTTPShouldUsePipelining:YES];
//    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
//    
//    if (placeholderAnimation) {
//        [self.imageView setAnimationImages:@[[UIImage imageNamed:@"UIImageBGKiwiA1.png"], [UIImage imageNamed:@"UIImageBGKiwiA2.png"], [UIImage imageNamed:@"UIImageBGKiwiA3.png"], [UIImage imageNamed:@"UIImageBGKiwiA4.png"],  [UIImage imageNamed:@"UIImageBGKiwiA5.png"], [UIImage imageNamed:@"UIImageBGKiwiA6.png"],  [UIImage imageNamed:@"UIImageBGKiwiA7.png"], [UIImage imageNamed:@"UIImageBGKiwiA7.5.png"], [UIImage imageNamed:@"UIImageBGKiwiA8.png"], [UIImage imageNamed:@"UIImageBGKiwiA9.png"], [UIImage imageNamed:@"UIImageBGKiwiA10.png"],  [UIImage imageNamed:@"UIImageBGKiwiA11.png"], [UIImage imageNamed:@"UIImageBGKiwiA12.png"],  [UIImage imageNamed:@"UIImageBGKiwiA13.png"], [UIImage imageNamed:@"UIImageBGKiwiA14.png"],  [UIImage imageNamed:@"UIImageBGKiwiA15.png"],  [UIImage imageNamed:@"UIImageBGKiwiA16.png"], [UIImage imageNamed:@"UIImageBGKiwiA17.png"]]];
//        [self.imageView setAnimationDuration:.5];
//        [self.imageView startAnimating];
//    }
//    [self setImageWithURLRequest:request placeholderImage:nil forState:UIControlStateNormal success:nil failure:nil]; 
//}


- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage forState:(UIControlState)state {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPShouldHandleCookies:NO];
    [request setHTTPShouldUsePipelining:YES];
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage forState:state success:nil failure:nil];
}

- (void)setImageWithURLRequest:(NSURLRequest *)urlRequest 
              placeholderImage:(UIImage *)placeholderImage 
                      forState:(UIControlState)state
                       success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image))success
                       failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error))failure
{
    [self cancelImageRequestOperation];
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    UIImage *cachedImage = [[[self class] af_sharedImageCache] cachedImageForRequest:urlRequest];
    if (cachedImage) {
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //this is what i added here, just a simple crossdisolve
        [UIView transitionWithView:self.imageView duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
            [self setImage:cachedImage forState:state];
        } completion:nil];
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

        self.af_imageRequestOperation = nil;
        
        if (success) {
            success(nil, nil, cachedImage);
        }
    } else {
        [self setImage:placeholderImage forState:state];
        
        AFImageRequestOperation *requestOperation = [[AFImageRequestOperation alloc] initWithRequest:urlRequest];
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        //added this to try to fix this cashing issue
        [requestOperation setCacheResponseBlock:^NSCachedURLResponse *(NSURLConnection *connection, NSCachedURLResponse *cachedResponse) {
            return nil;
        }];
        //end of additions
        //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
           
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                //this is what i added here, just a simple crossdisolve
                [UIView transitionWithView:self.imageView duration:0.1 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [self setImage:responseObject forState:state];
                } completion:nil];
                //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                self.af_imageRequestOperation = nil;
            }
            
            if (success) {
                success(operation.request, operation.response, responseObject);
            }
            
            [[[self class] af_sharedImageCache] cacheImage:responseObject forRequest:urlRequest];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if ([[urlRequest URL] isEqual:[[self.af_imageRequestOperation request] URL]]) {
                self.af_imageRequestOperation = nil;
            }
            
            if (failure) {
                failure(operation.request, operation.response, error);
            }
            
        }];
        
        self.af_imageRequestOperation = requestOperation;
        
        [[[self class] af_sharedImageRequestOperationQueue] addOperation:self.af_imageRequestOperation];
    }
}

- (AFHTTPRequestOperation *)af_imageRequestOperation {
    return (AFHTTPRequestOperation *)objc_getAssociatedObject(self, &kAFImageRequestOperationObjectKey);
}

- (void)af_setImageRequestOperation:(AFImageRequestOperation *)imageRequestOperation {
    objc_setAssociatedObject(self, &kAFImageRequestOperationObjectKey, imageRequestOperation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (NSOperationQueue *)af_sharedImageRequestOperationQueue {
    static NSOperationQueue *_af_imageRequestOperationQueue = nil;
    
    if (!_af_imageRequestOperationQueue) {
        _af_imageRequestOperationQueue = [[NSOperationQueue alloc] init];
        [_af_imageRequestOperationQueue setMaxConcurrentOperationCount:8];
    }
    
    return _af_imageRequestOperationQueue;
}

+ (AFButtonImageCache *)af_sharedImageCache {
    static AFButtonImageCache *_af_imageCache = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _af_imageCache = [[AFButtonImageCache alloc] init];
    });
    
    return _af_imageCache;
}

#pragma mark -

- (void)cancelImageRequestOperation {
    [self.af_imageRequestOperation cancel];
    self.af_imageRequestOperation = nil;
}

@end

#pragma mark -

static inline NSString * AFButtonImageCacheKeyFromURLRequest(NSURLRequest *request) {
    return [[request URL] absoluteString];
}

@implementation AFButtonImageCache

- (UIImage *)cachedImageForRequest:(NSURLRequest *)request {
    switch ([request cachePolicy]) {
        case NSURLRequestReloadIgnoringCacheData:
        case NSURLRequestReloadIgnoringLocalAndRemoteCacheData:
            return nil;
        default:
            break;
    }
    
	return [self objectForKey:AFButtonImageCacheKeyFromURLRequest(request)];
}

- (void)cacheImage:(UIImage *)image
        forRequest:(NSURLRequest *)request
{
    if (image && request) {
        [self setObject:image forKey:AFButtonImageCacheKeyFromURLRequest(request)];
    }
}

@end

#endif