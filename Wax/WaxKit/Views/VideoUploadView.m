//
//  VideoUploadView.m
//  Wax
//
//  Created by Christian Hatch on 7/20/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//



#import "VideoUploadView.h"

@interface VideoUploadView ()
@property (strong, nonatomic) IBOutlet UIImageView *thumbnailView;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *progressView;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityView;
@property (strong, nonatomic) IBOutlet UIButton *retryButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

- (IBAction)retryButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@property (nonatomic, copy) VideoUploadViewShouldShowHideBlock shouldShowBlock;
@property (nonatomic, copy) VideoUploadViewShouldShowHideBlock shouldHideBlock;
@end

@implementation VideoUploadView

+(VideoUploadView *)videoUploadViewWithShowBlock:(VideoUploadViewShouldShowHideBlock)shouldShowBlock shouldHideBlock:(VideoUploadViewShouldShowHideBlock)shouldHideBlock{
    VideoUploadView *vid = [[[NSBundle mainBundle] loadNibNamed:@"VideoUploadView" owner:self options:nil] firstObject];
    vid.shouldHideBlock = shouldHideBlock;
    vid.shouldShowBlock = shouldShowBlock;
    return vid; 
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [self setUpView];
    [self resetToDefaults];
}
-(void)setUpView{
    self.backgroundColor = [UIColor darkGrayColor];
    self.thumbnailView.layer.cornerRadius = 5;
    [self.progressView setProgressTintColor:[UIColor waxRedColor]];
    [self.statusLabel setWaxHeaderItalicsFontOfSize:14 color:[UIColor whiteColor]];
    [self setSelfAsVideoUploadManagerDelegate];
}
-(void)resetToDefaults{
    [self.progressView fadeOut];
    [self showProcessingVideoText];
    self.thumbnailView.image = nil;
}

-(void)setSelfAsVideoUploadManagerDelegate{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldHide) name:VideoUploadManagerDidCompleteEntireUploadSuccessfullyNotification object:nil];
    
    //video file
    [[VideoUploadManager sharedManager] setVideoFileUploadBeginBlock:^{
        [self showProgressText:NSLocalizedString(@"Uploading Video...", @"uploading video status text")]; 
    }];
    [[VideoUploadManager sharedManager] setVideoFileUploadProgressBlock:^(CGFloat progress){
        [self.progressView fadeIn];
        [self.progressView setProgress:progress animated:YES];
        [self showProgressText:NSLocalizedString(@"Uploading Video...", @"uploading video status text")];
    }];
    [[VideoUploadManager sharedManager] setVideoFileUploadCompletionBlock:^(BOOL success, NSError *error){
        if (success) {
            [self.progressView fadeOut];
            [self showSuccessText:NSLocalizedString(@"Uploaded Video!", @"video upload complete status text")];
        }else{
            [self showErrorText:NSLocalizedString(@"Upload Failed :(", @"upload failed text")]; 
        }
    }];
    
    //thumbnail
    [[VideoUploadManager sharedManager] setThumbnailUploadBeginBlock:^{
        [self.thumbnailView setImage:[VideoUploadManager sharedManager].thumbnailImage animated:YES];
        [self showProgressText:NSLocalizedString(@"Uploading Thumbnail...", @"uploading thumbnail status text")]; 
    }];
    [[VideoUploadManager sharedManager] setThumbnailUploadCompletionBlock:^(BOOL success, NSError *error){
        if (success) {
            [self.progressView fadeOut];
            [self showSuccessText:NSLocalizedString(@"Uploaded Thumbnail!", @"thumbnail upload complete status text")];
        }else{
            [self showErrorText:NSLocalizedString(@"Upload Failed :(", @"upload failed text")]; 
        }
    }];
    
    //metadata
    [[VideoUploadManager sharedManager] setMetadataUploadBeginBlock:^{
        [self showProgressText:NSLocalizedString(@"Finishing Upload...", @"uploading metadata status text")]; 
    }];
    [[VideoUploadManager sharedManager] setMetadataUploadCompletionBlock:^(BOOL success, NSError *error){
        if (success) {
            [self.activityView stopAnimating];
            [self.progressView fadeOut];
            self.statusLabel.text = NSLocalizedString(@"Finished Upload!", @"metadata upload complete status text");
            [self performSelector:@selector(shouldHide) withObject:nil afterDelay:1.5];
        }else{
            [self showErrorText:NSLocalizedString(@"Upload Failed :(", @"upload failed text")];
        }
    }];
}

- (IBAction)retryButtonAction:(id)sender {
    [[VideoUploadManager sharedManager] retryUpload];
    [self.thumbnailView setImage:[VideoUploadManager sharedManager].thumbnailImage animated:YES];
}

- (IBAction)cancelButtonAction:(id)sender {
    [[VideoUploadManager sharedManager] askToCancelFromUploadView:^(BOOL allowedToProceed) {
        if (allowedToProceed) {
            [self shouldHide];
        }
    }];
}

-(BOOL)shouldBeVisible{
    return [VideoUploadManager sharedManager].hasPendingOrFailedUpload;
}

-(void)shouldHide{
    if (self.shouldHideBlock) {
        self.shouldHideBlock(self);
    }
    [self resetToDefaults];
}
-(void)shouldShow{
    if (self.shouldShowBlock) {
        self.shouldShowBlock(self);
    }
}

-(void)showProgressText:(NSString *)statusText{
    [self shouldShow];
    [self.activityView startAnimating];
    self.statusLabel.textColor = [UIColor whiteColor];
    self.statusLabel.text = statusText;
}
-(void)showSuccessText:(NSString *)text{
    [self shouldShow];
    self.statusLabel.text = text;
    [self performSelector:@selector(showProcessingVideoText) withObject:nil afterDelay:0.5];
}
-(void)showErrorText:(NSString *)text{
    [self.activityView stopAnimating];
    self.statusLabel.textColor = [UIColor waxRedColor];
    self.statusLabel.text = text; 
}

//TODO: revamp this so that when it is processing it just always goes back to showing that its processing, but only when it IS processing
-(void)showProcessingVideoText{
    if ([VideoUploadManager sharedManager].isProcessingVideo) {
        [self showProgressText:NSLocalizedString(@"Processing Video", @"processing video status text")]; 
    }else{
        
    }
}





@end
