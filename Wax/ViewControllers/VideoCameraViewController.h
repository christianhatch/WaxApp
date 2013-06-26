//
//  VideoCameraViewController.h
//  Wax
//
//  Created by Christian Hatch on 5/30/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCameraViewController : UIImagePickerController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (nonatomic, getter = isRecording) BOOL recording;

-(void)dismissCamera;
-(void)chooseExisting;
-(void)switchCamera;


@end
