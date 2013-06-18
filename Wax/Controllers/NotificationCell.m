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

    [self.profilePictureView setImageForProfilePictureWithUserID:self.noteObject.userID buttonHandler:^(UIImageView *imageView) {
        
    }];
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
