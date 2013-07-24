//
//  FeedCell.h
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableViewCell.h"

#define kFeedCellHeight 472
#define kFeedCellID @"FeedCellID"


@interface FeedCell : WaxTableViewCell

@property (nonatomic, strong) VideoObject *videoObject; 

-(void)resetVideoPlayer; 

@end
