//
//  CameraOverlay.h
//  Kiwi
//
//  Created by Christian Michael Hatch on 6/28/12.
//  Copyright (c) 2012 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>


@class VideoCameraViewController;

@interface CameraOverlay : UIView{
    NSTimer *timer;
    NSTimer *videoTimer;
    bool recording;
    bool onImage;
    bool isFrontFacing;
}

@property (nonatomic, assign) NSInteger currentTimer;

@property (nonatomic, weak)  VideoCameraViewController *delegate;

-(void)resetOverlay;
-(void)swapCamera;
-(void)beginRecording;
-(void)cancelCamera;
-(void)showLoading; 

@end
