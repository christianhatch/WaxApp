//
//  FeedCell.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

static inline NSString *stringFromActivityType(NSString *activityType){
    NSString *type = nil; 
    if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
        type = @"Copy to Clipboard";
    }else if ([activityType isEqualToString:UIActivityTypeMail]){
        type = @"Email";
    }else if ([activityType isEqualToString:UIActivityTypeMessage]){
        type = @"Text or iMessage";
    }else if ([activityType isEqualToString:UIActivityTypePostToFacebook]){
        type = @"Facebook";
    }else if ([activityType isEqualToString:UIActivityTypePostToTwitter]){
        type = @"Twitter";
    }else{
        type = activityType; 
    }
    return type;
}


#import "FeedCell.h"

@interface FeedCell ()

//the user
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

//the video
@property (strong, nonatomic) AIKMoviePlayer *moviePlayer;
@property (strong, nonatomic) IBOutlet UIButton *competitionTitleButton;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankWordLabel;

//action buttons
@property (strong, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *respondButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *voteButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *sendChallengeButton;

@property (nonatomic, readonly) RIButtonItem *actionSheetButtonShare;
@property (nonatomic, readonly) RIButtonItem *actionSheetButtonDelete;
@property (nonatomic, readonly) RIButtonItem *actionSheetButtonFlag;
@property (nonatomic, readonly) NSURL *thumbnailURL;
@property (nonatomic, readonly) NSURL *videoStreamingURL;
@property (nonatomic, readonly) AIKMoviePlayerBeginPlaybackBlock beginPlaybackBlock; 

- (IBAction)shareButtonAction:(id)sender;
- (IBAction)respondButtonAction:(id)sender;
- (IBAction)voteButtonAction:(id)sender;
- (IBAction)competitionTitleButtonAction:(id)sender;
- (IBAction)sendChallengeButtonAction:(id)sender;

@end

@implementation FeedCell
@synthesize profilePictureView, usernameLabel, timestampLabel, moviePlayer = _moviePlayer, competitionTitleButton, rankLabel, shareButton, respondButton, voteButton;
@synthesize videoObject = _videoObject;

#pragma mark - Overrides
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.usernameLabel setWaxHeaderFont];
    [self.timestampLabel setWaxDetailFont];
    
    [self.competitionTitleButton setTitleColor:[UIColor waxRedColor] forState:UIControlStateNormal];
    [self.competitionTitleButton setTitleColor:[UIColor waxDefaultFontColor] forState:UIControlStateHighlighted];
    self.competitionTitleButton.titleLabel.font = [UIFont waxHeaderFontItalicsOfSize:15];
    self.competitionTitleButton.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.competitionTitleButton.titleLabel.adjustsLetterSpacingToFitWidth = YES;
    self.competitionTitleButton.titleLabel.minimumScaleFactor = 0.2;
    
    [self.rankWordLabel setWaxDetailFont];
    self.rankWordLabel.text = NSLocalizedString(@"Rank", @"Rank"); 
    [self.rankLabel setWaxHeaderFont];
    
    [self.respondButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.respondButton setImage:[UIImage imageNamed:@"feedCell_challenge_icon"] forState:UIControlStateNormal];
    [self.respondButton setImage:[UIImage imageNamed:@"feedCell_challenge_iconOn"] forState:UIControlStateHighlighted];
    [self.respondButton setFillColor:[UIColor waxRedColor] forState:UIControlStateHighlighted];
    
    [self.sendChallengeButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.sendChallengeButton setImage:[UIImage imageNamed:@"feedCell_forward_icon"] forState:UIControlStateNormal];
    [self.sendChallengeButton setImage:[UIImage imageNamed:@"feedCell_forward_iconOn"] forState:UIControlStateHighlighted];
    [self.sendChallengeButton setFillColor:[UIColor colorWithHex:0xEAF746] forState:UIControlStateHighlighted];
    
    [self.voteButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_vote_icon"] forState:UIControlStateNormal];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_vote_iconOn"] forState:UIControlStateHighlighted];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_voted_icon"] forState:UIControlStateDisabled]; 
    [self.voteButton setFillColor:[UIColor colorWithHex:0x106DC2] forState:UIControlStateHighlighted];
    [self.voteButton setFillColor:[UIColor colorWithHex:0xE4F0F4] forState:UIControlStateDisabled];
    
    [self.shareButton setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"downarrow_on"] forState:UIControlStateHighlighted];
}
-(void)setVideoObject:(VideoObject *)videoObject{
    if ([videoObject isKindOfClass:[VideoObject class]]) {
        if (_videoObject != videoObject) {
            _videoObject = videoObject;
            [self setUpView];
        }
    }else if ([videoObject isKindOfClass:[NSDictionary class]]) {
        
        VideoObject *newVideo = [[VideoObject alloc] initWithDictionary:(NSDictionary *)videoObject];
        
        if ([newVideo isKindOfClass:[VideoObject class]]) {
            _videoObject = newVideo;
            [self setUpView];
        }
        
    }else{
        [AIKErrorManager logMessage:[NSString stringWithFormat:@"Setting video object on feedcell is not a video object. Object attempted to set %@", videoObject]];
    }
}
-(void)prepareForReuse{
    [self setUpMoviePlayer];
    [self.profilePictureView setImage:nil animated:YES];
    [super prepareForReuse];
}

-(void)setUpView{
    VideoObject *video = self.videoObject;
    
    __block FeedCell *blockSelf = self; 
    
    [self.profilePictureView setImageForProfilePictureWithUserID:video.userID buttonHandler:^(UIImageView *imageView) {
        
        NSString *userID = blockSelf.videoObject.userID;
        NSString *username = blockSelf.videoObject.username;
        UINavigationController *nav = [blockSelf nearestNavigationController];

        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromUserID:userID username:username];
        [nav pushViewController:pvc animated:YES];
    }];
    
    [self setUpMoviePlayer];
    
    self.usernameLabel.text = video.username;
    self.timestampLabel.text = video.timeStamp;
    self.rankLabel.text = video.rank;

    [self.competitionTitleButton setTitleForAllControlStates:video.tag];
    
    [self setupVoteButton];
}

-(void)setUpMoviePlayer{
    if (!self.moviePlayer) {
        CGFloat belowProfilePicture = (self.profilePictureView.bounds.size.height + self.profilePictureView.frame.origin.y + 5);
        CGRect movieFrame = CGRectMake(self.contentView.bounds.origin.x, belowProfilePicture, self.bounds.size.width+1, self.bounds.size.width);
        self.moviePlayer = [AIKMoviePlayer moviePlayerWithFrame:movieFrame thumbnailURL:self.thumbnailURL videoStreamingURL:self.videoStreamingURL playbackBeginBlock:self.beginPlaybackBlock];
        [self.contentView addSubview:self.moviePlayer];
    }else{
        [self.moviePlayer resetWithNewThumbnailURL:self.thumbnailURL andVideoURL:self.videoStreamingURL playbackBeginBlock:self.beginPlaybackBlock];
    }
}

#pragma mark - IBActions
- (IBAction)shareButtonAction:(id)sender {
    if (self.videoObject.isMine) {
        [[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:self.actionSheetButtonDelete otherButtonItems:self.actionSheetButtonShare, nil] showInView:self];
    }else{
        [[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:self.actionSheetButtonFlag otherButtonItems:self.actionSheetButtonShare, nil] showInView:self];
    }
}

- (IBAction)respondButtonAction:(id)sender {
    [[VideoUploadManager sharedManager] askToRespondToChallengeWithBlock:^(BOOL allowedToProceed) {
        if (allowedToProceed) {
            [[VideoUploadManager sharedManager] beginUploadProcessWithVideoID:self.videoObject.videoID competitionTag:self.videoObject.tag category:self.videoObject.category];
            
            VideoCameraViewController *video = [[VideoCameraViewController alloc] init];
            [self.nearestViewController presentViewController:video animated:YES completion:nil];
        }
    }];
}
    
- (IBAction)voteButtonAction:(id)sender {

    self.videoObject.didVote = YES;
    [self setupVoteButton]; //immediate user feedback upon pressing button
    
    [[WaxAPIClient sharedClient] voteUpVideoID:self.videoObject.videoID ofUser:self.videoObject.userID completion:^(BOOL complete, NSError *error) {
      
        self.videoObject.didVote = complete; 
        [self setupVoteButton]; //will change to actual value upon completion of the request, so if it fails you can try it again
        
        if (error) {
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Error voting up video :(", @"error voting up video string")]; 
            DDLogError(@"error voting :(");
        }
    }];
}

- (IBAction)competitionTitleButtonAction:(id)sender {
    FeedViewController *pvc = [FeedViewController feedViewControllerWithTag:self.videoObject.tag];
    [self.nearestNavigationController pushViewController:pvc animated:YES];
}

- (IBAction)sendChallengeButtonAction:(id)sender {
    [AIKErrorManager logMessage:@"User tapped send challenge to friend button"];
    
    SendChallengeViewController *send = [SendChallengeViewController sendChallengeViewControllerWithChallengeTag:self.videoObject.tag challengeVideoID:self.videoObject.videoID shareURL:[NSURL shareURLFromShareID:self.videoObject.shareID]];
    [self.nearestNavigationController pushViewController:send animated:YES];
}


#pragma mark - Convenience Methods
-(void)setupVoteButton{
    self.voteButton.enabled = (!self.videoObject.didVote && !self.videoObject.isMine);
}
-(void)resetVideoPlayer{
    [self.moviePlayer resetMoviePlayer];
}

-(RIButtonItem *)actionSheetButtonShare{
    RIButtonItem *share = [RIButtonItem itemWithLabel:NSLocalizedString(@"Share", @"Share")];
    share.action = ^{
        UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:self.videoObject.sharingActivityItems applicationActivities:nil];
        share.completionHandler = ^(NSString *activityType, BOOL completed){
            
            if (completed) {
                [AIKErrorManager logMessage:[NSString stringWithFormat:@"User shared video using %@", stringFromActivityType(activityType)]];
                
                if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Copied to Clipboard!", @"Copied to Clipboard!")];
                }
                
            }else{
                [AIKErrorManager logMessage:@"User canceled sharing from feed cell"];
            }
        };
        
        [self.nearestViewController presentViewController:share animated:YES completion:nil];
    };
    return share; 
}

-(RIButtonItem *)actionSheetButtonFlag{
    
    RIButtonItem *confirmFlag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report Inapropriate", @"Feed cell report inapropriate button label")];
    confirmFlag.action = ^{
        RIButtonItem *flag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report", @"Report")];
        flag.action = ^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeReport onVideoID:self.videoObject.videoID completion:^(BOOL complete, NSError *error) {
                if (!error) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Thank you!", @"Thank you!")]; 
                }else{
                    [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Reporting Video", @"Error Reporting Video") error:error buttonHandler:nil logError:NO]; 
                }
            }];
        };
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are You Sure?", @"Are You Sure?") message:NSLocalizedString(@"Are you sure you want to flag this video as inapropriate?", @"Feed cell flag confirmation label") cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:flag, nil] show];
    };
    return confirmFlag; 
}
-(RIButtonItem *)actionSheetButtonDelete{

    RIButtonItem *confirmDelete = [RIButtonItem itemWithLabel:NSLocalizedString(@"Delete Video", @"Feed cell delete video button label")];
    confirmDelete.action = ^{
        RIButtonItem *delete = [RIButtonItem itemWithLabel:NSLocalizedString(@"Delete", @"Delete")];
        delete.action = ^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeDelete onVideoID:self.videoObject.videoID completion:^(BOOL complete, NSError *error) {
                FeedTableView *table = (FeedTableView *)[self superview];
                [table deleteCellAtIndexPath:[table indexPathForCell:self]];
            }];
        };
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are You Sure?", @"Are You Sure?") message:NSLocalizedString(@"Are you sure you want to delete your video?", @"Feed cell delete confirmation label") cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:delete, nil] show];
    };
    return confirmDelete;
}

-(NSURL *)thumbnailURL{
    return [NSURL thumbnailURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID];
}
-(NSURL *)videoStreamingURL{
    return [NSURL streamingURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID];
}

-(AIKMoviePlayerBeginPlaybackBlock)beginPlaybackBlock{
    return ^{
        [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeView onVideoID:self.videoObject.videoID completion:nil];
        
        FeedTableView *supe = (FeedTableView *)self.superview;
        [AIKErrorManager logMessage:[NSString stringWithFormat:@"User played video from %@ feed", StringFromFeedTableViewType(supe.tableViewType)]];

    }; 
}









@end