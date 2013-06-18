//
//  NotificationCell.m
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "NotificationCell.h"

@implementation NotificationCell
@synthesize profilePictureView, textLabel; 
@synthesize noteObject = _noteObject;

-(void)setUpView{
    NotificationObject *note = self.noteObject;

    if (note.noteType != NotificationTypeVote || note.noteType != NotificationTypeTitleEarned) {
        __block NotificationCell *blockSelf = self;
        [self.profilePictureView setImageForProfilePictureWithUserID:self.noteObject.userID buttonHandler:^(UIImageView *imageView) {
            ProfileViewController *profy = [ProfileViewController profileViewControllerFromUserID:note.userID username:note.username];
            [[blockSelf nearestNavigationController] pushViewController:profy animated:YES];
        }];
    }else{
        [self.profilePictureView setCircular:NO]; 
        [self.profilePictureView setImageWithURL:[NSURL thumbnailURLFromUserID:note.userID andVideoID:note.videoID] placeholderImage:nil animated:YES completion:nil];
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
