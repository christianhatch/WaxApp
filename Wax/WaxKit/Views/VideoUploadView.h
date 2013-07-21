//
//  VideoUploadView.h
//  Wax
//
//  Created by Christian Hatch on 7/20/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

@class VideoUploadView;

typedef void(^VideoUploadViewShouldShowHideBlock)(VideoUploadView *view);

#import <UIKit/UIKit.h>

@interface VideoUploadView : UIView

+(VideoUploadView *)videoUploadViewWithShowBlock:(VideoUploadViewShouldShowHideBlock)shouldShowBlock
                                 shouldHideBlock:(VideoUploadViewShouldShowHideBlock)shouldHideBlock;


@end
