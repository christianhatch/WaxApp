//
//  ThumbnailChooserViewController.h
//  Wax
//
//  Created by Christian Hatch on 6/1/13.
//  Copyright (c) 2012 Acacia Interactive. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ThumbnailChooserViewController : UIViewController


@property (nonatomic, strong) NSURL *videoPath;
@property (nonatomic, assign) UIInterfaceOrientation videoOrientation;
@property (nonatomic, assign) NSInteger videoDuration;

@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview1;
@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview2;
@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview3;
@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview4;
@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview5;
@property (strong, nonatomic) IBOutlet UIImageView *thumbPreview6;

@property (strong, nonatomic) IBOutlet UILabel *directionsLabel;

@end
