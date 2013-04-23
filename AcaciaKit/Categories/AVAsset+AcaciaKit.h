//
//  AVAsset+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 1/5/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface AVAsset (AcaciaKit)

+(NSNumber *)orientationOfAsset:(AVAsset *)asset;

@end
