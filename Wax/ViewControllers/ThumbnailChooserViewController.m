//
//  ThumbnailChooserViewController.m
//  Wax
//
//  Created by Christian Hatch on 6/1/13.
//  Copyright (c) 2013 Acacia Interactive. All rights reserved.
//

#import "ThumbnailChooserViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ShareViewController.h"

@interface ThumbnailChooserViewController ()
@property (nonatomic, strong) MPMoviePlayerController *player; 
@end

@implementation ThumbnailChooserViewController
@synthesize directionsLabel, thumbPreview1, thumbPreview2, thumbPreview3, thumbPreview4, thumbPreview5, thumbPreview6, player = _player; 

#pragma mark - View Lifecycle
- (void)viewDidLoad{
    [super viewDidLoad];
    [self setUpView];
    
    for (UIImageView *imageView in @[self.thumbPreview1, self.thumbPreview2, self.thumbPreview3, self.thumbPreview4, self.thumbPreview5, self.thumbPreview6]) {
        imageView.clipsToBounds = YES;
        imageView.layer.borderColor = [UIColor blackColor].CGColor;
        imageView.layer.borderWidth = (imageView.bounds.size.width/100);
        
        [imageView enableAsButtonWithButtonHandler:^(UIImageView *imageView) {
            
            [[VideoUploadManager sharedManager] addThumbnailImage:imageView.image withOrientation:self.videoOrientation];
            
            ShareViewController *shareVC = initViewControllerWithIdentifier(@"ShareVC");
            [self.navigationController pushViewController:shareVC animated:YES];
            
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(thumbnailAvailable:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.player];
    
    CGFloat intervalTime = (float)self.videoDuration/7;
    NSMutableArray *times = [NSMutableArray arrayWithCapacity:6];
    for (int i = 1; i < 8; i++) {
        CGFloat multiplied = (float)intervalTime * i; 
        [times addObject:[NSNumber numberWithFloat:multiplied]];
    }
    
    [self.player requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionExact];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)setUpView{
    [self.directionsLabel setWaxDefaultFont];
    self.directionsLabel.text = NSLocalizedString(@"Choose a cover for your video by tapping one below", @"Choose a thumbnail for your video by tapping one below");
    self.navigationItem.title = NSLocalizedString(@"Thumbnail", @"Thumbnail");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
}
-(void)cancel:(id)sender{
    [[VideoUploadManager sharedManager] askToExitThumbnailChooserWithBlock:^(BOOL allowedToProceed) {
        if (allowedToProceed) {
            [AIKErrorManager logMessageToAllServices:@"User canceled from thumbnail chooser"];
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}


#pragma mark - Getters
-(MPMoviePlayerController *)player{
    if (!_player) {
        _player = [[MPMoviePlayerController alloc] initWithContentURL:self.videoPath];
        [_player stop];
    }
    return _player;
}



#pragma mark - Internal Methods
-(void)thumbnailAvailable:(NSNotification *)note{
    [self setNextPreviewThumbnail:[note.userInfo objectForKeyOrNil:MPMoviePlayerThumbnailImageKey]];
}

-(void)setNextPreviewThumbnail:(UIImage *)image{
    if (!self.thumbPreview1.image) {
        [self.thumbPreview1 setImage:image animated:YES];
    }else if (!self.thumbPreview2.image){
        [self.thumbPreview2 setImage:image animated:YES];
    }else if (!self.thumbPreview3.image){
        [self.thumbPreview3 setImage:image animated:YES];
    }else if (!self.thumbPreview4.image){
        [self.thumbPreview4 setImage:image animated:YES];
    }else if (!self.thumbPreview5.image){
        [self.thumbPreview5 setImage:image animated:YES];
    }else if (!self.thumbPreview6.image){
        [self.thumbPreview6 setImage:image animated:YES];
    }
}


-(NSUInteger)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];

}


@end
