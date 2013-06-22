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
#import "ProfileViewController.h"

@implementation FeedCell
@synthesize profilePictureView, usernameLabel, timestampLabel, moviePlayer = _moviePlayer, competitionNameButton, rankLabel, actionButton, challengeButton, voteButton, videoObject = _videoObject;

-(void)awakeFromNib{
    [self.challengeButton setTitleForAllControlStates:NSLocalizedString(@"Do It!", @"Do It!")];
    [self.sendChallengeButton setTitleForAllControlStates:NSLocalizedString(@"Send", @"Send")]; 
    [self.voteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];
    [self.actionButton rotateByDegrees:180 duration:0]; 
}
-(void)setUpView{
    VideoObject *video = self.videoObject;

    __block FeedCell *blockSelf = self;
    
    [self.profilePictureView setImageForProfilePictureWithUserID:video.userID buttonHandler:^(UIImageView *imageView) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromUserID:blockSelf.videoObject.userID username:blockSelf.videoObject.username];
        [[blockSelf nearestNavigationController] pushViewController:pvc animated:YES]; 
    }];
    
    [self setUpMoviePlayer];
    
    self.usernameLabel.text = video.username;
    self.timestampLabel.text = video.timeStamp;
    
    [self.competitionNameButton setTitleForAllControlStates:video.tag]; 
    self.rankLabel.text = video.rankPositionInCompetition;
    
    [self setupVoteButton]; 
}
-(void)setVideoObject:(VideoObject *)videoObject{
    if (_videoObject != videoObject) {
        _videoObject = videoObject;
        [self setUpView];
    }
}
-(void)prepareForReuse{
    [self setUpMoviePlayer];
}
-(void)setUpMoviePlayer{
    if (!self.moviePlayer) {
        CGFloat bottomPlus8 = (self.profilePictureView.bounds.size.height + self.profilePictureView.frame.origin.y + 8);
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
    [self.voteButton setTitleForAllControlStates:self.videoObject.didVote ? NSLocalizedString(@"Voted!", @"Voted!") : NSLocalizedString(@"Vote Up!", @"Vote Up!")];
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
                    [AIKErrorManager showAlertWithTitle:NSLocalizedString(@"Thank You", @"Thank You") message:NSLocalizedString(@"Thank you for reporting this video. Our team will review it right away", @"Feed cell thank you for flagging video") buttonTitle:NSLocalizedString(@"You're Welcome", @"You're Welcome") buttonHandler:nil logError:NO];
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