//
//  VideoCameraViewController.m
//  Wax
//
//  Created by Christian Hatch on 5/30/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "VideoCameraViewController.h"

@implementation VideoCameraViewController

#pragma mark - View Lifecycle
-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    self.videoQuality = UIImagePickerControllerQualityTypeIFrame1280x720;
    self.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
    self.delegate = self;
    self.mediaTypes = @[(NSString *)kUTTypeMovie];
    self.allowsEditing = NO;

}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - UIImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
    [AIKVideoProcessor sharedProcessor];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
}


@end
