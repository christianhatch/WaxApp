//
//  CategoryCell.h
//  Wax
//
//  Created by Christian Hatch on 6/17/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#define kCategoryCellHeight 60
#define kCategoryCellID @"CategoryCellID"


#import "WaxTableViewCell.h"

@interface CategoryCell : WaxTableViewCell

@property (nonatomic, strong) NSString *category;

@property (strong, nonatomic) IBOutlet UIImageView *categoryIconView;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;

@end
