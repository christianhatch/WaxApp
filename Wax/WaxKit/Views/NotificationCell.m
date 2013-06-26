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
    [self.notificationLabel setWaxHeaderFont];
}

-(void)setUpView{
    NotificationObject *note = self.noteObject;

    if (note.noteType != NotificationTypeVote || note.noteType != NotificationTypeTitleEarned) {
        
        self.profilePictureView.hidden = NO;
        
        __block NotificationCell *blockSelf = self;
        [self.profilePictureView setImageForProfilePictureWithUserID:self.noteObject.userID buttonHandler:^(UIImageView *imageView) {
            ProfileViewController *profy = [ProfileViewController profileViewControllerFromUserID:note.userID username:note.username];
            [[blockSelf nearestNavigationController] pushViewController:profy animated:YES];
        }];
        
    }else{
        self.profilePictureView.hidden = YES; 
    }
    
    self.notificationLabel.text = note.noteText;
    
}

#pragma mark - Setters
-(void)setNoteObject:(NotificationObject *)noteObject{
    if (_noteObject != noteObject) {
        _noteObject = noteObject;
        [self setUpView];
    }
}


@end
