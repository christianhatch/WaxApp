//
//  FeedCell.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "FeedCell.h"
#import "ProfileViewController.h"

@implementation FeedCell
@synthesize profilePictureView, usernameLabel, timestampLabel, moviePlayer = _moviePlayer, competitionLabel, rankLabel, actionButton, challengeButton, voteButton, videoObject = _videoObject;

-(void)setUpView{
    VideoObject *video = self.videoObject;

    __block FeedCell *blockSelf = self;
    [self.profilePictureView setImageWithURL:[NSURL profilePictureURLFromUserID:video.userID] placeholderImage:nil animated:YES andEnableAsButtonWithButtonHandler:^(UIImageView *imageView) {
        
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromUserID:blockSelf.videoObject.userID username:blockSelf.videoObject.username];
        UIViewController *vc = [blockSelf nearestViewController];
        [vc.navigationController pushViewController:pvc animated:YES];
        
    } completion:nil];
    
    [self.contentView addSubview:self.moviePlayer];

    self.usernameLabel.text = video.username;
    self.timestampLabel.text = video.timeStamp;
    self.competitionLabel.text = video.tag;
    self.rankLabel.text = [NSString stringWithFormat:@"%@/%@", video.rank, video.tagCount];
    
    [self.challengeButton setTitleForAllControlStates:NSLocalizedString(@"Challenge", @"Challenge")];
    [self setupVoteButton]; 
}
-(void)setVideoObject:(VideoObject *)videoObject{
    if (_videoObject != videoObject) {
        _videoObject = videoObject;
        [self setUpView];
    }else{
        [self.moviePlayer resetMoviePlayer];
    }
}


#pragma mark - Getters
-(AIKMoviePlayer *)moviePlayer{
    if (!_moviePlayer) {
        CGFloat bottomPlus8 = (self.profilePictureView.bounds.size.height + self.profilePictureView.frame.origin.y + 8);
        CGRect movieFrame = CGRectMake(self.profilePictureView.frame.origin.x, bottomPlus8, 300, 300);
        _moviePlayer = [AIKMoviePlayer moviePlayerWithFrame:movieFrame thumbnailURL:[NSURL thumbnailURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] videoStreamingURL:[NSURL streamingURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] playbackBeginBlock:^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeView onVideoID:self.videoObject.videoID completion:nil]; 
        }];
    }
    return _moviePlayer; 
}



#pragma mark - IBActions
- (IBAction)actionButtonAction:(id)sender {
    UIActionSheet *sheet =  [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:nil destructiveButtonItem:nil otherButtonItems:[self flagButton], nil];
    if (self.videoObject.isMine) {
        [sheet addButtonItem:[self deleteButton]];
    }
    [sheet setCancelButtonIndex:[sheet addButtonItem:[RIButtonItem cancelButton]]];
    [sheet showInView:self];
}

- (IBAction)challengeButtonAction:(id)sender {
    [SVProgressHUD showErrorWithStatus:@"feature coming soon!"];
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


#pragma mark - Convenience Methods
-(void)setupVoteButton{
    self.voteButton.enabled = !self.videoObject.didVote;
    [self.voteButton setTitleForAllControlStates:self.videoObject.didVote ? NSLocalizedString(@"Voted!", @"Voted!") : NSLocalizedString(@"Vote Up!", @"Vote Up!")];
}
-(RIButtonItem *)flagButton{
    
    RIButtonItem *confirmFlag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report Innapropriate", @"Feed cell report innapropriate button label")];
    confirmFlag.action = ^{
        RIButtonItem *flag = [RIButtonItem itemWithLabel:NSLocalizedString(@"Report", @"Report")];
        flag.action = ^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeReport onVideoID:self.videoObject.videoID completion:^(BOOL complete, NSError *error) {
                if (!error) {
                    [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"Thank You", @"Thank You") message:NSLocalizedString(@"Thank you for reporting this video. Our team will review it right away", @"Feed cell thank you for flagging video") buttonTitle:NSLocalizedString(@"You're Welcome", @"You're Welcome") buttonHandler:nil logError:NO];
                }else{
                    [[AIKErrorManager sharedManager] showAlertWithTitle:NSLocalizedString(@"Error Reporting Video", @"Error Reporting Video") error:error buttonHandler:nil logError:NO]; 
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











@end