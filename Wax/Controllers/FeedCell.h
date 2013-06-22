//
//  FeedCell.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableViewCell.h"

#define kFeedCellHeight 467
#define kFeedCellID @"FeedCellID"

@class AIKMoviePlayer;

@interface FeedCell : WaxTableViewCell

@property (nonatomic, strong) VideoObject *videoObject; 

//the user
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;

//the video
@property (strong, nonatomic) AIKMoviePlayer *moviePlayer;
@property (strong, nonatomic) IBOutlet UIButton *competitionNameButton;
@property (strong, nonatomic) IBOutlet UILabel *rankLabel;

//action buttons
@property (strong, nonatomic) IBOutlet UIButton *actionButton;
@property (strong, nonatomic) IBOutlet UIButton *challengeButton;
@property (strong, nonatomic) IBOutlet UIButton *voteButton;
@property (strong, nonatomic) IBOutlet UIButton *sendChallengeButton;

- (IBAction)actionButtonAction:(id)sender;
- (IBAction)challengeButtonAction:(id)sender;
- (IBAction)voteButtonAction:(id)sender;
- (IBAction)competitionNameButtonAction:(id)sender;
- (IBAction)sendChallengeButtonAction:(id)sender;



@end
