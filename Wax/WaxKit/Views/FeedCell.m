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
@property (strong, nonatomic) IBOutlet UIButton *competitionNameButton;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;
@property (strong, nonatomic) IBOutlet UILabel *rankWordLabel;

//action buttons
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *challengeButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *voteButton;
@property (strong, nonatomic) IBOutlet WaxRoundButton *sendChallengeButton;

- (IBAction)actionButtonAction:(id)sender;
- (IBAction)challengeButtonAction:(id)sender;
- (IBAction)voteButtonAction:(id)sender;
- (IBAction)competitionNameButtonAction:(id)sender;
- (IBAction)sendChallengeButtonAction:(id)sender;

@end

@implementation FeedCell
@synthesize profilePictureView, usernameLabel, timestampLabel, moviePlayer = _moviePlayer, competitionNameButton, rankLabel, actionButton, challengeButton, voteButton, videoObject = _videoObject;

-(void)awakeFromNib{
    [self.usernameLabel setWaxHeaderFont];
    [self.timestampLabel setWaxDetailFont];
    [self.competitionNameButton styleFontAsWaxHeaderItalics];
    
    [self.rankWordLabel setWaxDetailFont];
    self.rankWordLabel.text = NSLocalizedString(@"Rank", @"Rank"); 
    [self.rankLabel setWaxHeaderFont];
    
//    [self.challengeButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Do It!", @"Do It!")];
    [self.challengeButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.challengeButton setImage:[UIImage imageNamed:@"feedCell_challenge_icon"] forState:UIControlStateNormal];
    [self.challengeButton setImage:[UIImage imageNamed:@"feedCell_challenge_iconOn"] forState:UIControlStateHighlighted];
    [self.challengeButton setFillColor:[UIColor waxRedColor] forState:UIControlStateHighlighted];
    
//    [self.sendChallengeButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Send", @"Send")];
    [self.sendChallengeButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.sendChallengeButton setImage:[UIImage imageNamed:@"feedCell_forward_icon"] forState:UIControlStateNormal];
    [self.sendChallengeButton setImage:[UIImage imageNamed:@"feedCell_forward_iconOn"] forState:UIControlStateHighlighted];
    [self.sendChallengeButton setFillColor:[UIColor greenColor] forState:UIControlStateHighlighted];
    
//    [self.voteButton styleAsWaxRoundButtonGreyWithTitle:NSLocalizedString(@"Vote Up!", @"Vote Up!")];
//    [self.voteButton setTitle:NSLocalizedString(@"Voted!", @"Voted!") forState:UIControlStateDisabled];
//    [self.voteButton setTitle:NSLocalizedString(@"Vote Up!", @"Vote Up!") forState:UIControlStateNormal]; 
    [self.voteButton styleAsWaxRoundButtonGreyWithTitle:nil];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_vote_icon"] forState:UIControlStateNormal];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_vote_iconOn"] forState:UIControlStateHighlighted];
    [self.voteButton setImage:[UIImage imageNamed:@"feedCell_voted_icon"] forState:UIControlStateDisabled]; 
    [self.voteButton setFillColor:[UIColor blueColor] forState:UIControlStateHighlighted];
    [self.voteButton setFillColor:[UIColor blueColor] forState:UIControlStateDisabled];
    [self.voteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    [self.voteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    [self.actionButton setImage:[UIImage imageNamed:@"downarrow"] forState:UIControlStateNormal];
    [self.actionButton setImage:[UIImage imageNamed:@"downarrow_on"] forState:UIControlStateHighlighted];
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
    
    [self.competitionNameButton setTitleForAllControlStates:video.tag]; 
    self.rankLabel.text = video.rankPositionInCompetition;
    
    [self setupVoteButton]; 
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
        [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"Setting video object on feedcell is not a video object. Object attempted to set %@", videoObject]];
    }
}
-(void)prepareForReuse{
    [self setUpMoviePlayer];
}

-(void)setUpMoviePlayer{
    if (!self.moviePlayer) {
        CGFloat bottomPlus8 = (self.profilePictureView.bounds.size.height + self.profilePictureView.frame.origin.y + 5);
        CGRect movieFrame = CGRectMake(0, bottomPlus8, self.bounds.size.width, self.bounds.size.width);
        self.moviePlayer = [AIKMoviePlayer moviePlayerWithFrame:movieFrame thumbnailURL:[self thumbnailURL] videoStreamingURL:[self streamingURL] playbackBeginBlock:[self beginPlayingBlock]];
        [self.contentView addSubview:self.moviePlayer];
    }else{
        [self.moviePlayer resetWithNewThumbnailURL:[self thumbnailURL] andVideoURL:[self streamingURL] playbackBeginBlock:[self beginPlayingBlock]];
    }
}



#pragma mark - IBActions
- (IBAction)actionButtonAction:(id)sender {

    if (self.videoObject.isMine) {
        [[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:[self deleteButton] otherButtonItems:[self shareButton], nil] showInView:self];
    }else{
        [[[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:[self flagButton] otherButtonItems:[self shareButton], nil] showInView:self];
    }
}

- (IBAction)challengeButtonAction:(id)sender {
    
    [[VideoUploadManager sharedManager] beginUploadProcessWithVideoID:self.videoObject.videoID competitionTag:self.videoObject.tag category:self.videoObject.category];
    [[NSNotificationCenter defaultCenter] postNotificationOnMainThreadName:kWaxNotificationPresentVideoCamera object:self]; 

}

- (IBAction)voteButtonAction:(id)sender {
    [[WaxAPIClient sharedClient] voteUpVideoID:self.videoObject.videoID ofUser:self.videoObject.userID completion:^(BOOL complete, NSError *error) {
        if (!error) {
            self.videoObject.didVote = YES;
            [self setupVoteButton]; 
        }else{
            DLog(@"error voting :("); 
        }
    }];
}


- (IBAction)competitionNameButtonAction:(id)sender {
    FeedViewController *pvc = [FeedViewController feedViewControllerWithTag:self.videoObject.tag];
    [[self nearestNavigationController] pushViewController:pvc animated:YES];
}

- (IBAction)sendChallengeButtonAction:(id)sender {
    [AIKErrorManager logMessageToAllServices:@"User tapped send challenge to friend button"];
    PersonListViewController *plvc = [PersonListViewController personListViewControllerForSendingChallengeWithTag:self.videoObject.tag];
    [[self nearestNavigationController] pushViewController:plvc animated:YES];
}


#pragma mark - Convenience Methods
-(void)setupVoteButton{
    self.voteButton.enabled = !self.videoObject.didVote;
}


-(RIButtonItem *)shareButton{
    RIButtonItem *share = [RIButtonItem itemWithLabel:NSLocalizedString(@"Share", @"Share")];
    share.action = ^{
        UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:self.videoObject.sharingActivityItems applicationActivities:nil];
        share.completionHandler = ^(NSString *activityType, BOOL completed){
            
            if (completed) {
                [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"User shared video using %@", stringFromActivityType(activityType)]];
                
                if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Link Copied to Clipboard!", @"Copied to Clipboard!")];
                }
            }else{
                [AIKErrorManager logMessageToAllServices:@"User canceled sharing from feed cell"];
            }
        };
        
        [[self nearestViewController] presentViewController:share animated:YES completion:nil];
    };
    return share; 
}



-(RIButtonItem *)flagButton{
    
    RIButtonItem *confirmFlag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report Innapropriate", @"Feed cell report innapropriate button label")];
    confirmFlag.action = ^{
        RIButtonItem *flag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report", @"Report")];
        flag.action = ^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeReport onVideoID:self.videoObject.videoID completion:^(BOOL complete, NSError *error) {
                if (!error) {
                    [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Thank You", @"Thank You") message:NSLocalizedString(@"Thank you for reporting this video. Our team will review it right away", @"Feed cell thank you for flagging video") buttonTitle:NSLocalizedString(@"You're Welcome", @"You're Welcome") showsCancelButton:NO buttonHandler:nil logError:NO];
                }else{
                    [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Error Reporting Video", @"Error Reporting Video") error:error buttonHandler:nil logError:NO]; 
                }
            }];
        };
        [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Are You Sure?", @"Are You Sure?") message:NSLocalizedString(@"Are you sure you want to flag this video as innapropriate?", @"Feed cell flag confirmation label") cancelButtonItem:[RIButtonItem cancelButton] otherButtonItems:flag, nil] show];
    };
    return confirmFlag; 
}
-(RIButtonItem *)deleteButton{

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
-(NSURL *)streamingURL{
    return [NSURL streamingURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID];
}

-(AIKMoviePlayerBeginPlaybackBlock)beginPlayingBlock{
    return ^{
        [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeView onVideoID:self.videoObject.videoID completion:nil];
        
        FeedTableView *supe = (FeedTableView *)self.superview;
        [AIKErrorManager logMessageToAllServices:[NSString stringWithFormat:@"User played video from %@ feed", StringFromFeedTableViewType(supe.tableViewType)]];

    }; 
}









@end