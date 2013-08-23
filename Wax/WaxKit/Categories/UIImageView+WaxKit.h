//
//  UIImageView+WaxKit.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WaxKitImageViewButtonHandler)(UIImageView *imageView);

@interface UIImageView (WaxKit)

-(void)setImageForProfilePictureWithUserID:(NSString *)userID buttonHandler:(WaxKitImageViewButtonHandler)handler;


@end
