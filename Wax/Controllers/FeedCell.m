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
    [self.challengeButton setTitleForAllControlStates:NSLocalizedString(@"Challenge", @"Challenge")];
    [self.voteButton setTitleColor:[UIColor orangeColor] forState:UIControlStateDisabled];
    [self.actionButton rotateByDegrees:180 duration:0]; 
}
-(void)setUpView{
    VideoObject *video = self.videoObject;

    __block FeedCell *blockSelf = self;
    
    [self.profilePictureView setImageForProfilePictureWithUserID:video.userID buttonHandler:^(UIImageView *imageView) {
        ProfileViewController *pvc = [ProfileViewController profileViewControllerFromUserID:blockSelf.videoObject.userID username:blockSelf.videoObject.username];
        UIViewController *vc = [blockSelf nearestViewController];
        [vc.navigationController pushViewController:pvc animated:YES];
    }];
    
    [self.contentView addSubview:self.moviePlayer];

    self.usernameLabel.text = video.username;
    self.timestampLabel.text = video.timeStamp;
    
    [self.competitionNameButton setTitleForAllControlStates:video.tag]; 
    self.rankLabel.text = [NSString stringWithFormat:@"%@/%@", video.rank, video.tagCount];
    
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
        CGRect movieFrame = CGRectMake(0, bottomPlus8, self.bounds.size.width, self.bounds.size.width);
        _moviePlayer = [AIKMoviePlayer moviePlayerWithFrame:movieFrame thumbnailURL:[NSURL thumbnailURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] videoStreamingURL:[NSURL streamingURLFromUserID:self.videoObject.userID andVideoID:self.videoObject.videoID] playbackBeginBlock:^{
            [[WaxAPIClient sharedClient] performAction:WaxAPIClientVideoActionTypeView onVideoID:self.videoObject.videoID completion:nil]; 
        }];
    }
    return _moviePlayer; 
}



#pragma mark - IBActions
- (IBAction)actionButtonAction:(id)sender {

    UIActionSheet *sheet = nil; 
    
    if (self.videoObject.isMine) {
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:[self deleteButton] otherButtonItems:[self shareButton], nil];
    }else{
        sheet = [[UIActionSheet alloc] initWithTitle:nil cancelButtonItem:[RIButtonItem cancelButton] destructiveButtonItem:[self flagButton] otherButtonItems:[self shareButton], nil];
    }
    
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


- (IBAction)competitionNameButtonAction:(id)sender {
    FeedViewController *pvc = [FeedViewController feedViewControllerWithTag:self.videoObject.tag];
    UIViewController *vc = [self nearestViewController];
    [vc.navigationController pushViewController:pvc animated:YES];
}


#pragma mark - Convenience Methods
-(void)setupVoteButton{
    self.voteButton.enabled = !self.videoObject.didVote;
    [self.voteButton setTitleForAllControlStates:self.videoObject.didVote ? NSLocalizedString(@"Voted!", @"Voted!") : NSLocalizedString(@"Vote Up!", @"Vote Up!")];
}


-(RIButtonItem *)shareButton{
    RIButtonItem *share = [RIButtonItem itemWithLabel:NSLocalizedString(@"Share", @"Share")];
    [share setAction:^{
        UIActivityViewController *share = [[UIActivityViewController alloc] initWithActivityItems:@[self.videoObject.sharingString] applicationActivities:nil];
        share.completionHandler = ^(NSString *activityType, BOOL completed){
            
            if (completed) {
                [[AIKErrorManager sharedManager] logMessageToAllServices:[NSString stringWithFormat:@"User shared video using %@", stringFromActivityType(activityType)]];
                
                if ([activityType isEqualToString:UIActivityTypeCopyToPasteboard]) {
                    [SVProgressHUD showSuccessWithStatus:NSLocalizedString(@"Link Copied to Clipboard!", @"Copied to Clipboard!")];
                }
            }else{
                [[AIKErrorManager sharedManager] logMessageToAllServices:@"User canceled sharing from feed cell"];
            }
        };
        
        [[self nearestViewController] presentViewController:share animated:YES completion:nil];
    }];
    return share; 
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