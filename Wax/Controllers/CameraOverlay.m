
//  CameraOverlay.m
//  Wax
//
//  Created by Christian Michael Hatch on 6/1/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "CameraOverlay.h"
#import "VideoCameraViewController.h"

@interface CameraOverlay ()
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *recordButton;
@property (nonatomic, strong) UIButton *flipButton;

@property (nonatomic, strong) UIButton *chooseButton;
@property (nonatomic, strong) UIButton *flashButton;

@property (nonatomic, strong) UILabel *videoTimerLabel;
@property (nonatomic, strong) UIImageView *bg;

@property (nonatomic, strong) UIActivityIndicatorView *loadingActivity;
@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIView *loadingBG;

@property (nonatomic, readwrite) UIDeviceOrientation currentOrientation;
@property (nonatomic, strong) NSArray *viewsToRotate; 

@end

@implementation CameraOverlay

@synthesize delegate, recordButton, cancelButton, flipButton, videoTimerLabel, chooseButton, flashButton, loadingActivity, loadingLabel, bg, loadingBG, currentOrientation = _currentOrientation, viewsToRotate, currentTimer = _currentTimer;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configure]; 
    }
    return self;
}
-(void)configure{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil]; 
    
    self.hidden = NO;
    CGFloat bottom = self.frame.size.height;
    CGFloat centerX = self.center.x;
    
    self.bg = [[UIImageView alloc] initWithFrame:self.frame];
    self.bg.image = [UIImage imageNamed:[UIDevice isRetina4Inch] ? @"captureBG-568h@2x.png" : @"captureBG.png"];
    self.bg.alpha = 1;
    [self addSubview:self.bg];
    
    //add cancel button
    self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cancelButton.frame = CGRectMake(0, bottom - 156, 160, 78);
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"exitbg.png"] forState:UIControlStateNormal];
    [self.cancelButton setBackgroundImage:[UIImage imageNamed:@"exitbgOn.png"] forState:UIControlStateHighlighted];
    [self.cancelButton setImage:[UIImage imageNamed:@"exit.png"] forState:UIControlStateNormal];
    [self.cancelButton setImage:[UIImage imageNamed:@"exitOn.png"] forState:UIControlStateHighlighted];
    [self.cancelButton setImage:[UIImage imageNamed:@"exitDisabled.png"] forState:UIControlStateDisabled];
    [self.cancelButton setImageEdgeInsets:UIEdgeInsetsMake(-2, -52, 0, 0)];
    [self.cancelButton addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.cancelButton];
    
    //add switch button
    self.flipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flipButton.frame = CGRectMake(160, bottom - 78, 160, 78);
    [self.flipButton setBackgroundImage:[UIImage imageNamed:@"switchbg.png"] forState:UIControlStateNormal];
    [self.flipButton setBackgroundImage:[UIImage imageNamed:@"switchbgOn.png"] forState:UIControlStateHighlighted];
    [self.flipButton setImage:[UIImage imageNamed:@"switch.png"] forState:UIControlStateNormal];
    [self.flipButton setImage:[UIImage imageNamed:@"switchOn.png"] forState:UIControlStateHighlighted];
    [self.flipButton setImage:[UIImage imageNamed:@"switchDisabled.png"] forState:UIControlStateDisabled];
    [self.flipButton setImageEdgeInsets:UIEdgeInsetsMake(0, 52, 0, 0)];
    [self.flipButton addTarget:self action:@selector(swapCamera) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.flipButton];
    isFrontFacing = NO;
    
    //add choose button
    self.chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseButton.frame = CGRectMake(0, bottom - 78, 160, 78);
    [self.chooseButton setBackgroundImage:[UIImage imageNamed:@"choosebg.png"] forState:UIControlStateNormal];
    [self.chooseButton setBackgroundImage:[UIImage imageNamed:@"choosebgOn.png"] forState:UIControlStateHighlighted];
    [self.chooseButton setImage:[UIImage imageNamed:@"choose.png"] forState:UIControlStateNormal];
    [self.chooseButton setImage:[UIImage imageNamed:@"chooseOn.png"] forState:UIControlStateHighlighted];
    [self.chooseButton setImage:[UIImage imageNamed:@"chooseDisabled.png"] forState:UIControlStateDisabled];
    [self.chooseButton setImageEdgeInsets:UIEdgeInsetsMake(-2, -52, 0, 0)];
    [self.chooseButton addTarget:self action:@selector(chooseExisting) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.chooseButton];
    
    //add flashbutton
    self.flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.flashButton.frame = CGRectMake(160, bottom - 156, 160, 78);
    [self.flashButton setBackgroundImage:[UIImage imageNamed:@"lightbg.png"] forState:UIControlStateNormal];
    [self.flashButton setBackgroundImage:[UIImage imageNamed:@"lightbgOn.png"] forState:UIControlStateHighlighted];
    [self.flashButton setImage:[UIImage imageNamed:@"light.png"] forState:UIControlStateNormal];
    [self.flashButton setImage:[UIImage imageNamed:@"lightOn.png"] forState:UIControlStateHighlighted];
    [self.flashButton setImage:[UIImage imageNamed:@"lightDisabled.png"] forState:UIControlStateDisabled];
    [self.flashButton setImageEdgeInsets:UIEdgeInsetsMake(0, 52, 0, 0)];
    [self.flashButton addTarget:self action:@selector(cameraFlashAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.flashButton];
    
    //add videotimer
    self.currentTimer = 0;
    self.videoTimerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.videoTimerLabel.center = CGPointMake(280, 40);
    self.videoTimerLabel.textAlignment = NSTextAlignmentCenter;
    self.videoTimerLabel.font = [UIFont waxHeaderFontOfSize:14];
    self.videoTimerLabel.text = [NSString stringWithFormat:@"00:0%i", self.currentTimer];
    self.videoTimerLabel.textColor = [UIColor whiteColor];
    self.videoTimerLabel.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.75];
    self.videoTimerLabel.layer.borderColor = [UIColor blackColor].CGColor;
    self.videoTimerLabel.layer.borderWidth = 0.5; 
    [self addSubview:self.videoTimerLabel];
    
    //add record button
    self.recordButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.recordButton.frame = CGRectMake(0, 0, 105, 105);
    self.recordButton.center = CGPointMake(centerX, bottom - 78);
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"record_reg.png"] forState:UIControlStateNormal];
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"record_on.png"] forState:UIControlStateHighlighted];
    [self.recordButton addTarget:self action:@selector(beginRecording) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.recordButton];
    
    [self initFlipAndFlashButtons];
    
    self.viewsToRotate = @[self.cancelButton.imageView, self.flipButton.imageView, self.chooseButton.imageView, self.flashButton.imageView, self.videoTimerLabel];
    for (UIView *view in self.viewsToRotate) {
        view.clipsToBounds = NO;
        view.contentMode = UIViewContentModeCenter; 
    }
}
- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    //Ignoring specific orientations
    if (orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || self.currentOrientation == orientation) {
        return;
    }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(handleOrientationChange) object:nil];
    
    //Responding only to changes in landscape or portrait
    self.currentOrientation = orientation;
    
    [self performSelectorOnMainThread:@selector(handleOrientationChange) withObject:nil waitUntilDone:NO];
}
-(void)handleOrientationChange{
//    DLog(@"orientation changed to: %i", self.currentOrientation); 
    switch (self.currentOrientation) {
        case UIDeviceOrientationLandscapeLeft:{
            [self rotateViewsByDegrees:90];
        }break;
        case UIDeviceOrientationLandscapeRight:{
            [self rotateViewsByDegrees:-90];
        }break;
        case UIDeviceOrientationPortrait:{
            [self rotateViewsByDegrees:0];
        }break;
        case UIDeviceOrientationPortraitUpsideDown:{
            [self rotateViewsByDegrees:180];
        }break;
        default:{
            
        }break;
    }
}
-(void)rotateViewsByDegrees:(CGFloat)degrees{
    for (UIView *view in self.viewsToRotate) {
        [view rotateByDegrees:degrees duration:0.3];
    }
}
-(void)chooseExisting{
    [self.delegate chooseExisting]; 
}
-(void)cameraFlashAction{
    if ([UIImagePickerController isFlashAvailableForCameraDevice:self.delegate.cameraDevice]) {
        switch (self.delegate.cameraFlashMode) {
            case UIImagePickerControllerCameraFlashModeOff:{
                [self.flashButton setImage:[UIImage imageNamed:@"lightClicked.png"] forState:UIControlStateNormal];
                self.delegate.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
            }break;
            case UIImagePickerControllerCameraFlashModeOn:{
                [self.flashButton setImage:[UIImage imageNamed:@"light.png"] forState:UIControlStateNormal];
                self.delegate.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
            }break;
            case UIImagePickerControllerCameraFlashModeAuto:{
                //no
            }break;
        }
    }else{
        
    }
}

-(void)startVideoTimer{
    videoTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(countdown) userInfo:nil repeats:YES]; 
}

-(void)stopVideoTimer{
    [videoTimer invalidate]; 
}

-(void)countdown{
    self.currentTimer ++;
    if (self.currentTimer < 10) {
        self.videoTimerLabel.text = [NSString stringWithFormat:@"00:0%i", self.currentTimer];
    }else if (self.currentTimer <= 59) {
        self.videoTimerLabel.text = [NSString stringWithFormat:@"00:%i", self.currentTimer];
    }else if (self.currentTimer > 59) {
        self.videoTimerLabel.text = [NSString stringWithFormat:@"01:0%i", self.currentTimer - 60];
        if (self.currentTimer > 69) {
            self.videoTimerLabel.text = [NSString stringWithFormat:@"01:%i", self.currentTimer - 60];
            if (self.currentTimer >= 80 && self.currentTimer < 85) {
                [UIView transitionWithView:self.videoTimerLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.videoTimerLabel.textColor = [UIColor colorWithHex:0xF4FA58];
                } completion:^(BOOL finished) {
                    [UIView transitionWithView:self.videoTimerLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.videoTimerLabel.textColor = [UIColor lightGrayColor];
                    } completion:nil];
                }];
            }
            if (self.currentTimer >= 85) {
                [UIView transitionWithView:self.videoTimerLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    self.videoTimerLabel.textColor = [UIColor colorWithHex:0xFE2E2E];
                } completion:^(BOOL finished) {
                    [UIView transitionWithView:self.videoTimerLabel duration:0.5 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                        self.videoTimerLabel.textColor = [UIColor lightGrayColor];
                    } completion:nil];
                }];
            }
        }
    }
}
-(void)initFlipAndFlashButtons{
    self.flashButton.enabled = [UIImagePickerController isFlashAvailableForCameraDevice:self.delegate.cameraDevice];
    self.flipButton.enabled = [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront]; 
}
-(void)swapCamera{
    [self.delegate switchCamera];
    [self initFlipAndFlashButtons];
}
-(void)swapImage{
    [UIView transitionWithView:self.recordButton duration:0.45 options:UIViewAnimationOptionTransitionCrossDissolve | UIViewAnimationOptionAllowUserInteraction animations:^{
        [self.recordButton setBackgroundImage:[UIImage imageNamed:onImage ? @"record_on.png" : @"record_flash.png"] forState:UIControlStateNormal];
    } completion:nil];
    onImage=!onImage;
}
-(void)stopBlink{
    [timer invalidate];
}
-(void)startBlink{
    timer = [NSTimer scheduledTimerWithTimeInterval:0.45 target:self selector:@selector(swapImage) userInfo:nil repeats:YES];
}
-(void)beginRecording{
    if(!recording){
        self.flipButton.enabled = NO;
        self.cancelButton.enabled = NO;
        self.chooseButton.enabled = NO;
        [self.recordButton setBackgroundImage:[UIImage imageNamed:@"record_flash.png"] forState:UIControlStateNormal];
        onImage = YES;
        [self.delegate startVideoCapture];
        [self startBlink];
        [self startVideoTimer]; 
    }else{
        [self.delegate stopVideoCapture];
        [self showLoading];
        [self stopVideoTimer];
        [self stopBlink];
    }
    recording = !recording;
}
-(void)showLoading{    
    self.loadingBG = [[UIView alloc] initWithFrame:self.bounds];
    self.loadingBG.backgroundColor = [UIColor blackColor];
    self.loadingBG.alpha = 0;
    [self addSubview:self.loadingBG];

    self.loadingActivity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];

    CGPoint centerl = self.center;
    centerl.y -= 40;
    self.loadingActivity.center = centerl;
    
    self.loadingActivity.alpha = 0;
    self.loadingActivity.hidesWhenStopped = YES;
    [self.loadingBG addSubview:self.loadingActivity];
    [self.loadingActivity startAnimating]; 
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.loadingLabel.text = [[NSUserDefaults standardUserDefaults] boolForKey:kUserSaveToCameraRollKey] ? @"finishing \n & \n saving to camera roll" : @"finishing";
    self.loadingLabel.numberOfLines = 0;
    self.loadingLabel.textColor = [UIColor whiteColor];
    self.loadingLabel.backgroundColor = [UIColor clearColor]; 
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.loadingLabel sizeToFit];
    self.loadingLabel.alpha = 0;
    CGPoint centery = self.center;
    centery.y += 20; 
    self.loadingLabel.center = centery;
    [self.loadingBG addSubview:self.loadingLabel];
    
    [UIView animateWithDuration:0.55 animations:^{
        self.loadingActivity.alpha = 1;
        self.loadingLabel.alpha = 1;
        self.loadingBG.alpha = 0.7;
    } completion:^(BOOL finished) {

    }];
}
-(void)cancelCamera{
    [self stopVideoTimer];
    [self stopBlink];
    [self initFlipAndFlashButtons];
    if (self.delegate.recording) {
        [self.delegate stopVideoCapture];
    }
    [self.delegate dismissCamera];
}

-(void)resetOverlay{
    [self stopVideoTimer];
    [self stopBlink];
    [self initFlipAndFlashButtons];
    
    self.cancelButton.enabled = YES;
    self.chooseButton.enabled = YES;

    self.currentTimer = 0;
    recording = NO;
    onImage = NO; 
    [self.recordButton setBackgroundImage:[UIImage imageNamed:@"record_reg.png"] forState:UIControlStateNormal];
    self.videoTimerLabel.text = [NSString stringWithFormat:@"00:0%i", self.currentTimer];
    
    [self.loadingActivity stopAnimating];
    [self.loadingBG removeFromSuperview];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self]; 
}
@end
