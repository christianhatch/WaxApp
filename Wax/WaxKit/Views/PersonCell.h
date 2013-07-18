//
//  PersonCell.h
//  Wax
//
//  Created by Christian Hatch on 6/13/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

typedef NS_ENUM(NSInteger, PersonCellType){
    PersonCellTypeDefault = 1,
    PersonCellTypeSendChallenge,
};

#define kPersonCellHeight 80
#define kPersonCellID @"PersonCellID"


#import "WaxTableViewCell.h"

@class WaxFollowButton;

@interface PersonCell : WaxTableViewCell

@property (nonatomic, strong) PersonObject *person;
@property (nonatomic) PersonCellType cellType; 

@end
