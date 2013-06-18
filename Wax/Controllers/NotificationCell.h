//
//  NotificationCell.h
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#define kNotificationCellID @"NotificationCellID"

#import "WaxTableViewCell.h"

@class NotificationObject;

@interface NotificationCell : WaxTableViewCell

@property (nonatomic, strong) NotificationObject *noteObject;


@property (strong, nonatomic) IBOutlet UIImageView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *notificationLabel;

@end
