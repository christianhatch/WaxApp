//
//  VideoCameraViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/30/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "VideoCameraViewController.h"
#import <AcaciaKit/AIKVideoProcessor.h>
#import "VideoUploadManager.h"
#import "CameraOverlay.h"
#import "ThumbnailChooserViewController.h"

@implementation VideoCameraViewController{
    CameraOverlay *cameraControls;
}
@synthesize recording = _recording;

#pragma mark - View Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    cameraControls = [[CameraOverlay alloc] initWithFrame:[[[UIApplication sharedApplication] keyWindow] frame]];
    cameraControls.delegate = self;
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    self.showsCameraControls = NO;
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    self.cameraOverlayView = cameraControls;
    self.cameraOverlayView.alpha = 0;
    self.delegate = self;
    self.mediaTypes = @[(NSString *)kUTTypeMovie];
    self.allowsEditing = NO;
    [NSTimer scheduledTimerWithTimeInterval:1.7 target:self selector:@selector(showOverlay) userInfo:nil repeats:NO];
}
-(void)showOverlay{
    [UIView animateWithDuration:AIKDefaultAnimationDuration animations:^{
        self.cameraOverlayView.alpha = 1;
    }];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (self.sourceType == UIImagePickerControllerSourceTypeCamera) {
        self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    }
}
#pragma mark - Camera Overlay Delegate Methods
-(void)chooseExisting{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = @[(NSString *)kUTTypeMovie];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.videoQuality = UIImagePickerControllerQualityTypeHigh;
    picker.wantsFullScreenLayout = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)switchCamera{
    if(self.cameraDevice == UIImagePickerControllerCameraDeviceFront){
        self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    }else{
        self.cameraDevice = UIImagePickerControllerCameraDeviceFront;
        self.videoQuality = UIImagePickerControllerQualityType640x480;
    }
}
-(void)dismissCamera{
    [[VideoUploadManager sharedManager] askToCancelAndDeleteCurrentUploadWithBlock:^(BOOL cancelled) {
        if (cancelled) {
            [AIKErrorManager logMessageToAllServices:@"User Canceled from video camera"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
    if (picker != self) {
        [picker dismissViewControllerAnimated:YES completion:^{
            [self finishUpWithURL:videoURL];
        }];
    }else{
        [self finishUpWithURL:videoURL];
    }
    
}

#pragma mark - Internal Methods
-(void)finishUpWithURL:(NSURL *)url{
    
    NSInteger duration = cameraControls.currentTimer;
    
    [cameraControls resetOverlay];
    
    [[VideoUploadManager sharedManager] beginUploadProcessWithVideoFileURL:url videoDuration:[NSNumber numberWithInteger:duration]];
    
    UINavigationController *nav = initViewControllerWithIdentifier(@"ThumbnailNav");
    nav.navigationBarHidden = NO;
    
    ThumbnailChooserViewController *thumbVC = initViewControllerWithIdentifier(@"ThumbnailVC");
    thumbVC.videoPath = url;
    thumbVC.videoOrientation = [AVAsset orientationOfAsset:[AVAsset assetWithURL:url]];
    thumbVC.videoDuration = duration;
    nav.viewControllers = @[thumbVC];
    [self presentViewController:nav animated:YES completion:nil];
}


@end
