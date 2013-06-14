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

    [self setCircular:YES];
    
    NSURL *url = [NSURL profilePictureURLFromUserID:userID]; 
    if (handler) {
        [self setImageWithURL:url placeholderImage:nil animated:YES andEnableAsButtonWithButtonHandler:handler completion:nil];
    }else{
        [self setImageWithURL:url placeholderImage:nil animated:YES completion:nil];
    }
}

@end
