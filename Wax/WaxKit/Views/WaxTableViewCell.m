//
//  WaxTableViewCell.m
//  Wax
//
//  Created by Christian Hatch on 6/7/13.
//  Copyright (c) 2013 Christian Hatch. All rights reserved.
//

#import "WaxTableViewCell.h"

@implementation WaxTableViewCell


-(void)awakeFromNib{
    UIView *bg = [[UIView alloc] initWithFrame:self.bounds];
    bg.backgroundColor = [UIColor waxTableViewCellSelectionColor];
    bg.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    self.selectedBackgroundView = bg;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}



@end
