//
//  AVAsset+AcaciaKit.m
//  Kiwi
//
//  Created by Christian Hatch on 1/5/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "AVAsset+AcaciaKit.h"

@implementation AVAsset (AcaciaKit)

+(NSNumber *)orientationOfAsset:(AVAsset *)asset{
    AVAssetTrack *videoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize size = videoTrack.naturalSize;
    CGAffineTransform txf = videoTrack.preferredTransform;
    if (size.width == txf.tx && size.height == txf.ty)
        return [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
    else if (txf.tx == 0 && txf.ty == 0)
        return [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    else if (txf.tx == 0 && txf.ty == size.width)
        return [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
    else
        return [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
}

@end
