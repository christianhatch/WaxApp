//
//  NotificationCell.m
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationCell.h"

@interface NotificationCell ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;
@property (strong, nonatomic) IBOutlet UILabel *timestampLabel;


@end

@implementation NotificationCell
@synthesize profilePictureView, notificationLabel, timestampLabel;
@synthesize noteObject = _noteObject;

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.notificationLabel setWaxDefaultFont];
    [self.timestampLabel setWaxDetailFont]; 
}

-(void)setUpView{
    NotificationObject *note = self.noteObject;

    self.notificationLabel.text = note.noteText;
    self.timestampLabel.text = note.timeStamp;
    
    switch (note.noteType) {
        case NotificationTypeFollow:
        case NotificationTypeTitleStolen:
        case NotificationTypeChallenged:
        case NotificationTypeChallengeResponse:{
                                
            [self.profilePictureView setImageForProfilePictureWithUserID:self.noteObject.userID buttonHandler:nil];
            
        }break;
        case NotificationTypeVote:{
            [self.profilePictureView setImage:[UIImage imageNamed:@"title_icon"] animated:YES]; 
        }break;
        case NotificationTypeTitleEarned:{
            [self.profilePictureView setImage:[UIImage imageNamed:@"upVote_icon"] animated:YES]; 
        }break;
    }
    
    if (note.unread) {
        self.backgroundColor = [[UIColor waxRedColor] colorWithAlphaComponent:0.3]; 
    }else{
        self.backgroundColor = [UIColor whiteColor];
    }
}

#pragma mark - Setters
-(void)setNoteObject:(NotificationObject *)noteObject{
    if (_noteObject != noteObject) {
        _noteObject = noteObject;
        [self setUpView];
    }
}


@end
