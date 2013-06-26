//
//  TagCell.h
//  Wax
//
//  Created by Christian Hatch on 6/21/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kTagCellID @"TagCellID"

#import "WaxTableViewCell.h"

@class TagObject; 

@interface TagCell : WaxTableViewCell

@property (nonatomic, strong) TagObject *tagObject;

@property (strong, nonatomic) IBOutlet UILabel *tagLabel;

@end
