//
//  UIImageView+WaxKit.m
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "UIImageView+WaxKit.h"

@implementation UIImageView (WaxKit)


-(void)setImageForProfilePictureWithUserID:(NSString *)userID buttonHandler:(AcaciaKitImageViewButtonHandler)handler{

    [self setCircular:YES borderColor:[UIColor waxTableViewCellSelectionColor]];
    
    if (userID) {
        
        NSURL *url = [NSURL profilePictureURLFromUserID:userID];
        NSURLRequestCachePolicy cachePolicy = NSURLRequestUseProtocolCachePolicy;
        
        if ([WaxUser userIDIsCurrentUser:userID]) {
            cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData; 
        }
        
        if (handler) {
            [self setImageWithURL:url cachePolicy:cachePolicy placeholderImage:nil animated:YES andEnableAsButtonWithButtonHandler:handler completion:nil];
        }else{
            [self setImageWithURL:url cachePolicy:cachePolicy placeholderImage:nil animated:YES completion:nil];
        }
    }
}

@end
