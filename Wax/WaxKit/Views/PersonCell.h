//
//  PersonCell.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//


#define kPersonCellHeight 80
#define kPersonCellID @"PersonCellID" 

#import "WaxTableViewCell.h"

@class WaxFollowButton;

@interface PersonCell : WaxTableViewCell

@property (nonatomic, strong) PersonObject *person;

@property (nonatomic, readwrite) BOOL hidesFollowButton;


@end
