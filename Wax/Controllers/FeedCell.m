//
//  FeedCell.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "FeedCell.h"

@implementation FeedCell
@synthesize profilePictureView, usernameLabel, timestampLabel, moviePlayer = _moviePlayer, competitionLabel, rankLabel, actionButton, challengeButton, voteButton, videoObject = _videoObject;

-(void)setUpView{
    VideoObject *video = self.videoObject;
    self.usernameLabel.text = video.username;
    self.timestampLabel.text = video.timeStamp;
    self.competitionLabel.text = video.tag;
    self.rankLabel.text = [NSString stringWithFormat:@"%@/%@", video.rank, video.tagCount];
    
    [self.profilePictureView setImageWithURL:[NSURL profilePictureURLFromUserID:video.userID] placeholderImage:nil animated:YES andEnableAsButtonWithButtonHandler:^(UIImageView *imageView) {
        DLog(@"show profile yay!"); 
    } completion:nil];
    
    [self addSubview:self.moviePlayer];
}
-(void)setVideoObject:(VideoObject *)videoObject{
    if (_videoObject != videoObject) {
        _videoObject = videoObject;
        [self setUpView];
    }
}


#pragma mark - Getters
-(AIKMoviePlayer *)moviePlayer{
    if (!_moviePlayer) {
        CGFloat bottomPlus8 = (self.profilePictureView.frame.size.height + self.profilePictureView.frame.origin.y + 8); 
        CGRect movieFrame = CGRectMake(self.profilePictureView.frame.origin.x, bottomPlus8, 300, 300);
        _moviePlayer = [AIKMoviePlayer moviePlayerWithFrame:movieFrame thumbnailURL:[NSURL videoThumbnailURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] videoStreamingURL:[NSURL streamingURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] playbackBeginBlock:^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeView onVideoID:self.videoObject.videoID completion:nil]; 
        }];
    }
    return _moviePlayer; 
}



#pragma mark - IBActions
- (IBAction)actionButtonAction:(id)sender {
    DLog(@"present sharing actionsheet"); 
}

- (IBAction)challengeButtonAction:(id)sender {
    DLog(@"present challenge actionsheet"); 
}

- (IBAction)voteButtonAction:(id)sender {
    [[WaxAPIClient sharedClient] voteUpVideoID:self.videoObject.videoID ofUser:self.videoObject.userID completion:^(BOOL complete, NSError *error) {
        if (!error) {
            [SVProgressHUD showSuccessWithStatus:self.videoObject.didVote ? NSLocalizedString(@"Unvoted!", @"Unvoted!") : NSLocalizedString(@"Voted!", @"Voted!")];
            self.videoObject.didVote = !self.videoObject.didVote; 
        }else{
            DLog(@"error voting :("); 
        }
    }];
}









@end