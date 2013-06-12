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
//    UIImageView *bg = [[UIImageView alloc] initWithFrame:self.bounds];
//    bg.image = [UIImage selectionGradient];
//    bg.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
//    self.selectedBackgroundView = bg;
}
-(void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
//    for (UIButton *btn in self.contentView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            [btn setSelected:NO];
//        }
//    }
}
-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
//    for (UIButton *btn in self.contentView.subviews) {
//        if ([btn isKindOfClass:[UIButton class]]) {
//            [btn setHighlighted:NO];
//        }
//    }
}

@end
