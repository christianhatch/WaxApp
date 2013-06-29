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


@end

@implementation NotificationCell
@synthesize profilePictureView, textLabel; 
@synthesize noteObject = _noteObject;

-(void)awakeFromNib{
    [super awakeFromNib];
    [self.notificationLabel setWaxHeaderFontOfSize:12];
    self.notificationLabel.minimumScaleFactor = 0.4; 
}

-(void)setUpView{
    NotificationObject *note = self.noteObject;

    self.notificationLabel.text = note.noteText;

    switch (note.noteType) {
        case NotificationTypeFollow:
        case NotificationTypeTitleStolen:
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
        
}

#pragma mark - Setters
-(void)setNoteObject:(NotificationObject *)noteObject{
    if (_noteObject != noteObject) {
        _noteObject = noteObject;
        [self setUpView];
    }
}


@end
