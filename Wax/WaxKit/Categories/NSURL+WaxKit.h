//
//  NSURL+AcaciaKit.h
//  Kiwi
//
//  Created by Christian Hatch on 12/9/12.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (WaxKit)

+(NSURL *)videoURLForSquaring; 
+(NSURL *)streamingURLFromUserid:(NSString *)userid videoLink:(NSString *)videoLink;
+(NSURL *)profilePictureURLFromUserid:(NSString *)userid; 
+(NSURL *)videoThumbnailURLFromUserid:(NSString *)userid videoLink:(NSString *)videoLink; 
+(NSURL *)shareURLFromShareId:(NSString *)shareId; 

    
@end
